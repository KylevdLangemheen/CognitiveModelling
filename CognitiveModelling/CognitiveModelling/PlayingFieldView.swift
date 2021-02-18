//
//  ContentView.swift
//  CognitiveModelling
//
//  Created by H.B.R. van de Langemheen on 18/02/2021.
//

import SwiftUI

struct PlayingFieldView: View {
    let data = Array(1...45).map { "item \($0)" }
    
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    VStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(height: 40)
                    }
                }
            }.padding(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        playingFieldView()
    }
}
