//
//  ContentView.swift
//  MineFinder
//
//  Created by Tim Lemaster on 9/13/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: GameView(size: Size(x: 9, y: 9), mineCount: 10)) { Text("Easy") }
                NavigationLink(destination: GameView(size: Size(x: 16, y: 16), mineCount: 40)) { Text("Medium") }
                NavigationLink(destination: GameView(size: Size(x: 30, y: 16), mineCount: 99)) { Text("Expert") }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
