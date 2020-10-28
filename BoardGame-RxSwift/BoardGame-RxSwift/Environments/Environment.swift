//
//  Environments.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 04/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation

enum EnvironmentsError: Error {
    case keyNotFound
    case valueInvalid
    
}

struct Environment {
    private var configuration: ConfigurationFile

    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let configFilename = "CONFIG_FILENAME"
        }
    }
    
    /// Access to the current environment.
    public static var current: Environment = {
        do {
            guard let fileName = Bundle.main.infoDictionary?[Keys.Plist.configFilename] as? String else {
                print("Unable to find configuration environment filename")
                abort()
            }
            
            let bundle = Bundle(for: EnvironmentBundleClass.self)
            guard let configurationFileURL = bundle.url(forResource: fileName, withExtension: "json") else {
                print("Unable to find configuration environment file")
                abort()
            }
            let string = try String(contentsOf: configurationFileURL).trimmingCharacters(in: CharacterSet.newlines)
            let data = Data(string.utf8)
            let decoder = JSONDecoder()
            let environment = try decoder.decode(ConfigurationFile.self, from: data)
            return Environment(configuration: environment)
        } catch {
            print("Unable to load environment: \(error.localizedDescription)")
            abort()
        }
    }()

    var clientID: String {
        let data = Data(configuration.clientId)
        let bytes = [UInt8](data)
        guard let revealString = Environment.obfuscator.reveal(bytes: bytes) else {
            print("Unable to reveal client id")
            abort()
        }
        return revealString
    }

    var baseURL: URL {
        let hostName = configuration.hostName
        guard let baseURL = URL(string: hostName) else {
            print("Unable to get base URL")
            abort()
        }
        return baseURL
    }

    /**
     Struct describing a JSON environment file used to describe the
     application environment in a dedicated file instead of a source file.
     */
    private struct ConfigurationFile: Decodable {
        let clientId: [UInt8]
        let hostName: String
    }

    /// Class used only to access the current framework bundle.
    private class EnvironmentBundleClass {
        private init() {
            // Class used only to access the current framework bundle.
        }
    }

    /**
     Variable used to reveal an obfuscated content.

     - Warning: The `salt` parameter should be changed because the already obfuscated content
     like `privateClientId` will become non usable.
     */
    private static let obfuscator = Obfuscator(salt: [NSStringFromClass(NSPredicate.self), NSStringFromClass(NSAttributedString.self)].joined(separator: ","))
}
