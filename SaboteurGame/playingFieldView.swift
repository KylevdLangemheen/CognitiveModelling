//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import SwiftUI

struct playingFieldView: View {
    let data = Array(repeating: Array(repeating: 0, count: 5), count: 9)
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(self.data, id: \.self) { column in
                    HStack {
                        ForEach(column, id: \.self) { card in
                            fieldCardView()
                        }
                    }
                }
            }.padding(20)
        }
    }
}

struct fieldCardView: View {

    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10.0).fill(Color.gray)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
            Text("⛏").font(.largeTitle)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        playingFieldView()
    }
}
