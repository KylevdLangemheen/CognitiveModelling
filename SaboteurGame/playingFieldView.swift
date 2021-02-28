//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import SwiftUI

struct playingFieldView: View {
    @ObservedObject var viewModel: PlayingFieldViewModel
    var body: some View {
        VStack {
            ForEach(viewModel.grid, id: \.self) { row in
                HStack {
                    ForEach(row) { cell in
                        CellView(cell: cell, card: viewModel.getCard(cell: cell)).onTapGesture {
                            if viewModel.currrentPlayer.status == "placingCard" {
                                viewModel.placeCard(cell: cell)
                            }
                        }
                    }
                }
            }
            HStack{
                playerHand(hand: viewModel.currrentPlayer.cards, deck: viewModel.playDeck).onTapGesture {
                    viewModel.changeStatus(status: "placingCard")
                }
                
            }
            
        }.padding(100)
        
    }

}

struct playerHand: View {
    var hand: Array<Int>
    var deck: Array<Game.Card>
    var body: some View{
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                Text(deck[hand[0]].cardConent).font(.largeTitle)
            }
        }
    }
}



struct CellView: View {
    var cell: Game.Cell
    var card: Game.Card
    
    var body: some View{
        ZStack {
            if cell.hasCard {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                if !card.isFaceUp {
                    Text(card.cardConent).font(.largeTitle)
                } else {
                    Text("⛏").font(.largeTitle)
                }
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
            }
//            Text("⛏").font(.largeTitle)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        playingFieldView(viewModel: PlayingFieldViewModel())
    }
}
