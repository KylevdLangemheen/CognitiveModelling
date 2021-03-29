//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 17/02/2021.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: PlayingFieldViewModel
    var body: some View {
        VStack {
            HStack{
                ForEach(viewModel.computerPlayers) { player in
                    opponentInfo(viewModel: viewModel, tools: player.tools, player: player, name: player.name).padding(.trailing, 50)
                        .padding(.leading, 50)
                }
            }
            field(viewModel: viewModel, humanPlayer: viewModel.humanPlayer, grid: viewModel.grid)
                .padding(.trailing, 50)
                .padding(.leading, 50)
                
            HStack {
                if viewModel.humanPlayer.playCard != nil {
                    playerHand(viewModel: viewModel, player: viewModel.humanPlayer, playCard: viewModel.humanPlayer.playCard, hand: viewModel.humanHand)
                }else {
                    playerHand(viewModel: viewModel, player: viewModel.humanPlayer, hand: viewModel.humanHand)
                }
                
                playerInfo(player: viewModel.humanPlayer, viewModel: viewModel, deckCount: viewModel.deck.cards.count, role: viewModel.humanPlayer.role)
            }.padding(.trailing, 50)
            .padding(.leading, 50)
            .padding(.bottom, 20)

            
        }.navigationBarHidden(true)
        
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
            }
        }
    }
}

struct playerHand: View {
    var viewModel: PlayingFieldViewModel
    var player: Player
    var playCard: Card!
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
                    if player.playCard != nil && player.playCard.id == card.id{
                        RoundedRectangle(cornerRadius: 10.0).stroke(Color.green,lineWidth: 3).frame(width: cardWidth, height: cardHeight-10)
                        
                    }
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
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        Text("\(deckCount)").font(.title).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    }
                }
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        Text("\(role)" as String).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).font(.title)
                        
                    }.onTapGesture {
                        viewModel.playActionCard(player: player)
                    }
                    ZStack {
                        if deckCount == 0 {
                            RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))).frame(height: infoHeight)
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                            Text("Skip").font(.title)
                        } else {
                            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                            Text("Skip").font(.title)
                            RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))).opacity(0.8).frame(height: infoHeight)
                        }
                        
                    }.onTapGesture {
                        viewModel.skipTurn()
                    }
                    toolView(tools: player.tools)
                }
            }
        }
    }
}


struct toolView: View {
    var tools: Tools
    var body: some View {
        HStack {
            if tools.pickaxe == .intact {
                Image("pickaxe_on")
            } else {
                Image("pickaxe_off")
            }
            
            if tools.mineCart == .intact {
                Image("mineCart_on")
            } else {
                Image("mineCart_off")
            }
            
            if tools.lamp == .intact {
                Image("lamp_on")
            } else {
                Image("lamp_off")
            }
        }
    }
}
struct opponentInfo: View {
    var viewModel: PlayingFieldViewModel
    var tools: Tools
    var player: Player
    var name: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 100)
            VStack {
                Text(name).font(.largeTitle)
                toolView(tools: tools)
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
