import Foundation

class Log {
    static var logLevel = 0

    static func checkFatal(_ condition: Bool, _ description: String) {
        if condition {
            fatal(description)
        }
    }

    static func fatal(_ description: String) {
        print("fatal error:", description)
        exit(1)
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
    static func parse(file: String) -> DFA? {
        let spec = try! String(contentsOfFile: file)
        let lines = spec.components(separatedBy: "\n")

        var currentState: State? // state being parsed rn
        var states = [State]()
        var acceptingStates = [State]()
        var initialState: State?

        var beginIndex: Int = 0

        if let firstLine = lines.first {
            if firstLine.starts(with: "#!") {
                beginIndex = 2
            }
        } else {
            return nil
        }

        for i in beginIndex..<lines.count-1 {
            let currentLine = lines[i].trimmingCharacters(in: .whitespaces)
            let tokens = currentLine.components(separatedBy: " ")

            let isToplevel = lines[i].first != " "
            let isComment = currentLine.starts(with: "#")

            if currentLine.isEmpty || isComment {
                continue

            } else if isToplevel {
                let stateId = tokens.first!
                currentState = State(id: String(stateId))
                states.append(currentState!)

                if tokens.contains("a") {
                    acceptingStates.append(currentState!)
                }

                if tokens.contains("i") {
                    Log.checkFatal(initialState != nil, "initial state must be unique")
                    initialState = currentState!
                }

            } else {
                let symbol = String(tokens.first!)
                let targetId = tokens.last!
                currentState!.addTransition(on: symbol, to: targetId)
            }
        }

        Log.checkFatal(initialState == nil, "initial state must be defined")

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
        return s
    }

    func reset() {
        self.currentState = initialState
    }

    func process(_ input: [String]) -> Bool {
        reset()
        for symbol in input {
            if let targetId = currentState.transitions[symbol], let targetIndex = states.firstIndex(where: {$0.id == targetId}) {
                currentState = states[targetIndex]
                Log.debug("\(symbol) -> \(currentState)")
            } else {
                Log.fatal("missing transition on symbol '\(symbol)' from state '\(currentState.id)'")
                return false
            }
        }
        Log.note("ended in state \(currentState)")
        return acceptingStates.contains(where: {$0.id == currentState.id})
    }
}

class State: Identifiable, CustomStringConvertible {
    var id: String
    var transitions = [String:String]()

    init(id: String) {
        self.id = id
    }

    var description: String {
        return id
    }

    func addTransition(on symbol: String, to state: String) {
        transitions[symbol] = state
    }
}


Log.checkFatal(CommandLine.arguments.count < 2, "usage: \(CommandLine.arguments[0]) dfa_spec [ word ]")

let f = CommandLine.arguments[1]

if let dfa = Parser.parse(file: f) {
    Log.debug("parsed \(dfa)")

    var word = [String]()
    for i in 2..<CommandLine.arguments.count {
        word.append(CommandLine.arguments[i])
    }

    print(dfa.process(word) ? "accept" : "reject")

} else {
    Log.fatal("could not parse \(f)")
}


