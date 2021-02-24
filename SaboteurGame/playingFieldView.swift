//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import SwiftUI

struct playingFieldView: View {
    let viewModel: PlayingFieldViewModel
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns) {
                ForEach(viewModel.grid, id: \.self) { cell in
                    CellView(cell: cell)
                }
            }.padding(20)
        }
    }

}

struct CellView: View {
    var cell: playingField.Cell
    
    var body: some View{
        ZStack {
//            RoundedRectangle(cornerRadius: 10.0).fill(Color.gray)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 40)
//            Text("⛏").font(.largeTitle)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        playingFieldView(viewModel: PlayingFieldViewModel())
    }
}
