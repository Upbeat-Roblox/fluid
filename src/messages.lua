--[[
	@title messages
	@author Lanred
]]

return {
	invalidType = "'%s' is not a valid '%s' for the '%s' argument.",

	creation = {
		invalidTargets = "'%s' is not a valid type for targets. A target must be a 'Instance', array of 'Instance', or a dictionary.",
		invalidProperties = "The properties argument must be a dictionary containing the target property values.",
		invalidServerTargets = "'%s' is not a valid type for targets. A target must be a 'Instance' or a array of 'Instance' on the server.",
	},

	easing = {
		styleNotRegistered = "'%s' is not a registered easing style. Use the 'registerStyle' method instead.",
		alreadyRegisteredStyle = "'%s' is already registered as a easing style. Use the 'updateStyle' method instead.",
	},

	parser = {
		renderSteppedOnServer = "The 'RenderStepped' update method is only valid on the client. Try 'Stepped' or 'Heartbeat'.",
		invalidInfo = "The 'info' argument must be a dictionary containing the tween info.",
		invalidUpdateMethod = "'%s' is not a valid update method. The valid methods are 'RenderStepped', 'Stepped', and 'Heartbeat'.",
		invalidAdd = "'%s' is not a valid boolean for the add argument",
		invalidEasing = "'%s' is not a valid easing style.",
		invalidPropertyParameters = "The passed property parameters are invalid.",
		propertyParameterDurationToSmall = "A '%s' second duration is smaller than the tween duration '%s'.",
		valueParameterIsAFunction = "The value argument for the expanded property parameters cannot be a 'function' type.",
		modelPropertiesAreNotTheSame = "Due to current limitations all BaseParts must have the same starting values to tween a model.",
		invalidModelProperties = "The '%s' property is not a tweenable property.",
		noValidModelBaseParts = "The model, '%s', does not have any BaseParts to tween.",
		invalidTargetDataType = "'%s' and '%s' are not matching data types. If you wish to have a start and end value for a goal value then confirm that both values are of the same type.",
		updateStepsOnClient = "The 'updateSteps' argument is only valid on the server.",
	},

	tween = {
		tweenAlreadyPlaying = "The 'play' method was called but the tween has already been started.",
		triedToMethodButTweenNotPlaying = "The '%s' method was called but the tween is not playing.",
	},
}
