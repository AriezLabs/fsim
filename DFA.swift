import Foundation

class Log {
    static var logLevel = 0

    static func errorChk(_ condition: Bool, _ description: String) {
        if condition {
            print("error:", description)
            exit(1)
        }
    }

    static func note(_ description: String) {
        if logLevel >= 1 {
            print("note:", description)
        }
    }

    static func debug(_ description: String) {
        if logLevel >= 2 {
            print("debug:", description)
        }
    }
}

class Parser {
    static func parse(file: String) -> DFA {
        let spec = try! String(contentsOfFile: file)
        let lines = spec.components(separatedBy: "\n")

        var currentState: State? // state being parsed rn
        var states = [State]()
        var acceptingStates = [State]()
        var initialState: State?

        for i in 1..<lines.count-1 {
            let currentLine = lines[i].trimmingCharacters(in: .whitespaces)
            let isToplevel = currentLine.contains(":")
            let tokens = currentLine.components(separatedBy: " ")

            if currentLine.isEmpty {
                continue
            }

            if isToplevel {
                let stateId = tokens.first!.dropLast()
                currentState = State(id: String(stateId))
                states.append(currentState!)

                if tokens.contains("a") {
                    acceptingStates.append(currentState!)
                }

                if tokens.contains("i") {
                    Log.errorChk(initialState != nil, "initial state must be unique")
                    initialState = currentState!
                }

            } else {
                let char = Character(tokens.first!)
                let targetId = tokens.last!
                currentState?.addTransition(on: char, to: targetId)
            }
        }

        Log.errorChk(initialState == nil, "initial state must be defined")

        return DFA(states: states, acceptingStates: acceptingStates, initialState: initialState!)
    }
}

class DFA: CustomStringConvertible {
    var currentState: State
    var states: [State]
    var acceptingStates: [State]
    var initialState: State

    init(states: [State], acceptingStates: [State], initialState: State) {
        self.states = states
        self.acceptingStates = acceptingStates
        self.initialState = initialState
        self.currentState = initialState
    }

    var description: String {
        var s = "DFA:\n"
        s += "\tstates: \(states)\n"
        s += "\tinitial state: \(initialState)\n"
        s += "\taccepting states: \(acceptingStates)\n"
        s += "\ttransitions:\n"
        var alphabet = Set<Character>()
        for state in states {
            for transition in state.transitions {
                s += "\t\t\(state.id) -\(transition.key)-> \(transition.value)\n"
                alphabet.insert(transition.key)
            }
        }
        s += "\talphabet: \(alphabet)\n"
        return s
    }

    func reset() {
        self.currentState = initialState
    }

    func process(_ input: String) -> Bool {
        reset()
        for char in input {
            if let targetId = currentState.transitions[char], let targetIndex = states.firstIndex(where: {$0.id == targetId}) {
                currentState = states[targetIndex]
            } else {
                Log.note("missing transition on '\(char)' from state \(currentState.id)")
                return false
            }
        }
        Log.debug("ended in state \(currentState)")
        return acceptingStates.contains(where: {$0.id == currentState.id})
    }
}

class State: Identifiable, CustomStringConvertible {
    var id: String
    var transitions = [Character:String]()

    init(id: String) {
        self.id = id
    }

    var description: String {
        return id
    }

    func addTransition(on char: Character, to state: String) {
        transitions[char] = state
    }
}



Log.errorChk(CommandLine.arguments.count < 2, "usage: \(CommandLine.arguments[0]) dfa_spec [ word ]")

let f = CommandLine.arguments[1]
let dfa = Parser.parse(file: f)

Log.debug("parsed \(dfa)")

for i in 2..<CommandLine.arguments.count {
    let word = CommandLine.arguments[i]
    print(dfa.process(word) ? "\(word)\tL(M)" : "\(word)")
}

