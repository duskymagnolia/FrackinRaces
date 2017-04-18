function init()
  self.protectionBonus = config.getParameter("protectionBonus", 0)
  baseValue = config.getParameter("healthBonus",0)*(status.resourceMax("health"))
  baseValue2 = config.getParameter("energyBonus",0)*(status.resourceMax("energy"))
  baseValue3 = config.getParameter("fallBonus",0)*(status.stat("fallDamageMultiplier"))
  baseValue4 = config.getParameter("healthPenalty",0)*(status.resourceMax("health"))
  baseValue5 = config.getParameter("energyPenalty",0)*(status.resourceMax("energy"))
  self.protectionBonus2 = config.getParameter("protectionPenalty", 0) 
  self.tickDamagePercentage = 0.010
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
  script.setUpdateDelta(5)
end

function update(dt)
  if world.entitySpecies(entity.id()) == "glitch" or world.entitySpecies(entity.id()) == "trink" or world.entitySpecies(entity.id()) == "droden" then
    applyEffects()
  else
    if self.tickTimer <= 0 then
      self.tickTimer = self.tickTime
      status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "poison",
        sourceEntityId = entity.id()
      })
      effect.setParentDirectives("fade=806e4f="..self.tickTimer * 0.4)
    end  
    applyEffects()
  end
  self.tickTimer = self.tickTimer - dt
end

function applyEffects()
  if world.entitySpecies(entity.id()) == "glitch" or world.entitySpecies(entity.id()) == "trink" or world.entitySpecies(entity.id()) == "droden" then
            status.setPersistentEffects("glitchpower1", {
              {stat = "protection", amount = self.protectionBonus},
              {stat = "maxHealth", amount = baseValue },
              {stat = "maxEnergy", amount = baseValue2 },
              {stat = "fallDamageMultiplier", amount = baseValue3}
            })
  else
	    status.setPersistentEffects("noglitch1", {
	        {stat = "protection", amount = self.protectionBonus2},
	        {stat = "maxHealth", amount = baseValue4 },
	        {stat = "maxEnergy", amount = baseValue5 }
	      })
  end
end

function uninit()
  status.clearPersistentEffects("glitchpower1")
  status.clearPersistentEffects("noglitch1")
end