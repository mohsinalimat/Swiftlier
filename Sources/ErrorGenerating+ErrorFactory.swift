//
//  LocalUserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension ErrorGenerating {
    public static func error(_ doing: String, because: String) -> ReportableError {
        let reason = ErrorReason(because)
        return self.error(doing, because: reason)
    }

    public static func error(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return ReportableError(from: self, by: .system, doing: doing, because: reason)
    }

    public static func error(_ doing: String, from: Error) -> ReportableError {
        switch from {
        case let reportable as ReportableError:
            return reportable
        case let convertible as ReportableErrorConvertible:
            return convertible.reportableError
        case let nsError as NSError where nsError.domain == "NSURLErrorDomain":
            switch nsError.code {
            case -1009:
                return self.error(doing, because: NetworkResponseErrorReason(kind: .noInternet, customMessage: nil))
            case -999:
                return self.error(doing, because: NetworkResponseErrorReason(kind: .untrusted, customMessage: nil))
            default:
                break
            }
        case let error as DecodingError:
            switch error {
            case .dataCorrupted(let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                return self.error(doing, because: "the value at \(path) is corrupted. More information: `\(context.debugDescription)`")
            case .keyNotFound(let key, let context):
                if context.codingPath.isEmpty {
                    return self.error(doing, because: "the key for \(key.stringValue) was not found. More information: `\(context.debugDescription)`")
                }
                else {
                    let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                    return self.error(doing, because: "the key at \(path) for \(key.stringValue) was not found. More information: `\(context.debugDescription)`")
                }
            case .valueNotFound(let type, let context):
                if context.codingPath.isEmpty {
                    return self.error(doing, because: "the value for \(type) was not found. More information: `\(context.debugDescription)`")
                }
                else {
                    let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                    return self.error(doing, because: "the value at \(path) for \(type) was not found. More information: `\(context.debugDescription)`")
                }
            case .typeMismatch(let type, let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                return self.error(doing, because: "the value at \(path) is not an \(type). More information: `\(context.debugDescription)`")
            }
        case let error as EncodingError:
            switch error {
            case .invalidValue(let value, let context):
                let path = context.codingPath.map({$0.stringValue}).joined(separator: ".")
                return self.error(doing, because: "the value (\(value)) at \(path) is invalid. More information: `\(context.debugDescription)`")
            }
        default:
            break
        }

        return self.error(doing, because: from.localizedDescription)
    }

    public static func userError(_ doing: String, because: String) -> ReportableError {
        let reason = ErrorReason(because)
        return self.userError(doing, because: reason)
    }

    public static func userError(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return ReportableError(from: self, by: .user, doing: doing, because: reason)
    }

    public func error(_ doing: String, because: String) -> ReportableError {
        return Self.error(doing, because: because)
    }

    public func error(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return Self.error(doing, because: reason)
    }

    public func error(_ doing: String, from: Error) -> ReportableError {
        return Self.error(doing, from: from)
    }

    public func userError(_ doing: String, because: String) -> ReportableError {
        return Self.userError(doing, because: because)
    }

    public func userError(_ doing: String, because reason: AnyErrorReason) -> ReportableError {
        return Self.userError(doing, because: reason)
    }
}
