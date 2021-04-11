//
//  playerView.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 09/04/2021.
//

import SwiftUI

struct playerHand: View {
    var viewModel: gameViewController
    var player: Player
    var selectedCard: Card!

    
    var body: some View{
        let cardWidth: CGFloat = 82.0
        let cardHeight: CGFloat = 126.0
        HStack{
            ForEach(player.hand, id: \.self) { card in
                ZStack {
                    if selectedCard.id == card.id {
                        RoundedRectangle(cornerRadius: 10.0).stroke(Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)), lineWidth: 3).frame(width: cardWidth, height: cardHeight)
                    }
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.white).frame(width: cardWidth, height: cardHeight)
                    Image(card.cardImage)
                        .resizable()
                        .blendMode(.multiply)
                        .aspectRatio(contentMode: .fit)
                }
                
                .onTapGesture {
                    viewModel.setSelectedCard(card: card)
                }
            }
        }

    }
}


struct playerInfo: View {
    var player: Player
    var viewModel: gameViewController
    var deckCount: Int
    var role: Role
    
    @State private var isInvalidPlay: Bool = false //
    @State var invalidMoveText = "This is an invalid move"
    
    @State var swap = false
    @State var playtoolCard = false
    @State var skip = false
    
    var body: some View {
        let infoHeight: CGFloat = 40
        VStack {
            HStack {
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10.0).fill(Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))).frame(height: infoHeight)
                        RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3).frame(height: infoHeight)
                        Text("Swap").font(.title).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    }.onTapGesture {

                        let error = viewModel.swapCard(player: player)
                        if  error == .succes {
                            viewModel.endTurn()
                        } else {
                            invalidMoveText = error.rawValue
                            isInvalidPlay = true
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

                        let error = viewModel.playActionCard(toPlayer: player, fromPlayer: player)
                        if  error == .succes {
                            viewModel.endTurn()
                        } else {
                            invalidMoveText = error.rawValue
                            isInvalidPlay = true
                        }
                        
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
                        let error = viewModel.skipTurn(player: player)
                        if error != .succes {
                            invalidMoveText = error.rawValue
                            isInvalidPlay = true
                        }
                        
                    }



                }
            }
            toolView(tools: player.tools)
        }.alert(isPresented: $isInvalidPlay){
            Alert(title: Text(invalidMoveText))
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

struct Toast: View {
    @Binding var commonTextElement: String
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 10.0).stroke(Color.black, lineWidth: 3).frame(width: 500, height: 250)
                RoundedRectangle(cornerRadius: 10.0).fill(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                ).frame(width:500, height: 250)
                HStack {
                    VStack {
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(Color.white)
                            .padding()
                        Text(commonTextElement)
                            .foregroundColor(.white).font(.largeTitle)
                        Button(action: {
                                
                        }) {
                                HStack {
                                    Text("Got it!").font(.title).fontWeight(.bold).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).multilineTextAlignment(.center)
                                }
                                .frame(minWidth: 0, maxWidth: 240.0)
                                .padding()
                                .foregroundColor(.white)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4494178891, green: 0.3634631038, blue: 0.003429454286, alpha: 1)), Color(#colorLiteral(red: 0.979470551, green: 0.9008276463, blue: 0.006413663272, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                                )
                                .cornerRadius(40)
                        }.padding(.top)
                    }
                }
                .padding()
        }
        .cornerRadius(12)
        .padding()
        
    }
}
