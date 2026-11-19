b21_tools = {}

function b21_tools.updateHost(host, params)
	ED_AudioAPI.setHostPosition(host, params.posx, params.posy, params.posz)
	ED_AudioAPI.setHostOrientation(host, params.orienta, params.orientb, params.orientc, params.orientd)
	ED_AudioAPI.setHostVelocity(host, params.velx, params.vely, params.velz)
	ED_AudioAPI.setHostTimestamp(host, params.timestamp)
end

function b21_tools.dbgPrint(what)
	do return end
	print(what)
end
