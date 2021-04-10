//
//  ContentView.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 17/02/2021.
//

import SwiftUI
import PopupView

struct gameView: View {
    @ObservedObject var viewModel: gameViewController
    @State private var isInvalidPlay: Bool = false //
    @State var invalidMoveText = "This is an invalid move"
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    ForEach(viewModel.computerPlayers) { player in
                        opponentInfo(viewModel: viewModel, tools: player.tools, player: player, currentPlayer: viewModel.currentPlayer).padding(.trailing, 50)
                            .padding(.leading, 50)


                    }
                }
                // Display the field
                field(viewModel: viewModel, grid: viewModel.grid, selectedCard: viewModel.selectedCard)
                
                // Display the card and information for the human player
                HStack {
                    playerHand(viewModel: viewModel, player: viewModel.humanPlayer, selectedCard: viewModel.selectedCard)
                    playerInfo(player: viewModel.humanPlayer, viewModel: viewModel, deckCount: viewModel.deck.cards.count, role: viewModel.humanPlayer.role)
                }.padding(.trailing, 50)
                .padding(.leading, 50)
                .padding(.bottom, 20)
            }
            
            // End game
            if viewModel.gameStatus != .playing {
                endGameView(viewModel: viewModel, gameStatus: viewModel.gameStatus, player: viewModel.currentPlayer)
            }
            
        }.navigationBarHidden(true)
        .popup(isPresented: $isInvalidPlay, type: .default , animation: .easeInOut, autohideIn: nil, closeOnTap: true, closeOnTapOutside: true, view: {
            Toast(commonTextElement: $invalidMoveText)
        })

    }

}






struct endGameView: View {
    var viewModel: gameViewController
    var gameStatus: gameStatus
    var player: Player
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0).stroke(Color.black, lineWidth: 3).frame(width: 500, height: 250)
            RoundedRectangle(cornerRadius: 10.0).fill(
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            ).frame(width: 500, height: 250)
            VStack{
                
                switch gameStatus {
                case .minersWin : Text("Miners win!").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).multilineTextAlignment(.center)
                case .saboteursWin: Text("Saboteur Wins!").font(.largeTitle).font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).multilineTextAlignment(.center)
                case .playing:
                    Text("The game finished but nobody won!?")
                }
                
                
                Button(action: {

                    viewModel.resetGame()
                }) {
                    HStack {
                        Text("Play again!").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).multilineTextAlignment(.center)
                    }
                    .frame(minWidth: 0, maxWidth: 240.0)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4494178891, green: 0.3634631038, blue: 0.003429454286, alpha: 1)), Color(#colorLiteral(red: 0.979470551, green: 0.9008276463, blue: 0.006413663272, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                    )
                    .cornerRadius(40)
                }.padding(.top, 50)
                    
                    
                
            }
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        gameView(viewModel: gameViewController())
    }
}
