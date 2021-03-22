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
            HStack{
                ForEach(viewModel.players) { player in
                    if player.type == .computer {
                        opponentInfo(viewModel: viewModel, player: player).padding(.trailing, 50)
                            .padding(.leading, 50)
                    }

                }

            }

            
            field(viewModel: viewModel, currentPlayer: viewModel.currrentPlayer, grid: viewModel.grid)
            
            HStack{
                playerHand(viewModel: viewModel, currentPlayer: viewModel.currrentPlayer, hand: viewModel.playerHand)
                playerInfo(player: viewModel.currrentPlayer, viewModel: viewModel, deckCount: viewModel.playDeck.cards.count, role: viewModel.playerRole)
            }.padding([.top, .trailing], 50)
            .padding(.leading, 50)
            .padding(.bottom, 20)

            
        }
        
    }

}

 
struct field: View {
    var viewModel: PlayingFieldViewModel
    var currentPlayer: Player
    var grid: Array<Array<Cell>>
    @State private var invalidMove = false
    @State private var computersTurn = false
    
    var body: some View {
        ForEach(grid, id: \.self) { row in
            HStack {
                ForEach(row) { cell in
                    CellView(viewModel: viewModel, cell: cell).onTapGesture {
                        if currentPlayer.type == .human{
                            viewModel.placeCard(card: currentPlayer.playCard ,cell: cell)
                        }
                    }
                }
            }.alert(isPresented: $invalidMove) {
                Alert(title: Text("Invalid Action"), message: Text("You cannot place this card here"), dismissButton: .default(Text("Got it!")))
            }.alert(isPresented: $computersTurn) {
                Alert(title: Text("It is not your turn"), message: Text("Please wait for the other players to finish their turn"), dismissButton: .default(Text("Got it!")))
            }
        }.padding(.trailing, 100)
        .padding(.leading, 100)
    }
}
struct playerHand: View {
    var viewModel: PlayingFieldViewModel
    var currentPlayer: Player
    var hand: Array<Card>
    var body: some View{
        
        HStack{
            ForEach(hand, id: \.self) { card in
                ZStack {
//
                    Image(card.cardContent)
                        .resizable()
                        .blendMode(.multiply)
                        .rotationEffect(.degrees(-90))
                        .aspectRatio(contentMode: .fit)
                }.rotationEffect(.degrees(90))
                .onTapGesture {
                    viewModel.setCard(card: card, player: currentPlayer)
                }
            }      }

    }
}

struct playerInfo: View {
    var player: Player
    var viewModel: PlayingFieldViewModel
    var deckCount: Int
    var role: Role

    var body: some View {
        HStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))).frame(height: 60)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                    if role == .miner {
                        Text("Miner").font(.title).foregroundColor(Color(#colorLiteral(red: 1, green: 0.9634847184, blue: 0.0262479768, alpha: 1)))
                    } else {
                        Text("Saboteur").font(.title).foregroundColor(Color(#colorLiteral(red: 1, green: 0.9634847184, blue: 0.0262479768, alpha: 1)))
                    }
                    
                }.onTapGesture {
                    viewModel.playActionCard(player: player)
                }
                HStack {
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                    RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                }
            }.padding(.leading, 80)

            VStack {

                ZStack{
                    RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))).frame(height: 60)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                    Text("Draw").font(.title).foregroundColor(Color(#colorLiteral(red: 1, green: 0.9634847184, blue: 0.0262479768, alpha: 1)))
                }.onTapGesture {
                    if player.playCard != nil {
                        viewModel.swapCard(card: player.playCard)
                    }
                    
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))).frame(height: 60)
                    RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                    Text("\(deckCount)").font(.title).foregroundColor(Color(#colorLiteral(red: 1, green: 0.9634847184, blue: 0.0262479768, alpha: 1)))
                }
                
            }.padding(.leading, 80)

        }


    }
}

struct opponentInfo: View {
    var viewModel: PlayingFieldViewModel
    var player: Player
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
            HStack {            
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
                RoundedRectangle(cornerRadius: 25.0).stroke(lineWidth: 3).frame(height: 20)
            }.padding(.leading, 650)
            .padding(.trailing, 20)
            Text("Opponent").font(.largeTitle)
        }.onTapGesture {
            viewModel.playActionCard(player: player)
        }
    }
}

struct CellView: View {
    var viewModel: PlayingFieldViewModel
    var cell: Cell
    var body: some View{
        ZStack {
            if cell.hasCard {
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
                if cell.card.isFaceUp {
                    Image(cell.card.cardContent)
                        .resizable()
                        .blendMode(.multiply)
                        .rotationEffect(.degrees(-90))
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("GC_Face_Down")
                        .resizable()
                        .blendMode(.multiply)
                        .rotationEffect(.degrees(-90))
                        .aspectRatio(contentMode: .fit)
                }
                if cell.card.cardType == cardType.start {
                    Image("PC41")
                        .resizable()
                        .blendMode(.multiply)
                        .rotationEffect(.degrees(-90))
                        .aspectRatio(contentMode: .fit)                    
                }
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 60)
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: PlayingFieldViewModel())
    }
}
