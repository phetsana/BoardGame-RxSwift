//
//  UIFont+TraitsStyles.swift
//  LBC
//
//  Created by Phetsana PHOMMARINH on 03/10/2020.
//  Copyright © 2020 Phetsana PHOMMARINH. All rights reserved.
//

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
