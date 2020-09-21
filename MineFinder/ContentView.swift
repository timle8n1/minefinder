//
//  ContentView.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import SwiftUI

struct ContentView: View {
    private let size = Size(x: 9, y: 9)
    
    @State private var grid = ContentView.generateGrid()
    @State private var clickMode = 0
    @State private var mineCount = 10
    private let clickModes = ["Reveal", "Flag"]
    
    private let rows = [
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5),
        GridItem(.fixed(30), spacing: 5)
    ]
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Mine Count:\(mineCount)")
                
                LazyHGrid(
                    rows: rows,
                    alignment: .center,
                    spacing: 5) {
                    ForEach(0..<9, id: \.self) { x in
                        ForEach(0..<9, id: \.self) { y in
                            let cell = grid[y][x]
                            let display = text(forCell: cell)
                            Button(
                                action: {
                                    select(position: Position(x: x, y: y))
                                },
                                label: {
                                    display
                                        .id("\(x)-\(y)")
                                        .frame(width: 30, height: 30)
                                        .background(Color.white)
                                        .border(Color.black)
                                }
                            ).id("\(x)-\(y)")
                        }
                    }
                }
                    
                Button(
                    action: {
                        grid = ContentView.generateGrid()
                    },
                    label: {
                        Text("Restart")
                            .fontWeight(.bold)
                            .font(.body)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(20.0)
                            .foregroundColor(.white)
                    }
                )
                
                Picker(selection: $clickMode, label: Text("")) {
                    ForEach(0..<clickModes.count) { index in
                        Text(self.clickModes[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
    
    private func text(forCell cell: Cell) -> Text {
        let text: Text
        if cell.isFlagged {
            text = Text("F").foregroundColor(.red)
        } else if cell.isHidden {
            text = Text("").foregroundColor(.white)
        } else if cell.isMine {
            text = Text("*").foregroundColor(.red)
        } else {
            text = Text("\(cell.nearbyMineCount)").foregroundColor(.blue)
        }
        return text
    }
    
    private func select(position: Position) {
        let cell = grid[position.y][position.x]
        
        if clickMode == 0 {
            if !cell.isFlagged {
                grid = GridGenerator.reveal(position: position, grid: grid)
            }
        } else {
            grid = GridGenerator.flag(position: position, grid: grid)
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
    }
    
    static private func generateGrid() -> [[Cell]] {
        return GridGenerator.generate(size: Size(x: 9, y: 9), mineCount: 10, startPosition: Position(x: 0, y: 0))!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
