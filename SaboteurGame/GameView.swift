//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: PlayingFieldViewModel
    
    
    var body: some View {
        



        VStack {

        
            opponentInfo().padding(.trailing, 50)
                .padding(.leading, 50)

            field(grid: viewModel.grid, viewModel: viewModel)
            HStack{
                ForEach(viewModel.currrentPlayer.hand, id: \.self) { card in
                    if card.cardType == "path" {
                        playerHand(card: card,deck: viewModel.playDeck.cards).onTapGesture {
                            viewModel.changeStatus(player: viewModel.currrentPlayer, status: "placingCard")
                            viewModel.setCard(card: card, player: viewModel.currrentPlayer)
                        }
                    }
                }
                playerInfo(deckCount: viewModel.playDeck.cards.count)
            }.padding(.trailing, 50)
            .padding(.leading, 50)
            .padding(.bottom, 20)
            
        }
        
    }

}

struct field: View {
    var grid: Array<Array<Cell>>
    var viewModel: PlayingFieldViewModel
    @State private var invalidMove = false
    
    var body: some View {
        ForEach(grid, id: \.self) { row in
            HStack {
                ForEach(row) { cell in
                    CellView(cell: cell).onTapGesture {
                        if !viewModel.placeCard(card: viewModel.currrentPlayer.playCard ,cell: cell) {
                            self.invalidMove = true
                        }
                    }
                }
            }.alert(isPresented: $invalidMove) {
                Alert(title: Text("Invalid Action"), message: Text("You cannot place this card here"), dismissButton: .default(Text("Got it!")))
            }
        }.padding(.trailing, 100)
        .padding(.leading, 100)
    }
}
struct playerHand: View {
    var card: Card
    var deck: Array<Card>
    var body: some View{
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                Text(card.cardConent).font(.title)
            }
        }
    }
}

struct playerInfo: View {
    var deckCount: Int
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 100)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
                    Text("Role").font(.title)
                }
                HStack {
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                }
            }

            VStack {

                ZStack{
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                    Text("Switch").font(.title)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                    Text("\(deckCount)").font(.title)
                }
            }

        }


    }
}

struct opponentInfo: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
            HStack {
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
            }.padding(.leading, 500)
            .padding(.trailing, 50)
            Text("Opponent").font(.largeTitle)
        }
    }
}

struct CellView: View {
    var cell: Cell
    var body: some View{
        ZStack {
            if cell.hasCard {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.gray).frame(height: 60)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                if !cell.card.isFaceUp {
                    Text(verbatim: cell.card.cardConent).font(.largeTitle)
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
        GameView(viewModel: PlayingFieldViewModel())
    }
}
