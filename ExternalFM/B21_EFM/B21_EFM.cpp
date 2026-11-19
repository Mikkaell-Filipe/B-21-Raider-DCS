//=========================================================================//
//  B21_EFM.cpp - External Flight Model do B-21 Raider (DCS World)
//
//  - Aerodinamica 6-DoF (B21_Aerodata.h): tabelas M x alpha, efeito solo,
//    elevons, split-drag rudders, trem, baia, dano de asa
//  - FBW/SAS (amortecedores p/q/r, limitador de alpha, auto-trim 1 g)
//  - 2 turbofans (partida, spool, empuxo, consumo, dano), empuxo por motor
//  - Combustivel (queima via ed_fm_change_mass)
//  - Trem, portas, baia, escada, REVO, luzes, freios, NWS, draw args
//  Eixos DCS: +x frente, +y cima, +z direita.
//=========================================================================//
#include <cmath>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <cstddef>

#include "B21_Aerodata.h"

#ifndef B21_STANDALONE_TEST

#ifdef _WIN32
  #define EXPORT_ED_FM_PHYSICS_IMP extern "C" __declspec(dllexport)
  #define B21_API extern "C" __declspec(dllexport)
#else
  #define EXPORT_ED_FM_PHYSICS_IMP extern "C" __attribute__((visibility("default")))
  #define B21_API extern "C" __attribute__((visibility("default")))
#endif
#include "FM/wHumanCustomPhysicsAPI_ImplementationDeclare.h"

namespace A = B21::Aerodata;

// IDs de comando: devem bater com Cockpit/Scripts/command_defs.lua (Keys.*)
namespace Cmd
{
    constexpr int PITCH = 2001, ROLL = 2002, YAW = 2003, THROTTLE = 2004;
    constexpr int BRAKE_AXIS = 2111, BRAKE_AXIS_L = 2112, BRAKE_AXIS_R = 2113;
    constexpr int GEAR_TOGGLE = 68, GEAR_UP = 430, GEAR_DOWN = 431;
    constexpr int AIRBRAKE_TOGGLE = 73, AIRBRAKE_ON = 147, AIRBRAKE_OFF = 148;
    constexpr int LIGHTS_TOGGLE = 175;
    // PATCH: comandos padrao do DCS que o EFM nao tratava (Autostart/Autostop e freio de roda)
    constexpr int WHEEL_BRAKE_ON = 74, WHEEL_BRAKE_OFF = 75;
    constexpr int ENGINES_START = 309, ENGINES_STOP = 310;
    constexpr int PITCH_DOWN_START = 193, PITCH_DOWN_STOP = 194, PITCH_UP_START = 195, PITCH_UP_STOP = 196;
    constexpr int ROLL_LEFT_START = 197, ROLL_LEFT_STOP = 198, ROLL_RIGHT_START = 199, ROLL_RIGHT_STOP = 200;
    constexpr int RUDDER_LEFT_START = 201, RUDDER_LEFT_STOP = 202, RUDDER_RIGHT_START = 203, RUDDER_RIGHT_STOP = 204;
    constexpr int THROTTLE_UP_START = 1032, THROTTLE_DOWN_START = 1033, THROTTLE_STOP = 1034;
    // Customizados (command_defs.lua)
    constexpr int ENG_START_L = 10001, ENG_START_R = 10002, ENG_STOP_L = 10003, ENG_STOP_R = 10004;
    constexpr int ENG_START_ALL = 10005, ENG_STOP_ALL = 10006;
    constexpr int BRAKES_ON = 10007, BRAKES_OFF = 10008, PARK_BRAKE = 10009;
    constexpr int BAY_TOGGLE = 10010, STAIRS_TOGGLE = 10011, REVO_TOGGLE = 10012;
    constexpr int LAND_LIGHT = 10013, TAXI_LIGHT = 10014, BEACON_LIGHT = 10015;
    constexpr int NWS_TOGGLE = 10016, SAS_TOGGLE = 10017;
    constexpr int TRIM_UP = 10018, TRIM_DOWN = 10019, TRIM_RESET = 10020;
}

// Draw args do B-21.edm (tabela do usuario)
namespace Arg
{
    // Args reais do externo.blend (B-21.edm). PATCH: antes usava args que o modelo nao tem.
    constexpr int NOSE_GEAR = 0;
    constexpr int R_GEAR = 3, L_GEAR = 5;
    constexpr int NOSE_STEER = 2, NOSE_STEER_MODEL = 506;   // 2 = padrao DCS, 506 = c_wheel do modelo
    // No modelo, 11/15 sao ESQUERDOS e 12/16 DIREITOS (inverso do que o EFM assumia)
    constexpr int L_AILERON = 11, R_AILERON = 12;
    constexpr int L_ELEVATOR = 15, R_ELEVATOR = 16;
    constexpr int RUDDER = 17;                               // LeftRudder + RightRudder no mesmo arg
    constexpr int REVO = 22;
    constexpr int BAY_L = 500, BAY_R = 501;
    constexpr int SPOILER_L = 502, SPOILER_R = 503;
    constexpr int LAUNCH_BAR = 504;
    constexpr int LIGHT_BEACON = 193, LIGHT_LANDING = 208, LIGHT_TAXI = 209;
    // Ajuste se a animacao do Blender estiver invertida
    constexpr double AILERON_SIGN = +1.0;   // +1 = bordo de fuga para baixo
    constexpr double ELEVATOR_SIGN = -1.0;  // elevon interno: cabrar = -(TE baixo)
}

namespace
{
    inline double clampd(double v, double lo, double hi) { return v < lo ? lo : (v > hi ? hi : v); }
    inline double slew(double cur, double tgt, double step)
    {
        const double d = tgt - cur;
        if (d > step) return cur + step;
        if (d < -step) return cur - step;
        return tgt;
    }
    inline double lag(double cur, double tgt, double tau, double dt)
    {
        if (tau <= 1.0e-6) return tgt;
        return cur + (tgt - cur) * (1.0 - std::exp(-dt / tau));
    }

    struct Axis
    {
        double value = 0.0, keyDir = 0.0, rate = 1.6;
        bool analog = false;
        void update(double dt)
        {
            if (keyDir != 0.0) value = clampd(value + keyDir * rate * dt, -1.0, 1.0);
            else if (!analog) value = slew(value, 0.0, rate * 1.5 * dt);
        }
        void setAnalog(double v) { value = clampd(v, -1.0, 1.0); analog = true; keyDir = 0.0; }
        void keyStart(double d) { keyDir = d; analog = false; }
        void keyStop() { keyDir = 0.0; }
    };

    struct Engine
    {
        bool starting = false, running = false;
        double n1 = 0.0, thrust_N = 0.0, fuelFlow_kg_s = 0.0, integrity = 1.0, egt_C = 15.0, combustion = 0.0;
        static constexpr double kIdle = 0.38;
        static constexpr double kStartTime = 28.0;

        void cold() { starting = running = false; n1 = thrust_N = fuelFlow_kg_s = combustion = 0.0; egt_C = 15.0; }
        void hot(double n) { starting = false; running = true; n1 = n; }

        void update(double dt, double throttle, double fuelKg, double alt, double mach)
        {
            if (fuelKg <= 0.0 || integrity < 0.15) { running = false; starting = false; }
            if (starting && !running)
            {
                n1 += dt * (kIdle / kStartTime);
                if (n1 >= kIdle) { n1 = kIdle; running = true; starting = false; }
            }
            else if (running)
            {
                const double target = kIdle + (1.0 - kIdle) * clampd(throttle, 0.0, 1.0);
                n1 = lag(n1, target, (target > n1) ? 3.2 : 2.2, dt);
            }
            else
            {
                n1 = lag(n1, 0.0, 14.0, dt);
                if (n1 < 0.003) n1 = 0.0;
            }
            double frac = 0.0;
            if (running)
            {
                const double f = clampd((n1 - kIdle) / (1.0 - kIdle), 0.0, 1.0);
                frac = 0.04 + 0.96 * std::pow(f, 1.25);
            }
            frac *= clampd(integrity, 0.0, 1.0);
            thrust_N = A::installedThrustN(alt, mach, frac, 1, A::kThrustSLPerEngine);
            fuelFlow_kg_s = running ? std::max(0.18, A::tsfcKgNs(mach, frac) * thrust_N) : 0.0;
            combustion = running ? clampd(n1, 0.0, 1.0) : 0.0;
            egt_C = lag(egt_C, running ? (330.0 + 520.0 * n1) : 15.0 + 120.0 * n1, 6.0, dt);
        }
    };

    struct Model
    {
        double altitude_m = 0, temperature_K = 288.15, sound_speed = 340.29, density = 1.225, pressure = 101325.0, surfaceHeight_m = 0;
        double vx = 0, vy = 0, vz = 0, omegaX = 0, omegaY = 0, omegaZ = 0, nzBody = 1.0;
        double tas = 0, mach = 0, alpha = 0, beta = 0;
        double mass = 55000.0, fuelKg = 25000.0, pendingBurn_kg = 0.0;
        Axis pitch, roll, yaw;
        double throttleL = 0, throttleR = 0, throttleKeyDir = 0, throttleCmd = 0;
        bool throttleAxisActive = false;
        double brakeL = 0, brakeR = 0;
        bool brakeKey = false, parkBrake = false;
        double brakeAxisMin = 0.0;
        double speedBrakeTarget = 0.0;
        bool sas = true;
        double trimManual = 0.0;
        double elevonL = 0, elevonR = 0, splitL = 0, splitR = 0;
        double gearTarget = 1, gearPos = 1, gearDoor = 0;
        double bayTarget = 0, bayPos = 0, stairsTarget = 0, stairsPos = 0, revoTarget = 0, revoPos = 0;
        bool nws = true;
        double nwsAngle = 0;
        bool landLight = false, taxiLight = false, beacon = false;
        double beaconTimer = 0;
        Engine eng[2];
        double wingL = 1, wingR = 1, elevonDmgL = 1, elevonDmgR = 1;
        double simTime = 0, F[3] = { 0, 0, 0 }, M[3] = { 0, 0, 0 };
        double agl_m = 1000.0;
        bool onGround = true;
        double shake = 0;
        char installPath[512] = { 0 };

        void resetCommon()
        {
            pitch = Axis(); roll = Axis(); yaw = Axis();
            throttleL = throttleR = throttleCmd = throttleKeyDir = 0.0; throttleAxisActive = false;
            brakeL = brakeR = 0.0; brakeKey = parkBrake = false;
            speedBrakeTarget = 0.0; sas = true; trimManual = 0.0;
            elevonL = elevonR = splitL = splitR = 0.0;
            bayTarget = bayPos = stairsTarget = stairsPos = revoTarget = revoPos = 0.0;
            nws = true; nwsAngle = 0.0;
            landLight = taxiLight = beacon = false;
            wingL = wingR = elevonDmgL = elevonDmgR = 1.0;
            eng[0].integrity = eng[1].integrity = 1.0;
            pendingBurn_kg = 0.0;
        }
    };
    Model g;
}

namespace
{
    constexpr double kGearTravelTime = 13.0, kDoorTravelTime = 5.0, kBayTravelTime = 4.5;
    constexpr double kStairsTravelTime = 6.0, kRevoTravelTime = 3.0, kSurfaceRate = 2.2;
    // Posicao dos motores (igual a engines_nozzles em B-21.lua): { x, y, z }
    constexpr double kEnginePos[2][3] = { { -4.8, 0.45, -2.10 }, { -4.8, 0.45, 2.10 } };
    constexpr double kEmptyMass = 31750.0;   // = M_empty em B-21.lua

    // Autoridade do manche sobre os elevons (bombardeiro: resposta suave)
    constexpr double kPitchAuthority = 0.45, kRollAuthority = 0.50;

    double throttleFromAxis(double v) { return clampd((1.0 - v) * 0.5, 0.0, 1.0); } // DCS: -1 = potencia maxima

    void updateControls(double dt)
    {
        Model& m = g;
        m.pitch.update(dt); m.roll.update(dt); m.yaw.update(dt);
        if (m.throttleKeyDir != 0.0)
        {
            m.throttleCmd = clampd(m.throttleCmd + m.throttleKeyDir * 0.35 * dt, 0.0, 1.0);
            m.throttleAxisActive = false;
        }
        m.throttleL = m.throttleR = m.throttleCmd;
        double bL = m.brakeL, bR = m.brakeR;
        if (m.brakeKey) { bL = std::max(bL, 1.0); bR = std::max(bR, 1.0); }
        if (m.parkBrake) bL = bR = 1.0;
        m.brakeL = clampd(bL, 0.0, 1.0);
        m.brakeR = clampd(bR, 0.0, 1.0);
    }

    void updateGear(double dt)
    {
        Model& m = g;
        m.gearPos = slew(m.gearPos, m.gearTarget, dt / kGearTravelTime);
        const bool moving = std::abs(m.gearPos - m.gearTarget) > 1.0e-4;
        const bool fullyUp = m.gearPos < 0.001;
        m.gearDoor = slew(m.gearDoor, (moving || !fullyUp) ? 1.0 : 0.0, dt / kDoorTravelTime);
        m.bayPos = slew(m.bayPos, m.bayTarget, dt / kBayTravelTime);
        m.stairsPos = slew(m.stairsPos, m.stairsTarget, dt / kStairsTravelTime);
        m.revoPos = slew(m.revoPos, m.revoTarget, dt / kRevoTravelTime);
        const double limit = 45.0 * A::kDegToRad;
        m.nwsAngle = lag(m.nwsAngle, m.nws ? clampd(m.yaw.value, -1.0, 1.0) * limit : 0.0, 0.15, dt);
        m.beaconTimer += dt;
    }

    void updateEngines(double dt)
    {
        Model& m = g;
        const double perEngineFuel = m.fuelKg * 0.5;
        const double thr[2] = { m.throttleL, m.throttleR };
        double burn = 0.0;
        for (int i = 0; i < 2; ++i)
        {
            m.eng[i].update(dt, thr[i], perEngineFuel, m.altitude_m, m.mach);
            burn += m.eng[i].fuelFlow_kg_s * dt;
        }
        burn = std::min(burn, m.fuelKg);
        m.fuelKg -= burn;
        m.pendingBurn_kg += burn;
    }

    void updateSurfaces(double dt)
    {
        Model& m = g;
        const double V = std::max(m.tas, 1.0);
        double sasPitch = 0, sasRoll = 0, sasYaw = 0;
        const double schedule = clampd((V - 30.0) / 50.0, 0.0, 1.0);
        if (m.sas)
        {
            sasPitch = clampd(-0.35 * m.omegaZ, -0.25, 0.25) * schedule;
            sasRoll  = clampd(-0.25 * m.omegaX, -0.25, 0.25) * schedule;
            sasYaw   = clampd(0.85 * m.omegaY + 0.60 * m.beta, -0.50, 0.50) * schedule;
        }

        // Limitador de alpha
        double pitchIn = m.pitch.value;
        const double aDeg = m.alpha * A::kRadToDeg;
        if (pitchIn > 0.0) pitchIn *= clampd((15.0 - aDeg) / 4.0, 0.0, 1.0);
        else if (pitchIn < 0.0) pitchIn *= clampd((aDeg + 8.0) / 4.0, 0.0, 1.0);

        // Auto-trim de 1 g
        double autoTrim = 0.0;
        if (m.sas)
        {
            const double qdyn = std::max(0.5 * m.density * V * V, 50.0);
            const double clReq = m.mass * A::kGravity / (qdyn * A::kWingArea);
            const double cmExtra = -0.008 * m.gearPos
                                 - (((m.mass - kEmptyMass - m.fuelKg) > 800.0) ? 0.012 : 0.006) * m.bayPos;
            auto trimDelta = [&](double a) {
                const double cm = A::bilerpClamped(A::kMachGrid, A::kAlphaRadGrid, A::kCmTable, m.mach, a) + cmExtra;
                return clampd(cm / 1.10, -14.0 * A::kDegToRad, 14.0 * A::kDegToRad);
            };
            double lo = A::kAlphaRadGrid.front(), hi = A::kAlphaRadGrid.back();
            for (int it = 0; it < 16; ++it)
            {
                const double mid = 0.5 * (lo + hi);
                const double cl = A::bilerpClamped(A::kMachGrid, A::kAlphaRadGrid, A::kCLTable, m.mach, mid)
                                + 0.80 * trimDelta(mid);
                if (cl < clReq) lo = mid; else hi = mid;
            }
            const double fade = clampd((V - 40.0) / 30.0, 0.0, 1.0);
            autoTrim = trimDelta(0.5 * (lo + hi)) * fade;
        }
        const double trimRad = autoTrim + m.trimManual * 6.0 * A::kDegToRad;

        const double pitchCmd = clampd(kPitchAuthority * pitchIn + sasPitch, -1.0, 1.0);
        const double rollCmd  = clampd(kRollAuthority * m.roll.value + sasRoll, -1.0, 1.0);
        const double yawCmd   = clampd(m.yaw.value + sasYaw, -1.0, 1.0);

        // Mistura dos elevons (+ = bordo de fuga para baixo)
        const double trimNorm = trimRad / A::kMaxElevonRad;
        const double tL = clampd(-pitchCmd + rollCmd + trimNorm, -1.0, 1.0);
        const double tR = clampd(-pitchCmd - rollCmd + trimNorm, -1.0, 1.0);
        const double blowdown = clampd(1.0 - 0.55 * std::pow(m.mach, 3.0), 0.25, 1.0);
        const double step = kSurfaceRate * blowdown * dt;
        m.elevonL = slew(m.elevonL, tL * m.elevonDmgL, step);
        m.elevonR = slew(m.elevonR, tR * m.elevonDmgR, step);

        // Split-drag rudders
        const double sbMax = 0.6;
        const double tSL = clampd(m.speedBrakeTarget * sbMax + std::max(0.0, -yawCmd), 0.0, 1.0);
        const double tSR = clampd(m.speedBrakeTarget * sbMax + std::max(0.0, +yawCmd), 0.0, 1.0);
        m.splitL = slew(m.splitL, tSL, 1.2 * blowdown * dt);
        m.splitR = slew(m.splitR, tSR, 1.2 * blowdown * dt);
    }

    void computeForces()
    {
        Model& m = g;
        A::State s{};
        s.mach = m.mach; s.altitude_m = m.altitude_m; s.alpha_rad = m.alpha; s.beta_rad = m.beta;
        s.p_rad_s = m.omegaX; s.q_rad_s = m.omegaZ; s.r_rad_s = -m.omegaY;
        s.tas_m_s = m.tas; s.rho_kg_m3 = m.density; s.agl_m = m.agl_m;

        A::Controls c{};
        c.elevon_left_rad = m.elevonL * A::kMaxElevonRad;
        c.elevon_right_rad = m.elevonR * A::kMaxElevonRad;
        c.split_rudder_left_rad = m.splitL * A::kMaxSplitRudderRad;
        c.split_rudder_right_rad = m.splitR * A::kMaxSplitRudderRad;
        c.gear_norm = m.gearPos;
        c.bay_door_norm = m.bayPos;
        c.bay_has_stores = (m.mass - kEmptyMass - m.fuelKg) > 800.0;
        c.use_ground_effect = true;

        A::ForcesMoments aero = A::computeAeroForcesAndMoments(s, c);

        // Dano de asa
        const double q = aero.q_dyn_Pa;
        aero.Fy_N *= 0.5 * (m.wingL + m.wingR);
        aero.Mx_Nm += -0.20 * (m.wingR - m.wingL) * q * A::kWingArea * A::kWingSpan * 0.4;

        double F[3] = { aero.Fx_N, aero.Fy_N, aero.Fz_N };
        double M[3] = { aero.Mx_Nm, aero.My_Nm, aero.Mz_Nm };
        for (int i = 0; i < 2; ++i)   // empuxo por motor: M = r x (T,0,0)
        {
            const double T = m.eng[i].thrust_N;
            F[0] += T;
            M[1] += kEnginePos[i][2] * T;
            M[2] += -kEnginePos[i][1] * T;
        }
        for (int k = 0; k < 3; ++k) { m.F[k] = F[k]; m.M[k] = M[k]; }
        m.shake = clampd(0.002 + 0.00001 * q * (1.0 + 3.0 * (m.alpha > 12.0 * A::kDegToRad)), 0.0, 0.25);
    }
}

// ===========================================================================
//  API DCS EFM
// ===========================================================================
void ed_fm_add_local_force(double& x, double& y, double& z, double& px, double& py, double& pz)
{ x = g.F[0]; y = g.F[1]; z = g.F[2]; px = py = pz = 0.0; }
void ed_fm_add_global_force(double& x, double& y, double& z, double& px, double& py, double& pz)
{ x = y = z = px = py = pz = 0.0; }
bool ed_fm_add_local_force_component(double&, double&, double&, double&, double&, double&) { return false; }
bool ed_fm_add_global_force_component(double&, double&, double&, double&, double&, double&) { return false; }
void ed_fm_add_local_moment(double& x, double& y, double& z) { x = g.M[0]; y = g.M[1]; z = g.M[2]; }
void ed_fm_add_global_moment(double& x, double& y, double& z) { x = y = z = 0.0; }
bool ed_fm_add_local_moment_component(double&, double&, double&) { return false; }
bool ed_fm_add_global_moment_component(double&, double&, double&) { return false; }

void ed_fm_simulate(double dt)
{
    if (dt <= 0.0) return;
    g.simTime += dt;
    updateControls(dt);
    updateGear(dt);
    updateEngines(dt);
    updateSurfaces(dt);
    computeForces();
}

void ed_fm_set_surface(double h, double, unsigned, double, double, double) { g.surfaceHeight_m = h; }

void ed_fm_set_atmosphere(double h, double t, double a, double ro, double p, double, double, double)
{
    g.altitude_m = h; g.temperature_K = t;
    g.sound_speed = (a > 100.0) ? a : 340.29;
    g.density = ro; g.pressure = p;
    g.agl_m = std::max(0.0, h - g.surfaceHeight_m - 2.4);   // contato do trem ~2.4 m abaixo da origem
    g.onGround = g.agl_m < 0.6;
}

void ed_fm_set_current_mass_state(double mass, double, double, double, double, double, double) { g.mass = mass; }

void ed_fm_set_current_state(double, double, double, double, double, double, double, double, double,
                             double, double, double, double, double, double, double, double, double, double) {}

void ed_fm_set_current_state_body_axis(double, double ay, double,
                                       double vx, double vy, double vz,
                                       double wx, double wy, double wz,
                                       double, double, double,
                                       double omegax, double omegay, double omegaz,
                                       double, double, double, double, double)
{
    g.nzBody = ay / A::kGravity;
    const double ux = vx - wx, uy = vy - wy, uz = vz - wz;   // velocidade relativa ao ar
    g.vx = ux; g.vy = uy; g.vz = uz;
    g.tas = std::sqrt(ux * ux + uy * uy + uz * uz);
    g.mach = g.tas / g.sound_speed;
    g.alpha = (g.tas > 1.0) ? std::atan2(-uy, ux) : 0.0;
    g.beta  = (g.tas > 1.0) ? std::asin(clampd(uz / g.tas, -1.0, 1.0)) : 0.0;
    g.omegaX = omegax; g.omegaY = omegay; g.omegaZ = omegaz;
}

void ed_fm_set_command(int command, float value)
{
    Model& m = g;
    switch (command)
    {
    case Cmd::PITCH: m.pitch.setAnalog(value); break;
    case Cmd::ROLL:  m.roll.setAnalog(value); break;
    case Cmd::YAW:   m.yaw.setAnalog(value); break;
    case Cmd::THROTTLE:
        m.throttleCmd = throttleFromAxis(value);
        m.throttleAxisActive = true; m.throttleKeyDir = 0.0;
        break;
    case Cmd::BRAKE_AXIS: case Cmd::BRAKE_AXIS_L: case Cmd::BRAKE_AXIS_R:
    {
        if (value < m.brakeAxisMin) m.brakeAxisMin = value;
        const double v = (m.brakeAxisMin < -0.01) ? (value + 1.0) * 0.5 : value;
        const double b = clampd(v, 0.0, 1.0);
        if (command == Cmd::BRAKE_AXIS) { m.brakeL = b; m.brakeR = b; }
        else if (command == Cmd::BRAKE_AXIS_L) m.brakeL = b;
        else m.brakeR = b;
        break;
    }
    case Cmd::PITCH_DOWN_START: m.pitch.keyStart(-1.0); break;
    case Cmd::PITCH_UP_START:   m.pitch.keyStart(+1.0); break;
    case Cmd::PITCH_DOWN_STOP: case Cmd::PITCH_UP_STOP: m.pitch.keyStop(); break;
    case Cmd::ROLL_LEFT_START:  m.roll.keyStart(-1.0); break;
    case Cmd::ROLL_RIGHT_START: m.roll.keyStart(+1.0); break;
    case Cmd::ROLL_LEFT_STOP: case Cmd::ROLL_RIGHT_STOP: m.roll.keyStop(); break;
    case Cmd::RUDDER_LEFT_START:  m.yaw.keyStart(-1.0); break;
    case Cmd::RUDDER_RIGHT_START: m.yaw.keyStart(+1.0); break;
    case Cmd::RUDDER_LEFT_STOP: case Cmd::RUDDER_RIGHT_STOP: m.yaw.keyStop(); break;
    case Cmd::THROTTLE_UP_START:   m.throttleKeyDir = +1.0; break;
    case Cmd::THROTTLE_DOWN_START: m.throttleKeyDir = -1.0; break;
    case Cmd::THROTTLE_STOP:       m.throttleKeyDir = 0.0; break;

    case Cmd::GEAR_TOGGLE:
        if (m.gearTarget > 0.5) { if (!m.onGround) m.gearTarget = 0.0; } else m.gearTarget = 1.0;
        break;
    case Cmd::GEAR_UP:   if (!m.onGround) m.gearTarget = 0.0; break;
    case Cmd::GEAR_DOWN: m.gearTarget = 1.0; break;

    case Cmd::AIRBRAKE_TOGGLE: m.speedBrakeTarget = (m.speedBrakeTarget > 0.5) ? 0.0 : 1.0; break;
    case Cmd::AIRBRAKE_ON:  m.speedBrakeTarget = 1.0; break;
    case Cmd::AIRBRAKE_OFF: m.speedBrakeTarget = 0.0; break;

    case Cmd::ENG_START_L: if (!m.eng[0].running) m.eng[0].starting = true; break;
    case Cmd::ENG_START_R: if (!m.eng[1].running) m.eng[1].starting = true; break;
    case Cmd::ENG_STOP_L:  m.eng[0].running = false; m.eng[0].starting = false; break;
    case Cmd::ENG_STOP_R:  m.eng[1].running = false; m.eng[1].starting = false; break;
    case Cmd::ENG_START_ALL: for (auto& e : m.eng) if (!e.running) e.starting = true; break;
    case Cmd::ENG_STOP_ALL:  for (auto& e : m.eng) { e.running = false; e.starting = false; } break;

    case Cmd::WHEEL_BRAKE_ON:  m.brakeKey = true;  break;   // PATCH
    case Cmd::WHEEL_BRAKE_OFF: m.brakeKey = false; break;   // PATCH
    case Cmd::ENGINES_START: for (auto& e : m.eng) if (!e.running) e.starting = true; break;   // PATCH
    case Cmd::ENGINES_STOP:  for (auto& e : m.eng) { e.running = false; e.starting = false; } break;   // PATCH
    case Cmd::BRAKES_ON:  m.brakeKey = true; break;
    case Cmd::BRAKES_OFF: m.brakeKey = false; break;
    case Cmd::PARK_BRAKE: m.parkBrake = !m.parkBrake; break;
    case Cmd::BAY_TOGGLE:    m.bayTarget = (m.bayTarget > 0.5) ? 0.0 : 1.0; break;
    case Cmd::STAIRS_TOGGLE: if (m.onGround && m.tas < 3.0) m.stairsTarget = (m.stairsTarget > 0.5) ? 0.0 : 1.0; break;
    case Cmd::REVO_TOGGLE:   m.revoTarget = (m.revoTarget > 0.5) ? 0.0 : 1.0; break;
    case Cmd::LAND_LIGHT:    m.landLight = !m.landLight; break;
    case Cmd::TAXI_LIGHT:    m.taxiLight = !m.taxiLight; break;
    case Cmd::BEACON_LIGHT:  m.beacon = !m.beacon; break;
    case Cmd::LIGHTS_TOGGLE: { const bool on = !(m.landLight || m.taxiLight || m.beacon); m.landLight = m.taxiLight = m.beacon = on; break; }
    case Cmd::NWS_TOGGLE:    m.nws = !m.nws; break;
    case Cmd::SAS_TOGGLE:    m.sas = !m.sas; break;
    case Cmd::TRIM_UP:    m.trimManual = clampd(m.trimManual + 0.05, -1.0, 1.0); break;
    case Cmd::TRIM_DOWN:  m.trimManual = clampd(m.trimManual - 0.05, -1.0, 1.0); break;
    case Cmd::TRIM_RESET: m.trimManual = 0.0; break;
    default: break;
    }
}

bool ed_fm_change_mass(double& dm, double& x, double& y, double& z, double& ix, double& iy, double& iz)
{
    if (g.pendingBurn_kg > 0.0)
    {
        dm = -g.pendingBurn_kg;
        x = y = z = ix = iy = iz = 0.0;
        g.pendingBurn_kg = 0.0;
        return true;
    }
    return false;
}

void ed_fm_set_internal_fuel(double fuel) { g.fuelKg = fuel; }
double ed_fm_get_internal_fuel() { return g.fuelKg; }
void ed_fm_set_external_fuel(int, double, double, double, double) {}
double ed_fm_get_external_fuel() { return 0.0; }
void ed_fm_refueling_add_fuel(double fuel) { g.fuelKg += fuel; }

void ed_fm_set_draw_args(EdDrawArgument* d, size_t size)
{
    Model& m = g;
    auto set = [&](size_t i, double v) { if (i < size) d[i].f = static_cast<float>(v); };

    set(Arg::NOSE_GEAR, m.gearPos); set(Arg::R_GEAR, m.gearPos); set(Arg::L_GEAR, m.gearPos);
    const double steer = clampd(m.nwsAngle / (45.0 * A::kDegToRad), -1.0, 1.0);
    set(Arg::NOSE_STEER, steer); set(Arg::NOSE_STEER_MODEL, steer);

    set(Arg::R_AILERON,  Arg::AILERON_SIGN  * m.elevonR);
    set(Arg::L_AILERON,  Arg::AILERON_SIGN  * m.elevonL);
    set(Arg::R_ELEVATOR, Arg::ELEVATOR_SIGN * m.elevonR);
    set(Arg::L_ELEVATOR, Arg::ELEVATOR_SIGN * m.elevonL);

    set(Arg::RUDDER, 0.5 * (m.splitL + m.splitR));
    set(Arg::SPOILER_L, m.splitL); set(Arg::SPOILER_R, m.splitR);

    set(Arg::BAY_L, m.bayPos); set(Arg::BAY_R, m.bayPos);
    set(Arg::LAUNCH_BAR, 0.0);
    set(Arg::REVO, m.revoPos);

    const double beaconOn = m.beacon ? ((std::fmod(m.beaconTimer, 0.85) < 0.12) ? 1.0 : 0.0) : 0.0;
    set(Arg::LIGHT_LANDING, m.landLight ? 1.0 : 0.0);
    set(Arg::LIGHT_TAXI, m.taxiLight ? 1.0 : 0.0);
    set(Arg::LIGHT_BEACON, beaconOn);
}

void ed_fm_set_fc3_cockpit_draw_args(EdDrawArgument*, size_t) {}
double ed_fm_get_shake_amplitude() { return g.shake; }
void ed_fm_configure(const char*) {}
void ed_fm_release() {}
void ed_fm_set_plugin_data_install_path(const char* p) { if (p) std::strncpy(g.installPath, p, sizeof(g.installPath) - 1); }
void ed_fm_on_planned_failure(const char*) {}
bool ed_fm_enable_debug_info() { return false; }
size_t ed_fm_debug_watch(int, char*, size_t) { return 0; }
void ed_fm_set_immortal(bool) {}
void ed_fm_repair()
{
    g.wingL = g.wingR = g.elevonDmgL = g.elevonDmgR = 1.0;
    g.eng[0].integrity = g.eng[1].integrity = 1.0;
}
bool ed_fm_need_to_be_repaired()
{ return g.wingL < 0.999 || g.wingR < 0.999 || g.eng[0].integrity < 0.999 || g.eng[1].integrity < 0.999; }

void ed_fm_on_damage(int element, double integrity)
{
    switch (element)
    {
    case 11: case 17: g.eng[0].integrity = std::min(g.eng[0].integrity, integrity); break;
    case 12: case 18: g.eng[1].integrity = std::min(g.eng[1].integrity, integrity); break;
    case 23: case 29: case 35: case 21: case 27: case 33: g.wingL = std::min(g.wingL, 0.35 + 0.65 * integrity); break;
    case 24: case 30: case 36: case 22: case 28: case 34: g.wingR = std::min(g.wingR, 0.35 + 0.65 * integrity); break;
    case 25: case 51: g.elevonDmgL = std::min(g.elevonDmgL, 0.2 + 0.8 * integrity); break;
    case 26: case 52: g.elevonDmgR = std::min(g.elevonDmgR, 0.2 + 0.8 * integrity); break;
    default: break;
    }
}

bool ed_fm_pop_simulation_event(ed_fm_simulation_event&) { return false; }

static double engineParam(int n, int off)
{
    const Engine& e = g.eng[n];
    const double rpmPct = e.n1 * 100.0, maxT = A::kThrustSLPerEngine;
    switch (off)
    {
    case 0:  return rpmPct;
    case 1:  return e.n1;
    case 2:  return rpmPct;
    case 3:  return e.n1;
    case 4:  return e.thrust_N;
    case 5:  return e.thrust_N / maxT;
    case 6:  return e.thrust_N;
    case 7:  return e.thrust_N / maxT;
    case 11: return e.integrity;
    case 12: return e.egt_C;
    case 13: return e.running ? 350.0 + 250.0 * e.n1 : 0.0;
    case 14: return e.fuelFlow_kg_s;
    case 15: return e.combustion;
    default: return 0.0;
    }
}

double ed_fm_get_param(unsigned index)
{
    if (index >= 100 && index < 300)   // bloco de motores: 100*n (n=1,2); 0 = APU (inexistente)
        return engineParam(static_cast<int>(index) / 100 - 1, static_cast<int>(index) % 100);

    switch (index)
    {
    case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
    case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
        return g.gearPos;
    // PATCH: travas. UP_LOCK = recolhido e travado; DOWN_LOCK = baixado e travado.
    case ED_FM_SUSPENSION_0_UP_LOCK: case ED_FM_SUSPENSION_1_UP_LOCK: case ED_FM_SUSPENSION_2_UP_LOCK:
        return (g.gearPos < 0.001) ? 1.0 : 0.0;
    case ED_FM_SUSPENSION_0_DOWN_LOCK: case ED_FM_SUSPENSION_1_DOWN_LOCK: case ED_FM_SUSPENSION_2_DOWN_LOCK:
        return (g.gearPos > 0.999) ? 1.0 : 0.0;
    case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT: return std::pow(g.brakeL, 2.0);
    case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT: return std::pow(g.brakeR, 2.0);
    case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT: return 0.0;
    case ED_FM_SUSPENSION_0_WHEEL_YAW: return g.nws ? g.nwsAngle : 0.0;
    case ED_FM_SUSPENSION_0_WHEEL_SELF_ATTITUDE: return g.nws ? 0.0 : 1.0;
    case ED_FM_ANTI_SKID_ENABLE: return 1.0;
    case ED_FM_FUEL_INTERNAL_FUEL: case ED_FM_FUEL_TOTAL_FUEL: return g.fuelKg;   // PATCH
    case ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER: return (g.revoPos > 0.95) ? 1000.0 : 0.0;
    default: break;
    }
    return 0.0;
}

void ed_fm_cold_start()
{
    g.resetCommon();
    g.gearTarget = g.gearPos = 1.0; g.gearDoor = 1.0;
    g.eng[0].cold(); g.eng[1].cold();
}
void ed_fm_hot_start()
{
    g.resetCommon();
    g.gearTarget = g.gearPos = 1.0; g.gearDoor = 1.0;
    g.eng[0].hot(Engine::kIdle); g.eng[1].hot(Engine::kIdle);
}
void ed_fm_hot_start_in_air()
{
    g.resetCommon();
    g.gearTarget = g.gearPos = 0.0; g.gearDoor = 0.0;
    g.eng[0].hot(0.78); g.eng[1].hot(0.78);
    g.throttleCmd = 0.6;
}

B21_API const char* b21_efm_version() { return "B21_EFM 1.1.0"; }

#else
// Teste standalone: g++ -std=c++17 -DB21_STANDALONE_TEST B21_EFM.cpp
int main()
{
    using namespace B21::Aerodata;
    const Atmosphere atm = isaAtmosphere(10000.0);
    State s{}; s.altitude_m = 10000.0; s.mach = 0.75; s.alpha_rad = 5.0 * kDegToRad;
    s.rho_kg_m3 = atm.density_kg_m3; s.tas_m_s = s.mach * atm.speed_of_sound_m_s;
    Controls c{}; c.throttle_norm = 0.65;
    const ForcesMoments fm = computeForcesAndMoments(s, c, true);
    Controls cy = c; cy.split_rudder_right_rad = 15.0 * kDegToRad;
    const ForcesMoments fmy = computeForcesAndMoments(s, cy, true);
    Controls cr = c; cr.elevon_right_rad = -10.0 * kDegToRad; cr.elevon_left_rad = +10.0 * kDegToRad;
    const ForcesMoments fmr = computeForcesAndMoments(s, cr, true);
    Controls cp = c; cp.elevon_left_rad = cp.elevon_right_rad = -10.0 * kDegToRad;
    const ForcesMoments fmp = computeForcesAndMoments(s, cp, true);
    const bool ok = fm.Fy_N > 0 && derivativeAlpha(s.mach, s.alpha_rad) > 0 && derivativeCmAlpha(s.mach, s.alpha_rad) < 0
                 && fmy.My_Nm < 0 && fmr.Mx_Nm > fm.Mx_Nm && fmp.Mz_Nm > fm.Mz_Nm;
    std::printf("sign checks: %s\n", ok ? "OK" : "FALHOU");
    return ok ? 0 : 1;
}
#endif