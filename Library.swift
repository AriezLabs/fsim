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

