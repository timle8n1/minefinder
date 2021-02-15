//
//  BoardGenerator.swift
//  MineFinderTests
//
//  Created by Tim Lemaster on 9/13/20.
//

import XCTest
@testable import MineFinder

class GridGeneratorTests: XCTestCase {

    func testGenerate_returnsValidBoardSize() throws {
        let size = Size(x: 9, y: 9)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertEqual(size.y, grid!.endIndex)
        for row in grid! {
            XCTAssertEqual(size.x, row.endIndex)
        }
    }
    
    func testGenerate_withInvalidXSize_returnsNil() throws {
        let size = Size(x: 0, y: 9)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertNil(grid)
    }
    
    func testGenerate_withInvalidYSize_returnsNil() throws {
        let size = Size(x: 9, y: 0)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertNil(grid)
    }
    
    func testGenerate_withInvalidMineCount_returnsNil() throws {
        let size = Size(x: 9, y: 0)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertNil(grid)
    }
    
    func testFlag_withUnflaggedCell_returnsAFlaggedCell() throws {
        let row0 = [flagged(false), flagged(false), flagged(false)]
        let row1 = [flagged(false), flagged(false), flagged(false)]
        let row2 = [flagged(false), flagged(false), flagged(false)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let updatedGrid = GridGenerator.flag(position: position, grid: grid)
        
        for x in 0..<3 {
            for y in 0..<3 {
                if x == 1 && y == 1 {
                    XCTAssertTrue(updatedGrid[y][x].isFlagged)
                } else {
                    XCTAssertFalse(updatedGrid[y][x].isFlagged)
                }
            }
        }
    }
    
    func testFlag_withFlaggedCell_returnsAnUnflaggedCell() throws {
        let row0 = [flagged(true), flagged(true), flagged(true)]
        let row1 = [flagged(true), flagged(true), flagged(true)]
        let row2 = [flagged(true), flagged(true), flagged(true)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let updatedGrid = GridGenerator.flag(position: position, grid: grid)
        
        XCTAssertEqual(0, updatedGrid.startIndex)
        XCTAssertEqual(0, updatedGrid[0].startIndex)
        XCTAssertEqual(3, updatedGrid.endIndex)
        XCTAssertEqual(3, updatedGrid[0].endIndex)
        
        for x in 0..<3 {
            for y in 0..<3 {
                if x == 1 && y == 1 {
                    XCTAssertFalse(updatedGrid[y][x].isFlagged)
                } else {
                    XCTAssertTrue(updatedGrid[y][x].isFlagged)
                }
            }
        }
    }
    
    func testReveal_withHiddenCell_returnsARevealedCell() throws {
        let row0 = [hidden(true), hidden(true), hidden(true)]
        let row1 = [hidden(true), hidden(true), hidden(true)]
        let row2 = [hidden(true), hidden(true), hidden(true)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let updatedGrid = GridGenerator.reveal(position: position, grid: grid)
        
        XCTAssertEqual(0, updatedGrid.last!.startIndex)
        XCTAssertEqual(0, updatedGrid.last![0].startIndex)
        XCTAssertEqual(3, updatedGrid.last!.endIndex)
        XCTAssertEqual(3, updatedGrid.last![0].endIndex)
        
        for x in 0..<3 {
            for y in 0..<3 {
                if x == 1 && y == 1 {
                    XCTAssertFalse(updatedGrid.last![y][x].isHidden)
                } else {
                    XCTAssertTrue(updatedGrid.last![y][x].isHidden)
                }
            }
        }
    }
    
    private func flagged(_ flagged: Bool) -> Cell {
        return Cell(isFlagged: flagged, isHidden: true, isMine: true, nearbyMineCount: -1)
    }
    
    private func hidden(_ hidden: Bool) -> Cell {
        return Cell(isFlagged: true, isHidden: hidden, isMine: true, nearbyMineCount: -1)
    }
}
