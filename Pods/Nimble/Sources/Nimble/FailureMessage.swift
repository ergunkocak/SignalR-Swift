import Foundation

/// Encapsulates the failure message that matchers can report to the end user.
///
/// This is shared state between Nimble and matchers that mutate this value.
public class FailureMessage: NSObject {
    public var expected: String = "expected"
    public var actualValue: String? = "" // empty string -> use default; nil -> exclude
    public var to: String = "to"
    public var postfixMessage: String = "match"
    public var postfixActual: String = ""
    /// An optional message that will be appended as a new line and provides additional details
    /// about the failure. This message will only be visible in the issue navigator / in logs but
    /// not directly in the source editor since only a single line is presented there.
    public var extendedMessage: String? = nil
    public var userDescription: String? = nil

    public var stringValue: String {
        get {
            if let value = _stringValueOverride {
                return value
            } else {
                return computeStringValue()
            }
        }
        set {
            _stringValueOverride = newValue
        }
    }

    internal var _stringValueOverride: String?

    public override init() {
    }

    public init(stringValue: String) {
        _stringValueOverride = stringValue
    }

    internal func stripNewlines(_ str: String) -> String {
        let whitespaces = CharacterSet.whitespacesAndNewlines
        return str
            .components(separatedBy: "\n")
            .map { line in line.trimmingCharacters(in: whitespaces) }
            .joined(separator: "")
    }

    internal func computeStringValue() -> String {
        var value = "\(expected) \(to) \(postfixMessage)"
        if let actualValue = actualValue {
            value = "\(expected) \(to) \(postfixMessage), got \(actualValue)\(postfixActual)"
        }
        value = stripNewlines(value)

        if let extendedMessage = extendedMessage {
            value += "\n\(stripNewlines(extendedMessage))"
        }

        if let userDescription = userDescription {
            return "\(userDescription)\n\(value)"
        }

        return value
    }
}