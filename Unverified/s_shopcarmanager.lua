local sprice = "priceshop"
local items = {
	"repair",
	"flip",
	"gmOn",
	"gmOff",
	"carcolor",
	"lightscolor",
	"nickcolor",
	"chatcolor",
	"chatcoloroff",
	"carupgrade"
}

function carinit(_,acc)
	-- body
		initCarInfo(acc)
		local info = fromJSON(getAccountData(acc,scarinfo))
		for i=1,#items do
			if info[items[i]] ~= nil then
				shopCar(items[i],info.carcolor,info.lightscolor,info.nickcolor,info.chatcolor,info.idupgrade)
			end
		end
end

addEventHandler("onPlayerLogin",root,carinit)
