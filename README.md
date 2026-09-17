# BasicState

A lightweight Roblox state machine library for organizing gameplay flow, UI states, and lifecycle logic.

## Installation

Add the package with Wally:

```toml
[dependencies]
BasicState = "nrobloxs/basicstate@0.1.3"
```

Then require it in your Roblox Lua code:

```lua
local BasicState = require(game:GetService("ReplicatedStorage").BasicState)
```

If you are using a different folder layout, adjust the path to wherever the package is installed.

## Overview

BasicState gives you a simple, explicit pattern for:

- tracking the current state
- validating allowed transitions
- running Enter/Exit hooks for states
- firing a signal when the state changes

## Usage

```lua
local BasicState = require(game:GetService("ReplicatedStorage").BasicState)

local States = {
    "Idle",
    "Running",
    "Jumping",
    "Falling",
}

local Transitions = {
    Idle = { "Running", "Jumping" },
    Running = { "Idle", "Jumping" },
    Jumping = { "Falling" },
    Falling = { "Idle", "Running" },
}

local Functions = {
    Idle = {
        Enter = function()
            print("Player is idle")
        end,
        Exit = function()
            print("Leaving idle")
        end,
    },
    Running = {
        Enter = function()
            print("Running started")
        end,
    },
    Jumping = {
        Enter = function()
            print("Jump started")
        end,
    },
    Falling = {
        Enter = function()
            print("Falling started")
        end,
    },
}

local stateMachine = BasicState.new(States, Transitions, Functions)

stateMachine:GetSignal():Connect(function(previousState, currentState)
    print("State changed:", previousState, "->", currentState)
end)

stateMachine:ChangeState("Running")
print(stateMachine:GetCurrentState()) -- Running
print(stateMachine:CanTransitionTo("Jumping")) -- true
```

## API

### BasicState.new(States, Transitions, StateFunctions)

Creates a new state machine.

Parameters:

- `States`: an array of valid state names
- `Transitions`: a map of current state names to arrays of valid next states
- `StateFunctions`: a map of state names to `{ Enter = function?, Exit = function? }`

### :ChangeState(NewState)

Attempts to move to a valid target state. It will:

- reject invalid states
- reject illegal transitions
- run the current state's `Exit` callback
- run the next state's `Enter` callback
- fire the state-change signal

### :GetCurrentState()
Returns the active state.

### :GetPreviousState()
Returns the last state before the most recent transition.

### :IsStateValid(StateToCheck)
Returns whether a state exists in the state list.

### :CanTransitionTo(StateToCheck)
Returns whether the machine can legally move from its current state to the target state.

### :GetSignal()
Returns the internal signal fired whenever the state changes.

### :Destroy()
Cleans up the signal connection data.

## State entry and exit hooks

Each state can optionally define:

```lua
local StateFunctions = {
    Combat = {
        Enter = function()
            -- runs when entering
        end,
        Exit = function()
            -- runs when leaving
        end,
    },
}
```

These hooks are optional and only run when a valid transition occurs.

## Notes

- The default current state is `Idle`.
- Invalid transitions are ignored silently.
- This library is intentionally lightweight and designed for gameplay logic, modules, and UI flow.

## License

This project is provided as-is for Roblox game development and package publishing.
