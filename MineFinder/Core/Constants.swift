//
//  Constants.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import Foundation

enum Constants {
    static let mineValue:Int = 9
}

enum BoardCellState {
    case hidden
    case revealed
    case flagged
    case exploded
}
