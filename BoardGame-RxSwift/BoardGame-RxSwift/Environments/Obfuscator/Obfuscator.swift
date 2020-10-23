//
//  Obfuscator.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation

// This struct is based on Obfuscator class from https://gist.github.com/DejanEnspyra/80e259e3c9adf5e46632631b49cd1007
struct Obfuscator {
    /// The string used to ofuscate and reveal data.
    let salt: String
    
    /// Initializes the receiver with given salt string.
    ///
    /// - Parameter salt: A string that will be used to reveal and obfuscate data.
    /// To create a salt, you can use any string, but it's preferable to use a `generated` string,
    /// for example NSStringFromClass(NSDictionary.self).
    public init(salt: String) {
        self.salt = salt
    }
    
    /**
     This method obfuscates the string passed in using the salt
     that was used when the Obfuscator was initialized.
     
     - parameter string: the string to obfuscate
     
     - returns: the obfuscated string in a byte array
     */
    func obfuscate(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let encrypted = toggle(bytes: text)
        return encrypted
    }
    
    /**
     This method reveals the original string from the obfuscated
     byte array passed in. The salt must be the same as the one
     used to encrypt it in the first place.
     
     - parameter key: the byte array to reveal
     
     - returns: the original string
     */
    func reveal(bytes: [UInt8]) -> String? {
        let decrypted = toggle(bytes: bytes)
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    /// Simply apply an XOR on input bytes.
    ///
    /// Currently, `reveal` and `obfuscate` methods do the same thing.
    /// - Parameter bytes: The bytes to xor.
    /// - Returns: The xored data.
    private func toggle(bytes: [UInt8]) -> [UInt8] {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count

        let xored = bytes.enumerated().map { $0.element ^ cipher[$0.offset % length] }
        return xored
    }
}
