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
                ForEach(viewModel.computerPlayers) { player in
                    opponentInfo(viewModel: viewModel, playerId: player.id ).padding(.trailing, 50)
                        .padding(.leading, 50)
                }
            }
            field(viewModel: viewModel, humanPlayer: viewModel.humanPlayer, grid: viewModel.grid)
            HStack{
                playerHand(viewModel: viewModel, player: viewModel.humanPlayer, hand: viewModel.humanHand)
                playerInfo(player: viewModel.humanPlayer, viewModel: viewModel, deckCount: viewModel.deck.cards.count, role: viewModel.humanPlayer.role)
            }.padding(.trailing, 50)
            .padding(.leading, 50)
            .padding(.bottom, 20)

            
        }
        
    }

}

 
struct field: View {
    var viewModel: PlayingFieldViewModel
    var humanPlayer: Player
    var grid: Array<Array<Cell>>
    @State private var invalidMove = false
    @State private var computersTurn = false
    
    var body: some View {
        
        ForEach(grid, id: \.self) { row in
            HStack{
                ForEach(row) { cell in
                    CellView(cell: cell).onTapGesture {
                        if humanPlayer.playerStatus == .usingPathCard{
                            viewModel.placeCard(card: humanPlayer.playCard ,cell: cell)
                        }
                    }.padding(0)
                }
            }.alert(isPresented: $invalidMove) {
                Alert(title: Text("Invalid Action"), message: Text("You cannot place this card here"), dismissButton: .default(Text("Got it!")))
            }.alert(isPresented: $computersTurn) {
                Alert(title: Text("It is not your turn"), message: Text("Please wait for the other players to finish their turn"), dismissButton: .default(Text("Got it!")))
            }
        }
        .padding(.trailing, 20)
        .padding(.leading, 20)
    }
}
struct playerHand: View {
    var viewModel: PlayingFieldViewModel
    var player: Player
    var hand: Array<Card>
    var body: some View{
        let cardWidth: CGFloat = 82.0
        let cardHeight: CGFloat = 126.0
        HStack{
            ForEach(hand, id: \.self) { card in
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white).frame(width: cardWidth, height: cardHeight)
                    Image(card.cardContent)
                        .resizable()
                        .blendMode(.multiply)
                        .aspectRatio(contentMode: .fit)
                }
                .onTapGesture {
                    viewModel.setCard(card: card, player: player)
                }
            }
        }

    }
}

struct playerInfo: View {
    var player: Player
    var viewModel: PlayingFieldViewModel
    var deckCount: Int
    var role: Role

    var body: some View {
        let infoHeight: CGFloat = 40
        VStack {
            HStack {
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        if role == .miner {
                            Text("Miner").foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).font(.title)
                        } else {
                            Text("Saboteur").foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).font(.title)
                        }
                        
                    }.onTapGesture {
                        viewModel.playActionCard(player: player)
                    }
                    ZStack {
                        if deckCount == 0 {
                            RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))).frame(height: infoHeight)
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                            Text("Skip").font(.title)
                        } else {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                            Text("Skip").font(.title)
                            RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))).opacity(0.8).frame(height: infoHeight)
                        }
                        
                    }
                }

                VStack {

                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        Text("Switch").font(.title).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    }.onTapGesture {
                        if player.playCard != nil {
                            viewModel.swapCard(card: player.playCard)
                        }
                        
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        Text("\(deckCount)").font(.title).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    }
                }
            }
            HStack {
                if player.tools.pickaxe == .intact {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                } else {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                }
                
                if player.tools.mineCart == .intact {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                } else {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                }
                
                if player.tools.lamp == .intact {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                } else {
                    RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                }
            }
        }
    }
}

struct opponentInfo: View {
    var viewModel: PlayingFieldViewModel
    var playerId: Int
    var body: some View {
        let player = viewModel.getComputerPlayerById(id: playerId)
        ZStack{
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
            VStack {
                HStack {
                    if player.tools.pickaxe == .intact {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                    } else {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                    }
                    
                    if player.tools.mineCart == .intact {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                    } else {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                    }
                    
                    if player.tools.lamp == .intact {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.green).frame(height: 20)
                    } else {
                        RoundedRectangle(cornerRadius: 25.0).fill(Color.red).frame(height: 20)
                    }
                    
                }.padding(.leading, 50)
                .padding(.trailing, 50)
                HStack {
                    Text("\(player.type)" as String).font(.largeTitle)
                }
            }
        }.onTapGesture {
            viewModel.playActionCard(player: player)
        }
    }
}


struct CellView: View {
    var cell: Cell
    var body: some View{
        let cardWidth: CGFloat = 60.0
        let cardHeight: CGFloat = 93.0
        ZStack {
            if cell.hasCard {
                if cell.card.isFaceUp {
                        Image(cell.card.cardContent)
                            .resizable()
                            .blendMode(.multiply)
                            .aspectRatio(contentMode: .fit)
                } else {
                    Image("GC_Face_Down")
                        .resizable()
                        .blendMode(.multiply)
                        .aspectRatio(contentMode: .fit)
                }
            } else {
                RoundedRectangle(cornerRadius: 2).fill(Color.white)
                RoundedRectangle(cornerRadius: 2.0).strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4])).frame(width: cardWidth, height: cardHeight)
            }
        }.padding(0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: PlayingFieldViewModel())
    }
}
