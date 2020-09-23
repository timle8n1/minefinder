//
//  ContentView.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import SwiftUI

enum GameState: String {
    case notStarted = "Waiting for first Move"
    case inProgress = "Make a Move"
    case lost = "Sorry, you lost!"
    case won = "Congrats, you won!"
}

enum ClickModes: String, CaseIterable, Hashable, Identifiable  {
    case reveal = "Reveal"
    case flag = "Flag"
    
    var id: ClickModes {self}
}

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    private let size = Size(x: 9, y: 9)
    
    @State private var grid = ContentView.generateGrid(startPosition: Position(x: 0, y: 0))
    @State private var clickMode = ClickModes.reveal
    @State private var mineCount = 10
    @State private var gameState = GameState.notStarted
    
    private let rows = [
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0),
        GridItem(.fixed(30), spacing: 0)
    ]
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            
            if verticalSizeClass == .compact {
                HStack {
                    restartButton
                    VStack {
                        gameInfo
                        gameGrid
                        clickModeSelector
                    }
                }
            } else {
                VStack {
                    gameInfo
                    clickModeSelector
                    gameGrid
                    restartButton
                }
            }
        }
    }
    
    var restartButton: some View {
        Button(
            action: {
                grid = ContentView.generateGrid(startPosition: Position(x: 0, y: 0))
                mineCount = 10
                gameState = .notStarted
            },
            label: {
                Text("Restart")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .foregroundColor(.black)
            }
        )
    }
    
    var gameInfo: some View {
        HStack {
            Text(gameState.rawValue)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(mineCount) :Mine Count")
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var gameGrid: some View {
        LazyHGrid(
            rows: rows,
            alignment: .center,
            spacing: 0) {
            ForEach(0..<9, id: \.self) { x in
                ForEach(0..<9, id: \.self) { y in
                    button(atPosition: Position(x: x, y: y)).id("\(x)-\(y)")
                }
            }
        }
    }
    
    var clickModeSelector: some View {
        Picker(selection: $clickMode, label: Text("")) {
            ForEach(ClickModes.allCases) { value in
                Text(value.rawValue).tag(value)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding([.leading, .trailing])
    }
    
    private func button(atPosition position: Position) -> some View {
        let cell = grid[position.y][position.x]
        let display = text(forCell: cell)
                        .id("\(position.x)-\(position.y)")
                        .frame(width: 30, height: 30)
                        .background(background(forCell: cell))
                        .border(Color.black)
            .onTapGesture(count: 1) {
                revealCell(position: position)
            }
            .onLongPressGesture {
                flagCell(position: position)
            }
        
        return display
    }
    
    private func background(forCell cell: Cell) -> some View {
        if cell.isHidden {
            return Color.gray
        }
        
        if cell.isMine {
            return Color.red
        }
        
        return Color.white
    }
    
    private func text(forCell cell: Cell) -> Text {
        let text: Text
        if cell.isFlagged {
            text = Text("⚠️").foregroundColor(.red)
        } else if cell.isHidden {
            text = Text(" ").foregroundColor(.white)
        } else if cell.isMine {
            text = Text("💣")
        } else {
            text = Text(cell.nearbyMineCount > 0 ? "\(cell.nearbyMineCount)" : " ").foregroundColor(.blue)
        }
        return text.fontWeight(.bold)
    }
    
    private func select(position: Position) {
        switch clickMode {
        case .reveal:
            revealCell(position: position)
        case .flag:
            flagCell(position: position)
        }
    }
    
    private func checkIfWonGame() {
        let unresolvedCells = grid.joined().reduce(0) { (result, cell) -> Int in
            if !cell.isMine && cell.isHidden {
                return result + 1
            }
            return result
        }
        
        if unresolvedCells == 0 {
            winGame()
        }
    }
    
    private func flagCell(position: Position) {
        guard gameState == .inProgress else { return }
        
        let cell = grid[position.y][position.x]
        if cell.isHidden {
            if cell.isFlagged || mineCount > 0 {
                grid = GridGenerator.flag(position: position, grid: grid)
                updateMineCount()
            }
        }
    }
    
    private func loseGame() {
        gameState = .lost
    }
    
    private func revealCell(position: Position) {
        if gameState == .won || gameState == .lost {
            return
        }
        
        if gameState == .notStarted {
            gameState = .inProgress
            grid = GridGenerator.generate(size: size, mineCount: 10, startPosition: position)!
        }
        
        let cell = grid[position.y][position.x]
        if !cell.isFlagged && cell.isHidden {
            grid = GridGenerator.reveal(position: position, grid: grid)
            let revealedCell = grid[position.y][position.x]
            if revealedCell.isMine {
                loseGame()
            } else {
                checkIfWonGame()
            }
        }
    }
    
    private func updateMineCount() {
        let cells = grid.flatMap { $0 }
        let flagCount = cells.reduce(0) { (result, cell) -> Int in
            if cell.isFlagged {
                return result + 1
            } else {
                return result
            }
        }
        mineCount = 10 - flagCount
    }
    
    private func winGame() {
        gameState = .won
    }
    
    static private func generateGrid(startPosition: Position) -> [[Cell]] {
        return GridGenerator.generate(size: Size(x: 9, y: 9), mineCount: 10, startPosition: startPosition)!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
