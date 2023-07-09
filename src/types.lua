--Lanred
--6/27/2023

--//core
--main
export type neverFunction = <a>(self: a) -> never

export type events = "create" | "play" | "stop" | "scrub" | "destroy"

export type updateMethod = "RenderStepped" | "Stepped" | "Heartbeat"

export type targets = Instance | { any }

export type targetsNoInstance = { any }

export type defaultInfo = {
	easing: string?,
	duration: number?,
	delay: number?,
}

export type info = defaultInfo & {
	method: updateMethod?,
	reverses: boolean?,
	repeatCount: number?,
	destroyOnComplete: boolean?,
}

export type dataTypeNoFunction = Color3 | CFrame | Vector3 | Vector2 | UDim2 | UDim | number

export type dataType = dataTypeNoFunction & (instance: targets, index: number) -> any

export type propertyParametersInfo = defaultInfo & {
	addValue: boolean?,
}

export type propertyParameters = propertyParametersInfo & {
	value: dataType | { dataTypeNoFunction },
}

export type property = dataType | propertyParameters

export type properties = {
	[string]: property,
}

return nil
