//
//  Error+Equality.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import Foundation

extension Error {
    func isEqual(to rhs: Error) -> Bool {
        return Self.areEqual(self, rhs)
    }

    static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
        return lhs.reflectedString == rhs.reflectedString
    }

    var reflectedString: String {
        return String(reflecting: self)
    }

    // Same typed Equality
    func isEqual(_ toError: Self) -> Bool {
        return self.reflectedString == toError.reflectedString
    }
 }

extension NSError {
    // prevents scenario where one would cast swift Error to NSError
    // whereby losing the associatedvalue in Obj-C realm.
    // (IntError.unknown as NSError("some")).(IntError.unknown as NSError)
    func isEqual(toNSError: NSError) -> Bool {
        let lhs = self as Error
        let rhs = toNSError as Error
        return self.isEqual(toNSError) && lhs.reflectedString == rhs.reflectedString
    }
}
