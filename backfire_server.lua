local CarsSettings = {}

-- {0.45,-1.7,-0.5} RIGHT
-- {0,-1.7,-0.5} CENTER
-- {-0.6,-1.3,-0.3} LEFT

local cars = {
	{["id"] = 275,["pos"] = {0.45,-1.7,-0.5}},
}

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end
	return false
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

addEventHandler ( "onResourceStart", resourceRoot,
	function ( )
		for i,data in ipairs(cars) do 
			local veh = getVehicleFromID(data["id"])
			if isElement(veh) then 
				CarsSettings[veh] = {x = data["pos"][1],y = data["pos"][2],z = data["pos"][3]}
			else
				outputDebugString("coudn't find Vehicle With ID " .. data["id"],3)
			end
		end
	end
)

addEventHandler("onVehicleLoaded",getRootElement(),function(id)
	if isElement(source) then 
		for i,data in ipairs(cars) do 
			local veh = getVehicleFromID(data["id"])
			if source == veh then 
				if not CarsSettings[source] then 
					CarsSettings[source] = {x = data["pos"][1],y = data["pos"][2],z = data["pos"][3]}
				end
			end
		end
	end
end)

addEvent ( "create3DBackfireSound", true )
addEventHandler ( "create3DBackfireSound", root,
	function ( veh)
		if ( veh ) then
			if ( type(CarsSettings[veh]) == "table" ) then
				local x, y, z = tonumber(CarsSettings[veh].x), tonumber(CarsSettings[veh].y), tonumber(CarsSettings[veh].z);
				triggerClientEvent(root, "create3DBackfireSoundClient", root, veh, x, y, z)
			end
		end
	end
)


function startMonitoring ( thePlayer, seat, jacked )
	if (seat == 0) then
		triggerClientEvent(thePlayer, "chandeMonitoringState", thePlayer, true, source)
	end
end
addEventHandler ( "onVehicleEnter", getRootElement(), startMonitoring )
 
function stopMonitoring ( thePlayer, seat, jacked )
    if (seat == 0) then
		triggerClientEvent(thePlayer, "chandeMonitoringState", thePlayer, false)
	end
end
addEventHandler ( "onVehicleExit", getRootElement(), stopMonitoring )

function getVehicleFromID(id)
	for i,veh in ipairs(getElementsByType("vehicle")) do 
		if tonumber(getElementData(veh,"dbid")) == tonumber(id) then 
			return veh 
		end
	end
	return false
end