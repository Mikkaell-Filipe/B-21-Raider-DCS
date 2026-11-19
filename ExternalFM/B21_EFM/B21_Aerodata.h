#pragma once
//=========================================================================//
//  B21_Aerodata.h - modelo aerodinamico parametrico 6-DoF (asa voadora)
//  Eixos DCS: +x frente, +y cima, +z direita.
//    Mx>0 : asa direita desce | My>0 : nariz esquerda | Mz>0 : nariz sobe
//  Valores marcados [N3] sao estimativas parametricas (ajuste a gosto).
//  Correcoes em relacao ao header original:
//   [FIX-1] dCL_elevon = +0.80*delta_e (delta + = bordo de fuga p/ baixo)
//   [FIX-2] sinal do rolamento por elevon corrigido (dCl = -0.10*delta_a)
//   [FIX-3] extensao pos-estol em vez de simples clamp da tabela
//   [FIX-4] area alar/massa/empuxo coerentes com B-21.lua
//=========================================================================//
#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>

namespace B21 { namespace Aerodata {

constexpr double kPi = 3.14159265358979323846;
constexpr double kDegToRad = kPi / 180.0;
constexpr double kRadToDeg = 180.0 / kPi;
constexpr double kGravity = 9.80665;
constexpr double kGasConstant = 287.05287;
constexpr double kGamma = 1.4;
constexpr double kSeaLevelTemp = 288.15;
constexpr double kSeaLevelPressure = 101325.0;
constexpr double kSeaLevelDensity = 1.2250;

constexpr double kWingArea = 300.0;   // [N3] m^2  (= wing_area em B-21.lua)
constexpr double kWingSpan = 42.7;    // m
constexpr double kAspectRatio = (kWingSpan * kWingSpan) / kWingArea;
constexpr double kMeanChord = kWingArea / kWingSpan;
constexpr double kBaselineMass = 55000.0;

constexpr int    kNumEngines = 2;
constexpr double kThrustSLPerEngine = 100000.0; // N [N3]
constexpr double kTsfcSLImperial = 0.55;        // lb/(lbf*h)
constexpr double kLbToKg = 0.45359237;
constexpr double kLbfToN = 4.448221615;

constexpr double kMaxElevonRad = 25.0 * kDegToRad;
constexpr double kMaxSplitRudderRad = 45.0 * kDegToRad;

constexpr std::size_t kNumMach = 4;
constexpr std::size_t kNumAlpha = 5;
constexpr std::array<double, kNumMach> kMachGrid = { 0.30, 0.60, 0.75, 0.85 };
constexpr std::array<double, kNumAlpha> kAlphaRadGrid = {
    -5.0 * kDegToRad, 0.0, 5.0 * kDegToRad, 10.0 * kDegToRad, 15.0 * kDegToRad };

constexpr std::array<std::array<double, kNumAlpha>, kNumMach> kCLTable = {{
    {{ -0.2952, 0.0800, 0.4552, 0.8305, 1.0932 }},
    {{ -0.3140, 0.0820, 0.4780, 0.8740, 1.1350 }},
    {{ -0.3380, 0.0850, 0.5080, 0.9250, 1.1700 }},
    {{ -0.3200, 0.0780, 0.4850, 0.8850, 1.1100 }} }};
constexpr std::array<std::array<double, kNumAlpha>, kNumMach> kCDTable = {{
    {{ 0.02835, 0.01876, 0.04260, 0.09988, 0.17187 }},
    {{ 0.02971, 0.01880, 0.04513, 0.10869, 0.18350 }},
    {{ 0.03156, 0.01886, 0.04864, 0.11958, 0.19650 }},
    {{ 0.04616, 0.03472, 0.06193, 0.12899, 0.20430 }} }};
constexpr std::array<std::array<double, kNumAlpha>, kNumMach> kCmTable = {{
    {{  0.0193, -0.0200, -0.0593, -0.0985, -0.1498 }},
    {{  0.0210, -0.0210, -0.0630, -0.1050, -0.1580 }},
    {{  0.0230, -0.0230, -0.0690, -0.1150, -0.1720 }},
    {{  0.0180, -0.0320, -0.0820, -0.1320, -0.1950 }} }};

struct Atmosphere { double temperature_K = kSeaLevelTemp, pressure_Pa = kSeaLevelPressure, density_kg_m3 = kSeaLevelDensity, speed_of_sound_m_s = 340.29; };
struct State {
    double mach = 0, altitude_m = 0, alpha_rad = 0, beta_rad = 0;
    double p_rad_s = 0, q_rad_s = 0, r_rad_s = 0, tas_m_s = 0;
    double rho_kg_m3 = kSeaLevelDensity, agl_m = 1000.0;
};
struct Controls {
    double elevon_left_rad = 0, elevon_right_rad = 0;
    double split_rudder_left_rad = 0, split_rudder_right_rad = 0;
    double throttle_norm = 0, gear_norm = 0, bay_door_norm = 0;
    bool bay_has_stores = false, use_ground_effect = true;
};
struct Coefficients { double CL = 0, CD = 0, CY = 0, Cl = 0, Cm = 0, Cn = 0; bool envelope_clamped = false; };
struct ForcesMoments {
    double Fx_N = 0, Fy_N = 0, Fz_N = 0, Mx_Nm = 0, My_Nm = 0, Mz_Nm = 0;
    double thrust_N = 0, fuel_flow_kg_s = 0, q_dyn_Pa = 0;
};

inline Atmosphere isaAtmosphere(double altitude_m)
{
    const double h = std::max(0.0, altitude_m);
    constexpr double h_trop = 11000.0, lapse = -0.0065;
    Atmosphere atm{};
    if (h <= h_trop) {
        atm.temperature_K = kSeaLevelTemp + lapse * h;
        atm.pressure_Pa = kSeaLevelPressure * std::pow(atm.temperature_K / kSeaLevelTemp, -kGravity / (kGasConstant * lapse));
    } else {
        const double T11 = kSeaLevelTemp + lapse * h_trop;
        const double p11 = kSeaLevelPressure * std::pow(T11 / kSeaLevelTemp, -kGravity / (kGasConstant * lapse));
        atm.temperature_K = T11;
        atm.pressure_Pa = p11 * std::exp(-kGravity * (h - h_trop) / (kGasConstant * T11));
    }
    atm.density_kg_m3 = atm.pressure_Pa / (kGasConstant * atm.temperature_K);
    atm.speed_of_sound_m_s = std::sqrt(kGamma * kGasConstant * atm.temperature_K);
    return atm;
}

template <std::size_t NM, std::size_t NA>
inline double bilerpClamped(const std::array<double, NM>& xG, const std::array<double, NA>& yG,
                            const std::array<std::array<double, NA>, NM>& t, double x, double y, bool* wc = nullptr)
{
    bool clamped = false; double xc = x, yc = y;
    if (xc < xG.front()) { clamped = true; xc = xG.front(); } else if (xc > xG.back()) { clamped = true; xc = xG.back(); }
    if (yc < yG.front()) { clamped = true; yc = yG.front(); } else if (yc > yG.back()) { clamped = true; yc = yG.back(); }
    if (wc) *wc = (*wc) || clamped;
    std::size_t i = 0; while (i + 2 < NM && xc > xG[i + 1]) ++i;
    std::size_t j = 0; while (j + 2 < NA && yc > yG[j + 1]) ++j;
    const double tx = (xc - xG[i]) / (xG[i + 1] - xG[i]), ty = (yc - yG[j]) / (yG[j + 1] - yG[j]);
    const double c0 = t[i][j] + tx * (t[i + 1][j] - t[i][j]);
    const double c1 = t[i][j + 1] + tx * (t[i + 1][j + 1] - t[i][j + 1]);
    return c0 + ty * (c1 - c0);
}

inline double derivativeAlpha(double mach, double a, double d = 1.0e-3)
{ return (bilerpClamped(kMachGrid, kAlphaRadGrid, kCLTable, mach, a + d) - bilerpClamped(kMachGrid, kAlphaRadGrid, kCLTable, mach, a - d)) / (2 * d); }
inline double derivativeCmAlpha(double mach, double a, double d = 1.0e-3)
{ return (bilerpClamped(kMachGrid, kAlphaRadGrid, kCmTable, mach, a + d) - bilerpClamped(kMachGrid, kAlphaRadGrid, kCmTable, mach, a - d)) / (2 * d); }

inline double installedThrustN(double altitude_m, double mach, double throttle_norm,
                               int num_engines = kNumEngines, double thrust_sl_per_engine_N = kThrustSLPerEngine)
{
    const double th = std::clamp(throttle_norm, 0.0, 1.0), h = std::max(0.0, altitude_m), m = std::max(0.0, mach);
    const double eta = std::max(0.45, 1.0 - 0.18 * (h / 15000.0) - 0.10 * std::max(0.0, m - 0.30));
    return num_engines * thrust_sl_per_engine_N * eta * th;
}
inline double tsfcKgNs(double mach, double throttle_norm)
{
    const double th = std::clamp(throttle_norm, 0.0, 1.0), m = std::max(0.0, mach);
    constexpr double ct = kTsfcSLImperial * (kLbToKg / (kLbfToN * 3600.0));
    return ct * (1.0 + 0.18 * m) * (1.0 + 0.12 * (1.0 - th) * (1.0 - th));
}

inline Coefficients computeCoefficients(const State& s, const Controls& c)
{
    Coefficients out{};
    const double a_in = std::clamp(s.alpha_rad, kAlphaRadGrid.front(), kAlphaRadGrid.back());
    const double a_ex = s.alpha_rad - a_in;
    double cl = bilerpClamped(kMachGrid, kAlphaRadGrid, kCLTable, s.mach, a_in, &out.envelope_clamped);
    double cd = bilerpClamped(kMachGrid, kAlphaRadGrid, kCDTable, s.mach, a_in, &out.envelope_clamped);
    double cm = bilerpClamped(kMachGrid, kAlphaRadGrid, kCmTable, s.mach, a_in, &out.envelope_clamped);
    if (a_ex != 0.0) {   // [FIX-3]
        const double ex = std::min(std::abs(a_ex), 60.0 * kDegToRad), sg = (a_ex > 0) ? 1.0 : -1.0;
        cl *= std::max(0.0, std::cos(ex * 1.5));
        cd += 1.30 * std::sin(ex) * std::sin(ex);
        cm += -sg * 0.55 * std::sin(ex);
    }
    if (c.use_ground_effect && s.agl_m >= 0.0 && s.agl_m < kWingSpan) {
        const double hb = s.agl_m / kWingSpan, Fi = 1.0 / (1.0 + (12.0 * hb) * (12.0 * hb));
        cl *= 1.0 + 0.12 * Fi;
        const double cdi = cl * cl / (kPi * 0.75 * kAspectRatio);
        cd = std::max(0.012, cd - cdi * (1.0 - Fi) * 0.5);
    }
    const double dL = std::clamp(c.elevon_left_rad, -kMaxElevonRad, kMaxElevonRad);
    const double dR = std::clamp(c.elevon_right_rad, -kMaxElevonRad, kMaxElevonRad);
    const double de = 0.5 * (dL + dR), da = 0.5 * (dR - dL);
    const double dCL = +0.80 * de, dCm = -1.10 * de, dCl = -0.10 * da, dCn = -0.04 * da;   // [FIX-1/2]
    const double dCDe = 0.015 * (de * de + da * da);
    const double spL = std::clamp(c.split_rudder_left_rad, 0.0, kMaxSplitRudderRad);
    const double spR = std::clamp(c.split_rudder_right_rad, 0.0, kMaxSplitRudderRad);
    const double dCDs = 0.025 * 0.5 * (spL + spR) / (15.0 * kDegToRad) * 0.5;
    const double dCns = 0.060 * (spR - spL), dCls = 0.008 * (spR - spL);
    const double gear = std::clamp(c.gear_norm, 0.0, 1.0), bay = std::clamp(c.bay_door_norm, 0.0, 1.0);
    const double dCDg = 0.002 + 0.043 * gear, dCmg = -0.008 * gear;
    const double dCDb = 0.001 + (c.bay_has_stores ? 0.034 : 0.017) * bay, dCmb = (c.bay_has_stores ? -0.012 : -0.006) * bay;

    const double V = std::max(s.tas_m_s, 1.0);
    const double ph = s.p_rad_s * kWingSpan / (2 * V), qh = s.q_rad_s * kMeanChord / (2 * V), rh = s.r_rad_s * kWingSpan / (2 * V);
    out.CL = cl + dCL;
    out.CD = cd + dCDe + dCDs + dCDg + dCDb;
    out.CY = -0.18 * s.beta_rad;
    out.Cl = -0.08 * s.beta_rad + dCl + dCls - 0.42 * ph + 0.08 * rh;
    out.Cm = cm + dCm + dCmg + dCmb - 3.80 * qh;
    out.Cn = 0.02 * s.beta_rad + dCn + dCns - 0.03 * ph - 0.06 * rh;
    return out;
}

// Forcas/momentos aerodinamicos no CG (sem empuxo; empuxo por motor no EFM)
inline ForcesMoments computeAeroForcesAndMoments(const State& s, const Controls& c)
{
    ForcesMoments fm{};
    const double V = std::max(0.0, s.tas_m_s), q = 0.5 * s.rho_kg_m3 * V * V;
    fm.q_dyn_Pa = q;
    const Coefficients k = computeCoefficients(s, c);
    const double L = q * kWingArea * k.CL, D = q * kWingArea * k.CD, Y = q * kWingArea * k.CY;
    const double ca = std::cos(s.alpha_rad), sa = std::sin(s.alpha_rad), cb = std::cos(s.beta_rad), sb = std::sin(s.beta_rad);
    fm.Fx_N = -D * ca * cb + L * sa - Y * ca * sb;
    fm.Fy_N =  L * ca + D * sa * cb + Y * sa * sb;
    fm.Fz_N =  Y * cb - D * sb;
    fm.Mx_Nm =  q * kWingArea * kWingSpan  * k.Cl;
    fm.My_Nm = -q * kWingArea * kWingSpan  * k.Cn;
    fm.Mz_Nm =  q * kWingArea * kMeanChord * k.Cm;
    return fm;
}

inline ForcesMoments computeForcesAndMoments(const State& s, const Controls& c, bool = true)
{
    ForcesMoments fm = computeAeroForcesAndMoments(s, c);
    const double T = installedThrustN(s.altitude_m, s.mach, c.throttle_norm);
    fm.thrust_N = T; fm.fuel_flow_kg_s = tsfcKgNs(s.mach, c.throttle_norm) * T; fm.Fx_N += T;
    return fm;
}

}} // namespace
