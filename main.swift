Log.checkFatal(CommandLine.arguments.count < 2, "usage: \(CommandLine.arguments[0]) dfa_spec [ word ]")

let f = CommandLine.arguments[1]

if let fsm = Parser.parse(file: f) {
    Log.debug("parsed \(fsm)")

    var word = [String]()
    for i in 2..<CommandLine.arguments.count {
        word.append(CommandLine.arguments[i])
    }

    print(fsm.process(word) ? "accept" : "reject")

} else {
    Log.fatal("could not parse \(f)")
}


