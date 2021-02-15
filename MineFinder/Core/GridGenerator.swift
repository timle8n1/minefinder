//
//  BoardGenerator.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import Foundation

class GridGenerator {
    static func generate(size: Size, mineCount: Int, startPosition: Position) -> [[Cell]]? {
        guard size.x > 0, size.y > 0, mineCount > 0 else {
            return nil
        }
        
        let cell = Cell(isFlagged: false, isHidden: true, isMine: false, nearbyMineCount: -1)
        var grid = [[Cell]](repeating: [Cell](repeating: cell, count: size.x), count: size.y)
        grid[startPosition.y][startPosition.x] = Cell(isFlagged: false, isHidden: false, isMine: false, nearbyMineCount: -1)
        
        //Initialize mines
        for _ in 1...mineCount {
            while true {
                let x = Int.random(in: 0..<size.x)
                let y = Int.random(in: 0..<size.y)
                if x == startPosition.x && y == startPosition.y { continue }
                if grid[y][x].isMine { continue }
                
                grid[y][x] = Cell(isFlagged: false, isHidden: true, isMine: true, nearbyMineCount: -1)
                break
            }
        }
        
        //Set values
        for x in 0..<size.x {
            for y in 0..<size.y {
                if !grid[y][x].isMine {
                    let nearbyMineCount = PositionValueGenerator.generate(position: Position(x: x, y: y), grid: grid)
                    grid[y][x] = Cell(isFlagged: false, isHidden: true, isMine: false, nearbyMineCount: nearbyMineCount)
                }
            }
        }
        
        return grid
    }
    
    static func flag(position: Position, grid: [[Cell]]) -> [[Cell]] {
        let currentCell = grid[position.y][position.x]
        let updatedCell = Cell.flag(cell: currentCell)
        
        return replace(cell: updatedCell, atPosition: position, onGrid: grid)
    }
    
    static func reveal(position: Position, grid: [[Cell]]) -> [[[Cell]]] {
        let currentCell = grid[position.y][position.x]
        let updatedCell = Cell.reveal(cell: currentCell)
        
        let updatedGrid = replace(cell: updatedCell, atPosition: position, onGrid: grid)
        if !updatedCell.isMine && updatedCell.nearbyMineCount == 0 {
            return revealNeighbors(position: position, grid: updatedGrid)
        } else {
            return [updatedGrid]
        }
    }
    
    private static func revealNeighbors(position: Position, grid: [[Cell]]) -> [[[Cell]]] {
        let minX = position.x > 0 ? position.x - 1 : 0
        let maxX = position.x < grid[0].endIndex - 1 ? position.x + 1 : position.x
        let minY = position.y > 0 ? position.y - 1 : 0
        let maxY = position.y < grid.endIndex - 1 ? position.y + 1 : position.y
        
        var updatedGrids = [grid]
        for x in minX...maxX {
            for y in minY...maxY {
                if x == position.x && y == position.y { continue }
                let neighbor = grid[y][x]
                if neighbor.isHidden {
                    let updatedCell = Cell.reveal(cell: neighbor)
                    let neighborPosition = Position(x: x, y: y)
                    updatedGrids.append(replace(cell: updatedCell, atPosition: neighborPosition, onGrid: updatedGrids.last!))
                    if updatedCell.nearbyMineCount == 0 {
                        updatedGrids.append(contentsOf: revealNeighbors(position: neighborPosition, grid: updatedGrids.last!))
                    }
                }
            }
        }
        
        return updatedGrids
    }
    
    private static func replace(cell: Cell, atPosition: Position, onGrid: [[Cell]]) -> [[Cell]] {
        let size = Size(x: onGrid[0].endIndex, y: onGrid.endIndex)
        let initialCell = Cell(isFlagged: false, isHidden: true, isMine: false, nearbyMineCount: -1)
        var grid = [[Cell]](repeating: [Cell](repeating: initialCell, count: size.x), count: size.y)
        
        for x in 0..<size.x {
            for y in 0..<size.y {
                if x == atPosition.x && y == atPosition.y {
                    grid[y][x] = cell
                } else {
                    grid[y][x] = onGrid[y][x]
                }
            }
        }
        
        return grid
    }
}
