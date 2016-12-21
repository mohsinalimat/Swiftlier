//
//  FileArchiver.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/27/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import Foundation

public struct FileArchive {
    public static func archiveEncodable(_ encodable: EncodableType, toFile file: String, encrypt: (Data) throws -> Data = {return $0}) throws {
        let object = NativeTypesEncoder.objectFromEncodable(encodable, mode: .saveLocally)
        let data = try encrypt(NSKeyedArchiver.archivedData(withRootObject: object))
        try data.write(to: URL(fileURLWithPath: file), options: Data.WritingOptions.atomicWrite)
    }

    public static func archiveDictionaryOfEncodable<E: EncodableType>(_ dictionary: [String:E], toFile file: String, encrypt: (Data) throws -> Data = {return $0}) throws {
        var finalDict = [String:Any]()

        for (key, value) in dictionary {
            finalDict[key] = NativeTypesEncoder.objectFromEncodable(value, mode: .saveLocally)
        }

        let data = try encrypt(NSKeyedArchiver.archivedData(withRootObject: finalDict))
        try data.write(to: URL(fileURLWithPath: file), options: Data.WritingOptions.atomicWrite)
    }

    public static func archiveArrayOfEncodable<E: EncodableType>(_ array: [E], toFile file: String, encrypt: (Data) throws -> Data = {return $0}) throws {
        var finalArray = [Any]()

        for value in array {
            finalArray.append(NativeTypesEncoder.objectFromEncodable(value, mode: .saveLocally))
        }

        let data = try encrypt(NSKeyedArchiver.archivedData(withRootObject: finalArray))
        try data.write(to: URL(fileURLWithPath: file), options: Data.WritingOptions.atomicWrite)
    }

    public static func unarchiveEncodableFromFile<E: DecodableType>(_ file: String, decrypt: (Data) throws -> Data = {return $0}) throws -> E? {
        guard var data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        data = try decrypt(data)

        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                reason: .internal
            )
        }

        let value: E = try NativeTypesDecoder.decodableTypeFromObject(object, mode: .saveLocally)
        return value
    }

    public static func unarchiveDictionaryOfEncodableFromFile<E: DecodableType>(_ file: String, decrypt: (Data) throws -> Data = {return $0}) throws -> [String:E]? {
        guard var data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        data = try decrypt(data)

        guard let rawDict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:[String: Any]] else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                reason: .internal
            )
        }

        var finalDict = [String:E]()

        for (key, subDict) in rawDict {
            finalDict[key] = try NativeTypesDecoder.decodableTypeFromObject(subDict, mode: .saveLocally) as E
        }

        return finalDict
    }

    public static func unarchiveArrayOfEncodableFromFile<E: DecodableType>(_ file: String, decrypt: (Data) throws -> Data = {return $0}) throws -> [E]? {
        guard var data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        data = try decrypt(data)

        guard let rawArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Any] else {
            throw LocalUserReportableError(
                source: "FileArchive",
                operation: "loading data",
                message: "Invalid file found",
                reason: .internal
            )
        }

        var finalArray = [E]()

        for rawObject in rawArray {
            if let object: E = try? NativeTypesDecoder.decodableTypeFromObject(rawObject, mode: .saveLocally) {
                finalArray.append(object)
            }
        }

        return finalArray
    }
}
#endif
