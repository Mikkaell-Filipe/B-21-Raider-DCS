dofile("Aircraft/Planes/Plane.lua")

B21 = plane:new()

dofile("Aircraft/Engines/B21Turbofan.lua")

function B21:createEngines()
	-- 2 turbofans (indices alinhados com ED_FM_ENGINE_1_* e ED_FM_ENGINE_2_* no EFM)
	self.engines[1] = B21Turbofan:new()
	self.engines[1]:init(1, host)
	self.engines[2] = B21Turbofan:new()
	self.engines[2]:init(2, host)
end

B21:createEngines()

function onUpdate(params)
	B21:onUpdate(params)
end
