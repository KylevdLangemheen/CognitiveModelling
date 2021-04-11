//
//  opponentView.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 09/04/2021.
//

import SwiftUI

struct opponentInfo: View {
    var viewModel: gameViewController
    var tools: Tools
    var player: Player
    var currentPlayer: Player
    @State var isPlaying: Bool = false
    @State var placeCard: Bool = false
    @State var playToolCard: Bool = false
    @State var skip: Bool = false
    @State var swap: Bool = false
    @State var cardPlay: cardPlay!
    var body: some View {
        
        ZStack{
            
            RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
            RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: 120)
            if currentPlayer.id == player.id {
                RoundedRectangle(cornerRadius: 10.0).stroke(Color.green,lineWidth: 3).frame(height: 120)
                    .onAppear {
                        cardPlay = viewModel.play(player:player)
                        
                            switch cardPlay.playType {
                            case .placeCard: placeCard = true;
                            case .toolModifier: playToolCard = true
                            case .skip: skip = true
                            case .swap: swap = true
                            
                        }
                    }
                if placeCard {
                    Text("Placing card").transition(.opacity).onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                           viewModel.placeCard(cell: cardPlay.cell)
                            placeCard = false
                            viewModel.endTurn()
                            
                        }
                    }
                }

                if playToolCard {
                    Text("Playing tool card").transition(.opacity).onAppear(){
                        viewModel.playActionCard(toPlayer: cardPlay.toPlayer, fromPlayer: player)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){playToolCard = false;viewModel.endTurn()}
                        
                    }
                }
                
                if swap {
                    Text("Swapping card").transition(.opacity).onAppear(){
                        viewModel.skipTurn(player: player)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ swap = false; viewModel.endTurn()}
                        
                    }
                }
                
                if skip {
                    Text("Skipping turn").transition(.opacity).onAppear(){
                        viewModel.swapCard(player: player)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){skip = false;viewModel.endTurn()}
                        
                    }
                }
            }

 
            

            VStack {
                HStack {
                    ForEach(player.hand, id: \.self) { card in
                        Text("\(card.id)" as String)
                    }
                }
                Text("\(player.name)" as String).font(.largeTitle)
                Text("\(player.role)" as String)
                
                
                
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
                }.padding(.leading, 50)
                .padding(.trailing, 50)
            }.onTapGesture {
                if viewModel.playActionCard(toPlayer: player, fromPlayer: currentPlayer) == .succes {
                    viewModel.endTurn()
                }
            }
        }
    }
}
