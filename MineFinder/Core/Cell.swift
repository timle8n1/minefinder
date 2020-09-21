//
//  Cell.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/14/20.
//

import Foundation

struct Cell {
    let isFlagged: Bool
    let isHidden: Bool
    let isMine: Bool
    let nearbyMineCount: Int
    
    static func flag(cell: Cell) -> Cell {
        return Cell(isFlagged: !cell.isFlagged,
                    isHidden: cell.isHidden,
                    isMine: cell.isMine,
                    nearbyMineCount: cell.nearbyMineCount)
    }
    
    static func reveal(cell: Cell) -> Cell {
        return Cell(isFlagged: cell.isFlagged,
                    isHidden: false,
                    isMine: cell.isMine,
                    nearbyMineCount: cell.nearbyMineCount)
    }
}
