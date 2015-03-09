--------------------------------------------------------------------------------
-- Module Declaration
--

local core = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:GetAddon("RaidCore")

local mod = core:NewBoss("ExperimentX89", 67)
if not mod then return end

mod:RegisterEnableMob("ExpÃ©rience X-89")

-- accents are very important in french
-- http://i.imgur.com/POeHxZU.jpg


--------------------------------------------------------------------------------
-- Locals
--

local playerName

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	Print(("Module %s loaded"):format(mod.ModuleName))
	Apollo.RegisterEventHandler("UnitEnteredCombat", 		"OnCombatStateChanged", 	self)
	Apollo.RegisterEventHandler("CHAT_DATACHRON", 		"OnChatDC", 				self)
	Apollo.RegisterEventHandler("SPELL_CAST_START", 		"OnSpellCastStart", self)
	Apollo.RegisterEventHandler("DEBUFF_APPLIED", 			"OnDebuffApplied", 			self)
end


--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:OnSpellCastStart(unitName, castName, unit)
	if unitName == "ExpÃ©rience X-89" and castName == "Hurlement retentissant" then
		core:AddMsg("Bump", "BUMP !", 5, "Alert")
		core:AddBar("Bump", "CD du Bump", 23)
	elseif unitName == "ExpÃ©rience X-89" and castName == "Crachat rÃ©pugnant" then
		core:AddMsg("Crachat", "CRACHAT!!", 5, "Alarm")
		core:AddBar("Crachat", "CD du Crachat", 40)
	elseif unitName == "ExpÃ©rience X-89" and castName == "Onde de choc dÃ©vastatrice" then
		core:AddMsg("Cleave", "Cleave!!", 5, "Alarm")
		core:AddBar("Cleave", "CD du Cleave", 19)
	end
end

function mod:OnChatDC(message)
	if message:find("L'expÃ©rience X-89 a posÃ© une bombe") then
		local pName = string.gsub(string.sub(message, 38), "!", "")
		if pName == playerName then
			core:AddMsg("Grosse Bombe", "GROSSE BOMBE !!!", 5, "Destruction", "Red")
		end
	end
end

function mod:OnDebuffApplied(unitName, splId, unit)
	if splId == 47316 then
		core:AddMsg("Petite Bombe", "PETITE BOMBE!!!", 5, "RunAway", "Red")
		core:AddBar("Petite Bombe", "CD de Petite Bombe", 5, 1)
	end
end


function mod:OnCombatStateChanged(unit, bInCombat)
	if unit:GetType() == "NonPlayer" and bInCombat then
		local sName = unit:GetName()
		if sName == "ExpÃ©rience X-89" then
			self:Start()
			playerName = GameLib.GetPlayerUnit():GetName()
			core:AddUnit(unit)
			core:UnitDebuff(GameLib.GetPlayerUnit())
			core:WatchUnit(unit)
			core:StartScan()
			core:AddBar("Bump", "CD du Bump", 6)
			core:AddBar("Crachat", "CD du Crachat", 17)
			core:AddBar("Cleave", "CD du Cleave", 36)
		end
	end
end
