//
//  GameView.swift
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

struct GameView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    let size: Size
    let mineCount: Int
    private let rows: [GridItem]
    
    @State private var grid: [[Cell]]
    @State private var remainingMineCount: Int
    @State private var clickMode = ClickModes.reveal
    @State private var gameState = GameState.notStarted
    
    
    init(size: Size, mineCount: Int) {
        self.size = size
        self.mineCount = mineCount
        
        self.rows = [GridItem](repeating: GridItem(.fixed(30), spacing: 0), count: size.y)
        _remainingMineCount = State(initialValue: mineCount)
        _grid = State(initialValue: GridGenerator.generate(size: size, mineCount: mineCount, startPosition: Position(x: 0, y: 0))!)
    }
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            
            if verticalSizeClass == .compact {
                HStack {
                    restartButton
                    VStack {
                        gameInfo
                        ScrollView([.horizontal, .vertical]) {
                            gameGrid.padding([.horizontal, .vertical])
                        }
                        //clickModeSelector
                    }
                }
            } else {
                VStack {
                    gameInfo
                    //clickModeSelector
                    ScrollView([.horizontal, .vertical]) {
                        gameGrid.padding([.horizontal, .vertical])
                    }
                    restartButton
                }
            }
        }
    }
    
    var restartButton: some View {
        Button(
            action: {
                restart()
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
            Text("\(remainingMineCount) :Mine Count")
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var gameGrid: some View {
        LazyHGrid(
            rows: rows,
            alignment: .center,
            spacing: 0) {
            ForEach(0..<size.x, id: \.self) { x in
                ForEach(0..<size.y, id: \.self) { y in
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
    
    private func restart() {
        grid = GridGenerator.generate(size: size, mineCount: mineCount, startPosition: Position(x: 0, y: 0 ))!
        remainingMineCount = mineCount
        gameState = .notStarted
    }
    
    private func button(atPosition position: Position) -> some View {
        let cell = grid[position.y][position.x]
    
        let display = text(forCell: cell)
                        .id("\(position.x)-\(position.y)")
                        .frame(width: 30, height: 30)
                        .background(background(forCell: cell))
                        .border(Color.black)
        
        let stack = ZStack {
            display
            if cell.isHidden {
                Text(cell.isFlagged ? "⚠️" : " ")
                    .id("\(position.x)-\(position.y)")
                    .frame(width: 30, height: 30)
                    .background(Color.gray)
                    .border(Color.black)
                    .onTapGesture(count: 2) {
                        revealCell(position: position)
                    }
                    .onTapGesture(count: 1) {
                        flagCell(position: position)
                    }
            }
        }
        
        return stack
    }
    
    private func background(forCell cell: Cell) -> some View {
        if cell.isMine {
            return Color.red
        }
        
        return Color.white
    }
    
    private func text(forCell cell: Cell) -> Text {
        let text: Text
        if cell.isMine {
            text = Text("💣")
        } else {
            text = Text(cell.nearbyMineCount > 0 ? "\(cell.nearbyMineCount)" : " ").foregroundColor(.blue)
        }
        return text.fontWeight(.bold)
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
            if cell.isFlagged || remainingMineCount > 0 {
                grid = GridGenerator.flag(position: position, grid: grid)
                updateMineCount()
            }
        }
    }
    
    private func loseGame() {
        gameState = .lost
    }
    
    private func selectCell(position: Position) {
        switch clickMode {
        case .reveal:
            revealCell(position: position)
        case .flag:
            flagCell(position: position)
        }
    }
    
    private func revealCell(position: Position) {
        if gameState == .won || gameState == .lost {
            return
        }
        
        if gameState == .notStarted {
            gameState = .inProgress
            grid = GridGenerator.generate(size: size, mineCount: mineCount, startPosition: position)!
        }
        
        let cell = grid[position.y][position.x]
        if !cell.isFlagged && cell.isHidden {
            let grids = GridGenerator.reveal(position: position, grid: grid)
            for agrid in grids {
                grid = agrid
            }
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
        remainingMineCount = mineCount - flagCount
    }
    
    private func winGame() {
        gameState = .won
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(size: Size(x: 9, y: 9), mineCount: 10)
    }
}
