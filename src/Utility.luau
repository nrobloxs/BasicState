--!nocheck

local Types = require(script.Parent.Types)
local Utility = {}

function Utility.IsStateValid(StateDefinitions: Types.States, StateToCheck: string)
	return table.find(StateDefinitions, StateToCheck) ~= nil
end

function Utility.IsExitFunctionAvailable(
	StateToCheck: string,
	StateFunctionsDefinitions: Types.StateFunctions,
	OnlyCheck: boolean
): (boolean, (() -> ())?)
	local stateFunctions = StateFunctionsDefinitions[StateToCheck]

	if stateFunctions == nil or stateFunctions.Exit == nil then
		return false, nil
	end

	if OnlyCheck then
		return true, nil
	end

	return true, stateFunctions.Exit
end

function Utility.CanTransitionFrom(
	CurrentState: string,
	TransitionState: string,
	StateTransitionDefinitions: Types.Transitions
): boolean
	local entry = StateTransitionDefinitions[CurrentState]

	if not entry then
		return false
	end

	if table.find(entry, TransitionState) then
		return true
	else
		return false
	end
end

function Utility.IsEnterFunctionAvailable(
	StateToCheck: string,
	StateFunctionsDefinitions: Types.StateFunctions,
	OnlyCheck: boolean
): (boolean, (() -> ())?)
	local stateFunctions = StateFunctionsDefinitions[StateToCheck]

	if stateFunctions == nil or stateFunctions.Enter == nil then
		return false, nil
	end

	if OnlyCheck then
		return true, nil
	end

	return true, stateFunctions.Enter
end

return Utility
