//
//  CellValueGenerator.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import Foundation

class PositionValueGenerator {
    static func generate(position: Position, grid: [[Cell]]) -> Int {
        let minX = position.x > 0 ? position.x - 1 : 0
        let maxX = position.x < grid[0].endIndex - 1 ? position.x + 1 : position.x
        let minY = position.y > 0 ? position.y - 1 : 0
        let maxY = position.y < grid.endIndex - 1 ? position.y + 1 : position.y
        
        var count = 0
        for x in minX...maxX {
            for y in minY...maxY {
                if x == position.x && y == position.y { continue }
                let neighbor = grid[y][x]
                if neighbor.isMine {
                    count += 1
                }
            }
        }
        return count
    }
}
