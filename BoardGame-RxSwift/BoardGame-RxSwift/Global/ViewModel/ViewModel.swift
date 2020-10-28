//
//  ViewModel.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
