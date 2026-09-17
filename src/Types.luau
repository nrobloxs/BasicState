local Types = {}

export type States = { string }

export type Transitions = { [string]: { string } }

export type StateFunction = {
	Exit: (() -> ())?,
	Enter: (() -> ())?,
}

export type StateFunctions = { [string]: StateFunction }

return Types
