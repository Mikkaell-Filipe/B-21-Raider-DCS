dofile("B21Tools.lua")
dofile("Curve.lua")

offsets = { core = 0, core2 = 0, fan = 0, turb = 0, jet = 0, around = 0 }

SOUND_FAN_RPM       = 1  -- normalizado 0.0 -> 1.0 (ED_FM_ENGINE_x_RELATED_RPM)
SOUND_TURBINE_POWER = 2
SOUND_TRUE_AIRSPEED = 4  -- m/s

B21Turbofan = { number = 0 }

function B21Turbofan:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.number = 1
	return o
end

local SD = "Aircrafts/Engines/B-21/"

function B21Turbofan:init(number_, host)
	-- Cada som: curva de pitch e de gain em função do RPM (ou velocidade).
	-- Sons sintéticos gerados para este mod (ver Sounds/Effects/Aircrafts/Engines/B-21/README.txt).
	-- Grupos: FRONT (admissão, aguda), AROUND (esférico), BACK (escape, grave) + 3 "far" (alta velocidade).
	self.sounds = {
		-- FRONT
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_front_lo",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.04, 1.09, 1.13}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.88, 1.00}, 0.01, 1.0) },
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_front_hi",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.00}, 0.47, 1.0) },
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_TRUE_AIRSPEED, sdef_name = SD .. "b21_engine_ext_far_roar",
		  pitch_curve = Curve({0.66, 1.00, 1.33}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.04, 0.34, 0.84, 0.86, 0.93, 1.00}, 80.0, 340.0) },
		-- AROUND
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_around_lo",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.05, 1.08, 1.13}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.86, 1.00}, 0.01, 1.0) },
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_around_hi",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.00}, 0.43, 1.0) },
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_far_whine",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.64, 0.73, 0.77, 0.82, 0.91, 1.00}, 0.18, 1.0) },
		-- BACK
		{ sound = nil, type_pitch = SOUND_TURBINE_POWER, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_back_lo",
		  pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.05, 1.08, 1.13}, 0.01, 1.0),
		  gain_curve  = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.86, 1.00}, 0.01, 1.0) },
		{ sound = nil, type_pitch = SOUND_TURBINE_POWER, type_gain = SOUND_FAN_RPM, sdef_name = SD .. "b21_engine_ext_back_hi",
		  pitch_curve = Curve({0.93, 1.00, 1.07}, 0.43, 1.0),
		  gain_curve  = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.00}, 0.43, 1.0) },
		{ sound = nil, type_pitch = SOUND_FAN_RPM, type_gain = SOUND_TRUE_AIRSPEED, sdef_name = SD .. "b21_engine_ext_far_rip",
		  pitch_curve = Curve({0.66, 1.00, 1.33}, 0.5, 1.0),
		  gain_curve  = Curve({0.00, 0.02, 0.4, 0.81, 0.90, 0.95, 1.00}, 80.0, 340.0) },
	}

	self:createSounds(number_, host)
end

function B21Turbofan:createSounds(number_, host)
	self.number = number_
	for i, v in pairs(self.sounds) do
		self.sounds[i].sound = ED_AudioAPI.createSource(host, v.sdef_name)
	end
end

-- Sons de cockpit (interior) não incluídos: deixe nil até existir sound_system.lua
function B21Turbofan:initCptNames() end
function B21Turbofan:createSoundsCpt(hostCpt) end
function B21Turbofan:destroySoundsCpt() end

function B21Turbofan:controlSound(snd, pitch, gain, offsetKey)
	if gain < 0.01 then
		ED_AudioAPI.stopSource(snd)
	else
		ED_AudioAPI.setSourcePitch(snd, pitch)
		ED_AudioAPI.setSourceGain(snd, gain)
		if not ED_AudioAPI.isSourcePlaying(snd) then
			if offsetKey ~= nil and offsets[offsetKey] ~= nil then
				ED_AudioAPI.playSourceLooped(snd, offsets[offsetKey])
				offsets[offsetKey] = offsets[offsetKey] + 0.5
			else
				ED_AudioAPI.playSourceLooped(snd)
			end
		end
	end
end

function B21Turbofan:update(coreRPM, fanRPM, turbPower, thrust, flame, vTrue)
	local sound_param = {
		[SOUND_FAN_RPM]       = fanRPM,
		[SOUND_TURBINE_POWER] = turbPower,
		[SOUND_TRUE_AIRSPEED] = vTrue,
	}
	for i, v in pairs(self.sounds) do
		local param_gain  = sound_param[v.type_gain]
		local param_pitch = sound_param[v.type_pitch]
		self:controlSound(v.sound, v.pitch_curve:value(param_pitch), v.gain_curve:value(param_gain), nil)
	end
end
