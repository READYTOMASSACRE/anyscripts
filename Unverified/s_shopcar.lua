local scarinfo = "carinfo"
local repairhealth = 1000
local DEFAULT_CAR_COLOR = {0,0,0}
local DEFAULT_NICK_COLOR = {255,255,255}
local DEFAULT_CHAT_COLOR = {255,255,255}
local DEFAULT_LIGHTS_COLOR = {255,255,255}

function initCarInfo(acc)
	-- body	
	local sendto = fromJSON(getAccountData(acc,scarinfo))
	setElementData(source,scarinfo,sendto)
	local car = getPlayerCar(source)
	addEventHandler("onVehicleDamage",car,cardmg)
end

function terminateCarInfo(acc)
	-- body
	local car = getPlayerCar(source)
	removeEventHandler("onVehicleDamage",car,cardmg)
	shopCar("gmOff")
	local carInfo = getElementData(source,scarinfo)
	local sendto = toJSON(carInfo)
	setAccountData(acc,scarinfo,sendto)
	setElementData(source,scarinfo,nil)
end

function getPlayerCar( player )
	-- body
	local cars = getElementsByType("vehicle")
	for i,car in ipairs(cars) do
		if getVehicleOccupant(car) == player then
			return car	
		end
	end
	return false
end

function parseCarInfo(player,key,value)
	-- body
	local carinfo = getElementData(player,scarinfo)
	carinfo[key] = value
	setElementData(player,scarinfo,carinfo)
end

function shopCar( item , carcolor, lightscolor, nickcolor, chatcolor, idupgrade ) -- first arg - color
	-- body
	carcolor = carcolor or DEFAULT_CAR_COLOR
	lightscolor = lightscolor or DEFAULT_LIGHTS_COLOR
	nickcolor = nickcolor or DEFAULT_NICK_COLOR
	chatcolor = chatcolor or DEFAULT_CHAT_COLOR
	if item == "" or item == nil then return false end
	local car = getPlayerCar(source)
	if car then
	if item == "repair" then setElementHealth(car,repairhealth) parseCarInfo(source,"repair",repairhealth)
	elseif item == "flip" then local x,y,z = getElementRotation(car) setElementRotation(car,0,0,z)
	elseif item == "gmOn" then addEventHandler("onVehicleDamage",car,gmCar) parseCarInfo(source,"gmOn",true)
	elseif item == "gmOff" then removeEventHandler("onVehicleDamage",car,gmCar) parseCarInfo(source,"gmOn",nil)
	elseif item == "carcolor" then setVehicleColor(car,unpack(carcolor)) parseCarInfo(source,"carcolor",carcolor)
	elseif item == "lightscolor" then setVehicleHeadLightColor(car,unpack(lightscolor)) parseCarInfo(source,"lightscolor",lightscolor)
	elseif item == "nickcolor" then setPlayerNametagColor(source,unpack(nickcolor)) parseCarInfo(source,"nickcolor",nickcolor)
	elseif item == "chatcolor" then addEventHandler("onPlayerChat",source,playerChatColor) parseCarInfo(source,"chatcolor",chatcolor)
	elseif item == "chatcoloroff" then removeEventHandler("onPlayerChat",source,playerChatColor) parseCarInfo(source,"chatcolor",nil) 	
	elseif item == "carupgrade" then addVehicleUpgrade(car,idupgrade) parseCarInfo(source,"carupgrade",idupgrade)
	end
	return true else return false end
end

function playerChatColor( msg,msgtype )
	-- body
	if msgtype == 0 then
		cancelEvent()
		local t = getElementData(source,scarinfo)
		local chat = t.chatcolor
		local nick = tocolor(getPlayerNameTag(source))
		outputChatBox(nick..getPlayerName(source)..": "..msg,root,unpack(chat),true)
	end
end
function cardmg(dmg)
	-- body
	local player = getVehicleOccupant(source)
	local health = getElementHealth(player)
	parseCarInfo(player,"health",health - dmg)	
end

addEvent("onShopCar",true)
addEventHandler("onShopCar",root,shopCar)
