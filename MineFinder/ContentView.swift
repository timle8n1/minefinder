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
        LazyHGrid(
            rows: rows,
            alignment: .center,
            spacing: 5) {
            ForEach(0..<9, id: \.self) { x in
                ForEach(0..<9, id: \.self) { y in
                    let display = grid[y][x] == Constants.mineValue ? "*" : "\(grid[y][x])"
                    Text(display)
                        .id("\(x)-\(y)")
                        .frame(width: 30, height: 30)
                }
            }
        }
        Button(
            action: {
                grid = ContentView.generateGrid()
            },
            label: {
                Text("Regenerate")
                    .fontWeight(.bold)
                    .font(.body)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
            }
        )
    }
    
    static private func generateGrid() -> [[Int]] {
        return  GridGenerator.generate(size: Size(x: 9, y: 9), mineCount: 10, startPosition: Position(x: 0, y: 0))!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
