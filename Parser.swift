enum FSMType: String {
    case DFA = "dfa"
    case NFA = "nfa"
}

class Parser {

    static func parse(file: String) -> FSM? {
        let spec = try! String(contentsOfFile: file)
        let lines = spec.components(separatedBy: "\n")

        var currentState: State? // state being parsed rn
        var states = [State]()
        var acceptingStates = [State]()
        var initialState: State?
        var type: FSMType?

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

            let isTypeDeclaration = tokens.first == "type"
            let isToplevel = lines[i].first != " "
            let isComment = currentLine.starts(with: "#")

            if currentLine.isEmpty || isComment {
                continue

            } else if isTypeDeclaration {
                if let t = FSMType(rawValue: tokens.last!.lowercased()) {
                    type = t
                } else {
                    Log.fatal("unknown FSM type \(tokens.last!)")
                }

            } else if isToplevel { // state declaration
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

            } else { // transition declaration
                let symbol = String(tokens.first!)
                let targetId = tokens.last!
                currentState!.addTransition(on: symbol, to: targetId)
            }
        }

        Log.checkFatal(initialState == nil, "initial state must be defined")

        switch type! {
        case .DFA:
            return DFA(states: states, acceptingStates: acceptingStates, initialState: initialState!)
        case .NFA:
            return NFA(states: states, acceptingStates: acceptingStates, initialState: initialState!)
        }
    }
}


