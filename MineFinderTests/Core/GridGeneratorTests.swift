//
//  BoardGenerator.swift
//  MineFinderTests
//
//  Created by Tim Lemaster on 9/13/20.
//

import XCTest
@testable import MineFinder

class GridGeneratorTests: XCTestCase {

    func testGenerateBoard_returnsValidBoardSize() throws {
        let size = Size(x: 9, y: 9)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertEqual(size.y, grid!.endIndex)
        for row in grid! {
            XCTAssertEqual(size.x, row.endIndex)
        }
    }
    
    func testGenerateBoard_withInvalidXSize_returnsNil() throws {
        let size = Size(x: 0, y: 9)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertEqual(nil, grid)
    }
    
    func testGenerateBoard_withInvalidYSize_returnsNil() throws {
        let size = Size(x: 9, y: 0)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertEqual(nil, grid)
    }
    
    func testGenerateBoard_withInvalidMineCount_returnsNil() throws {
        let size = Size(x: 9, y: 0)
        let startCell = Position(x: 0, y: 0)
        let grid = GridGenerator.generate(size: size, mineCount: 24, startPosition: startCell)
        
        XCTAssertEqual(nil, grid)
    }
}
