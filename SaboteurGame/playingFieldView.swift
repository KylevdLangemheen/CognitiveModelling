//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import SwiftUI

struct playingFieldView: View {
    let viewModel: PlayingFieldViewModel

    var body: some View {
        
        VStack {
            ForEach(viewModel.grid, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { cell in
                        CellView(cell: cell)
                        
                    }
                }
            }
        }.padding(100)
        
    }

}

struct CellView: View {
    var cell: playingField.Cell
    
    var body: some View{
        ZStack {
            if cell.hasCard {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                Text("⛏").font(.largeTitle)
            } else {
//            RoundedRectangle(cornerRadius: 10.0).fill(Color.gray)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
            }
//            Text("⛏").font(.largeTitle)
        }
    }
}

struct DeckView: View {
    var deck: Deck
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
            Text("⛏").font(.largeTitle)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        playingFieldView(viewModel: PlayingFieldViewModel())
    }
}
