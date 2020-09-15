//
//  BoardGenerator.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import Foundation

class GridGenerator {
    static func generate(size: Size, mineCount: Int, startPosition: Position) -> [[Int]]? {
        guard size.x > 0, size.y > 0, mineCount > 0 else {
            return nil
        }
        
        var grid = [[Int]](repeating: [Int](repeating: 0, count: size.x), count: size.y)
        
        //Initialize mines
        for _ in 1...mineCount {
            while true {
                let x = Int.random(in: 0..<size.x)
                let y = Int.random(in: 0..<size.y)
                if x == startPosition.x && y == startPosition.y { continue }
                if grid[y][x] == Constants.mineValue { continue }
                
                grid[y][x] = Constants.mineValue
                break
            }
        }
        
        //Set values
        for x in 0..<size.x {
            for y in 0..<size.y {
                if grid[y][x] != Constants.mineValue {
                    grid[y][x] = PositionValueGenerator.generate(position: Position(x: x, y: y), grid: grid)
                }
            }
        }
        
        return grid
    }
}
