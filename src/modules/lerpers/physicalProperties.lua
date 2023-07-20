--[[
	@title lerpers/physicalProperties
	@author Lanred, Validark
]]

-- Lerps physical properties.
-- @param {PhysicalProperties} start [The starting physical properties.]
-- @param {PhysicalProperties} target [The target physical properties.]
-- @return (alpha: number) -> PhysicalProperties
return function(start: PhysicalProperties, target: PhysicalProperties): (alpha: number) -> PhysicalProperties
	local startDensity, startElasticity, startElasticityWeight, startFriction, startFrictionWeight =
		start.Density, start.Elasticity, start.ElasticityWeight, start.Friction, start.FrictionWeight
	local deltaDensity, deltaElasticity, deltaElasticityWeight, deltaFriction, deltaFrictionWeight =
		target.Density - startDensity,
		target.Elasticity - startElasticity,
		target.ElasticityWeight - startElasticityWeight,
		target.Friction - startFriction,
		target.FrictionWeight - startFrictionWeight

	-- @param {number} alpha [The alpha.]
	-- @returns PhysicalProperties
	return function(alpha: number): PhysicalProperties
		return PhysicalProperties.new(
			startDensity + alpha * deltaDensity,
			startElasticity + alpha * deltaElasticity,
			startElasticityWeight + alpha * deltaElasticityWeight,
			startFriction + alpha * deltaFriction,
			startFrictionWeight + alpha * deltaFrictionWeight
		)
	end
end
