//
//  CellValueGeneratorTests.swift
//  MineFinderTests
//
//  Created by Tim Lemaster on 9/13/20.
//

import XCTest
@testable import MineFinder

class PositionValueGeneratorTests: XCTestCase {

    func testGenerateValue_CenterSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_CenterSquare_AllMines_returns8() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(8, value)
    }
    
    func testGenerateValue_CenterSquare_CornerMines_returns4() throws {
        let row0 = [mine(), value(0), mine()]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [mine(), value(0), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(4, value)
    }
    
    func testGenerateValue_CenterSquare_SideMines_returns4() throws {
        let row0 = [value(0), mine(), value(0)]
        let row1 = [mine(), value(0), mine()]
        let row2 = [value(0), mine(), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(4, value)
    }
    
    func testGenerateValue_CenterSquare_OneMine_returns1() throws {
        let row0 = [value(0), mine(), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(1, value)
    }
    
    func testGenerateValue_UpperLeftSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_UpperLeftSquare_AllMines_returns3() throws {
        let row0 = [value(0), mine(), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(3, value)
    }
    
    func testGenerateValue_UpperCenterSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_UpperCenterSquare_AllMines_returns5() throws {
        let row0 = [mine(), value(0), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(5, value)
    }
    
    func testGenerateValue_UpperRightSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_UpperRightSquare_AllMines_returns3() throws {
        let row0 = [mine(), mine(), value(0)]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 0)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(3, value)
    }
    
    func testGenerateValue_LeftSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_LeftSquare_AllMines_returns5() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [value(0), mine(), mine()]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(5, value)
    }
    
    func testGenerateValue_RightSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_RightSquare_AllMines_returns5() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [mine(), mine(), value(0)]
        let row2 = [mine(), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 1)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(5, value)
    }
    
    func testGenerateValue_LowerLeftSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_LowerLeftSquare_AllMines_returns3() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [value(0), mine(), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 0, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(3, value)
    }
    
    func testGenerateValue_LowerCenterSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_LowerCenterSquare_AllMines_returns5() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), value(0), mine()]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 1, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(5, value)
    }
    
    func testGenerateValue_LowerRightSquare_NoMines_returns0() throws {
        let row0 = [value(0), value(0), value(0)]
        let row1 = [value(0), value(0), value(0)]
        let row2 = [value(0), value(0), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(0, value)
    }
    
    func testGenerateValue_LowerRightSquare_AllMines_returns3() throws {
        let row0 = [mine(), mine(), mine()]
        let row1 = [mine(), mine(), mine()]
        let row2 = [mine(), mine(), value(0)]
        let grid = [row0, row1, row2]
        
        let position = Position(x: 2, y: 2)
        let value = PositionValueGenerator.generate(position: position, grid: grid)
        XCTAssertEqual(3, value)
    }
    
    private func value(_ nearbyMineCount: Int) -> Cell {
        return Cell(isFlagged: false, isHidden: true, isMine: false, nearbyMineCount: nearbyMineCount)
    }
    
    private func mine() -> Cell {
        return Cell(isFlagged: false, isHidden: true, isMine: true, nearbyMineCount: -1)
    }
}
