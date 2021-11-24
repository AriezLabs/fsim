import Foundation

class NFA: FSM {
    struct NFAPath {
        var state: State
        var inputPosition: Int
    }

    var currentPaths: [NFAPath]
    var states: [State]
    var acceptingStates: [State]
    var initialState: State

    init(states: [State], acceptingStates: [State], initialState: State) {
        self.states = states
        self.acceptingStates = acceptingStates
        self.initialState = initialState
        self.currentPaths = [NFAPath(state: initialState, inputPosition: 0)]
    }

    var description: String {
        var s = "DFA:\n"
        s += "\tstates: \(states)\n"
        s += "\tinitial state: \(initialState)\n"
        s += "\taccepting states: \(acceptingStates)\n"
        s += "\ttransitions:\n"
        return s
    }

    func reset() {
        self.currentPaths = [NFAPath(state: initialState, inputPosition: 0)]
    }

    func pathAccepts(_ path: NFAPath) -> Bool {
        return isAcceptingState(path.state)
    }

    func isAcceptingState(_ state: State) -> Bool {
        return acceptingStates.firstIndex { $0.id == state.id } != nil
    }

    func process(_ input: [String]) -> Bool {
        reset()
        while !currentPaths.isEmpty {
            var newStates: [NFAPath] = []

            Log.debug("\(currentPaths.count) state(s) in current iteration")

            for path in currentPaths {
                if path.inputPosition >= input.count {
                    if pathAccepts(path) {
                        return true
                    }
                    continue
                }

                let symbol = input[path.inputPosition]

                if let targetIds = path.state.transitions[symbol] {
                    for targetId in targetIds {
                        if let targetIndex = states.firstIndex(where: {$0.id == targetId}) {
                            let newPath = NFAPath(state: states[targetIndex], inputPosition: path.inputPosition + 1)
                            Log.debug("\ttaking transition to \(newPath)")
                            newStates.append(newPath)
                        } else {
                            Log.fatal("state \(targetId) not found")
                        }
                    }
                }

                // handle epsilon-transitions
                if let targetIds = path.state.transitions["epsilon"] {
                    for targetId in targetIds {
                        if let targetIndex = states.firstIndex(where: {$0.id == targetId}) {
                            let newPath = NFAPath(state: states[targetIndex], inputPosition: path.inputPosition)
                            Log.debug("\ttaking epsilon-transition to \(newPath)")
                            newStates.append(newPath)
                        } else {
                            Log.fatal("state \(targetId) not found")
                        }
                    }
                }
            }

            currentPaths = newStates
        }

        return false
    }
}

