--!nocheck

local Signal = require(script.Signal)
local Types = require(script.Types)
local Utility = require(script.Utility)

local DEFAULT_STATE = "Idle"

local BasicState = {}
BasicState.__index = BasicState

export type BasicState = typeof(setmetatable(
	{} :: {
		_States: Types.States,
		_StateTransitions: Types.Transitions,
		_StateFunctions: Types.StateFunctions,
		_CurrentState: string,
		_Signal: Signal.Signal,
		_PreviousState: string,
	},
	BasicState
))

function BasicState.new(States: Types.States, StateTransitions: Types.Transitions, StateFunctions: Types.StateFunctions)
	local self = setmetatable({
		_States = States,
		_StateTransitions = StateTransitions,
		_StateFunctions = StateFunctions,
		_CurrentState = DEFAULT_STATE,
		_PreviousState = "",
		_Signal = Signal.new(),
	}, BasicState)

	return self
end

function BasicState.ChangeState(self: BasicState, NewState: string)
	if not NewState then
		return
	end

	if NewState == self._CurrentState then
		return
	end

	if not Utility.IsStateValid(self._States, NewState) then
		return
	end

	if not Utility.CanTransitionFrom(self._CurrentState, NewState, self._StateTransitions) then
		return
	end

	local IsAvailable, ExitFunction = Utility.IsExitFunctionAvailable(self._CurrentState, self._StateFunctions, false)
	if IsAvailable and ExitFunction then
		ExitFunction()
	end

	self._PreviousState = self._CurrentState
	self._CurrentState = NewState

	local _IsAvailable, EnterFunction = Utility.IsEnterFunctionAvailable(NewState, self._StateFunctions, false)
	if _IsAvailable and EnterFunction then
		EnterFunction()
	end

	self._Signal:Fire(self._PreviousState, self._CurrentState)
end

function BasicState.GetCurrentState(self: BasicState)
	return self._CurrentState
end

function BasicState.GetPreviousState(self: BasicState)
	return self._PreviousState
end

function BasicState.IsStateValid(self: BasicState, StateToCheck: string)
	return Utility.IsStateValid(self._States, StateToCheck)
end

function BasicState.GetSignal(self: BasicState)
	return self._Signal
end

function BasicState.CanTransitionTo(self: BasicState, StateToCheck: string)
	return Utility.CanTransitionFrom(self._CurrentState, StateToCheck, self._StateTransitions)
end

function BasicState.Destroy(self: BasicState)
	if self._Signal then
		self._Signal:Destroy()
	end
end

return BasicState
