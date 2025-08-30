import Foundation
import CCXTCore

extension Exchange.CCXTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .exchange(let msg):
            return msg                          // show the exchange text
        case .decoding(let err):
            return "JSON decoding failed: \(err.localizedDescription)"
        }
    }
}

public class Exchange {
    private let exchange: CcxtCCXTGoExchange
    
    public init?(exchangeName: String, config: [String: Any]? = nil) {
        let configString: String

        if let config = config,
           let jsonData = try? JSONSerialization.data(withJSONObject: config, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            configString = jsonString
        } else {
            configString = "{}"
        }
        guard let ex = CcxtNewExchange(exchangeName, configString) else {
            return nil
        }
        self.exchange = ex
    }

    private func cleanAny(_ value: Any) -> Any? {
        switch value {
        case is NSNull:
            return nil
        case let number as NSNumber:
            if CFGetTypeID(number) == CFBooleanGetTypeID() {
                return number.boolValue
            } else {
                return number
            }
        case let dict as [String: Any]:
            var cleaned: [String: Any] = [:]
            for (key, val) in dict {
                if let cleanedVal = cleanAny(val) {
                    cleaned[key] = cleanedVal
                }
            }
            return cleaned
        case let array as [Any]:
            return array.compactMap { cleanAny($0) }
        default:
            return value
        }
    }

    private func stringify<T: Encodable>(_ object: T, prettyPrinted: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if prettyPrinted {
            encoder.outputFormatting = .prettyPrinted
        }

        do {
            let data = try encoder.encode(object)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to stringify object: \(error)")
            return nil
        }
    }
    
    public enum CCXTError: Error {
        case exchange(String)   // message coming back from the Go layer / exchange
        case decoding(Error)    // genuine JSON-decoding problem
    }
    
    private func decode(_ value: Any?) throws -> Any? {
        guard let value = value else {
            return nil
        }

        switch value {
        case let data as Data:
            // Quick check for literal boolean or null
            if var s = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if s == "true" { return true }
                if s == "false" { return false }
                if s == "null" { return nil }

                // Parse number-like strings
                if let intVal = Int(s) { return intVal }
                if let doubleVal = Double(s) { return doubleVal }
            }

            do {
                // Normal JSON parse
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                // CCXT panic parsing
                if let s = String(data: data, encoding: .utf8), s.contains("[ccxtError]::[") {
                    let segments = s.components(separatedBy: "::")
                    if segments.count >= 3 {
                        let rawType = segments[1].trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                        if let jsonStart = s.firstIndex(of: "{"),
                        let jsonEnd = s[jsonStart...].firstIndex(of: "}") {
                            var jsonSubstring = String(s[jsonStart...jsonEnd])
                            jsonSubstring = jsonSubstring.replacingOccurrences(of: "\\\"", with: "\"")
                            if let jsonData = jsonSubstring.data(using: .utf8),
                            let jsonObj = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                                let message = (jsonObj["msg"] as? String) ??
                                            (jsonObj["message"] as? String) ??
                                            jsonSubstring
                                if let errorClass = NSClassFromString("CCXTSwift.\(rawType)") as? BaseError.Type {
                                    throw errorClass.init(message)
                                }
                                throw CCXTError.exchange(message)
                            }
                        }

                        let tail = segments.last ?? ""
                        var plainMsg = tail.replacingOccurrences(of: "]\\nStack:\\n\"", with: "")
                        plainMsg = plainMsg.trimmingCharacters(in: CharacterSet(charactersIn: "[]\"\n "))

                        if let errorClass = NSClassFromString("CCXTSwift.\(rawType)") as? BaseError.Type {
                            throw errorClass.init(plainMsg)
                        }
                        throw CCXTError.exchange(plainMsg)
                    }
                }

                // Non-panic string / invalid JSON
                if var s = String(data: data, encoding: .utf8) {
                    // Strip outer quotes and unescape
                    if s.hasPrefix("\"") && s.hasSuffix("\"") {
                        s.removeFirst()
                        s.removeLast()
                        s = s.replacingOccurrences(of: "\\\"", with: "\"")
                        s = s.replacingOccurrences(of: "\\n", with: "\n")
                    }
                    if let intVal = Int(s) { return intVal }
                    if let doubleVal = Double(s) { return doubleVal }
                    return s
                }

                throw CCXTError.decoding(error)
            }

        case let str as String:
            // Numeric conversion
            if let intVal = Int(str) { return intVal }
            if let doubleVal = Double(str) { return doubleVal }
            return str

        case let number as NSNumber:
            if CFGetTypeID(number) == CFBooleanGetTypeID() {
                return number.boolValue
            } else if CFNumberIsFloatType(number) {
                return number.doubleValue
            } else {
                return number.intValue
            }

        case let bool as Bool:
            return bool

        default:
            return value
        }
    }




    // ------------------------------------------------------------------------

    // ########################################################################
    // ########################################################################
    // ########################################################################
    // ########################################################################
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########        ########################        ########################
    // ########        ########################        ########################
    // ########        ########################        ########################
    // ########        ########################        ########################
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########                        ########                        ########
    // ########################################################################
    // ########################################################################
    // ########################################################################
    // ########################################################################
    // ########        ########        ########                        ########
    // ########        ########        ########                        ########
    // ########        ########        ########                        ########
    // ########        ########        ########                        ########
    // ################        ########################        ################
    // ################        ########################        ################
    // ################        ########################        ################
    // ################        ########################        ################
    // ########        ########        ################        ################
    // ########        ########        ################        ################
    // ########        ########        ################        ################
    // ########        ########        ################        ################
    // ########################################################################
    // ########################################################################
    // ########################################################################
    // ########################################################################

    // ------------------------------------------------------------------------
    // METHODS BELOW THIS LINE ARE TRANSPILED