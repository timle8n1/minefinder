//
//  BoardGenerator.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import Foundation

class GridGenerator {
    static func generateBoard(size: Size, mineCount: Int, startCell: Cell) -> [[Int]]? {
        guard size.x > 0, size.y > 0, mineCount > 0 else {
            return nil
        }
        
        var board = [[Int]](repeating: [Int](repeating: 0, count: size.x), count: size.y)
        
        //Initialize mines
        for _ in 1...mineCount {
            while true {
                let x = Int.random(in: 0..<size.x)
                let y = Int.random(in: 0..<size.y)
                if x == startCell.x && y == startCell.y { continue }
                
                board[y][x] = Constants.mineValue
                break
            }
        }
        
        //Set values
        for x in 0..<size.x {
            for y in 0..<size.y {
                if board[y][x] != Constants.mineValue {
                    board[y][x] = calculateCellValue(cell: Cell(x: x, y: y), board: board)
                }
            }
        }
        
        return board
    }
    
    static private func calculateCellValue(cell: Cell, board: [[Int]]) -> Int {
        let minX = cell.x > 0 ? cell.x - 1 : 0
        let maxX = cell.x < board[0].endIndex - 1 ? cell.x + 1 : cell.x
        let minY = cell.y > 0 ? cell.y - 1 : 0
        let maxY = cell.y < board.endIndex - 1 ? cell.y + 1 : cell.y
        
        var count = 0
        for x in minX...maxX {
            for y in minY...maxY {
                let neighbor = board[y][x]
                if neighbor == Constants.mineValue {
                    count += 1
                }
            }
        }
        return count
    }
}
