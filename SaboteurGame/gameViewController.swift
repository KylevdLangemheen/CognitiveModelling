//
//  PlayingFieldModel.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 24/02/2021.
//

import SwiftUI

class gameViewController: ObservableObject {
    
    @Published private var GameModel: gameModel = gameModel()

    @Published var selectedCard = Card(cardType: .empty)
    
    func setSelectedCard(card: Card){
        selectedCard = card
//        print("Set selected Card \(card.cardType)")
    }
    // MARK: Acces to the model
    var grid: Array<Array<Cell>>{
        GameModel.field.grid
    }
    
    var field: Field {
        GameModel.field
    }
    
    var deck: Deck {
        GameModel.deck
    }
    
    var humanPlayer: Player {
        GameModel.human
    }
    
    var currentPlayer: Player {
        
        GameModel.currentPlayer
    }
    
    var computerPlayers: Array<Player> {
        GameModel.computers
    }

    var gameStatus: gameStatus {
        return GameModel.gameStatus
    }
   
//    var playCard: Card {
//        GameModel.human.playCard
//    }
    // MARK: Intent(s)

//    func getComputerPlayerById(id: Int) -> Player {
//
//        return GameModel.getComputerPlayerById(id:id)
//    }
//
    
    func resetGame() {
        GameModel = gameModel()
    }
    func placeCard(cell: Cell) -> placeError{
        print("\(currentPlayer.name) is placing a card")
        if (selectedCard.cardType == .empty){return .invalidStatus}
        let coopValue = GameModel.field.getCoopValue(card: selectedCard, cell: cell)
        let error = GameModel.currentPlayer.placeCard(card: selectedCard, cell: cell)
        
        if  error == .succes {
            let play = cardPlay(playType: .placeCard, card: selectedCard, fromPlayer: currentPlayer, coopValue: coopValue)
            setSelectedCard(card: Card(cardType: .empty))
            GameModel.updateModels(play: play)
            return error
        } else {
            return error
        }
     }

    func endTurn() {
        GameModel.endTurn()
    }
    
    func play(player: Player) -> cardPlay{
        let cardPlay = player.play()
        
        
        if cardPlay.playType == .skip {
            skipTurn(player: player)
        } else{
            setSelectedCard(card: cardPlay.card)
        }
        return cardPlay
    }
    
    func playActionCard(toPlayer: Player, fromPlayer: Player) -> toolPlayError{
        print("\(fromPlayer.name) is playing a tool modifier againts \(toPlayer.name)")
        if currentPlayer.id != fromPlayer.id {return .notTurn}
        if selectedCard.cardType == .empty {return .invalidStatus}
        if selectedCard.cardType != .tool {return .invalidStatus}
        let play = cardPlay(playType: .toolModifier, card: selectedCard, toPlayer: toPlayer, fromPlayer: fromPlayer)
        let error = fromPlayer.playToolCard(play: play)
        if  error == .succes {
            setSelectedCard(card: Card(cardType: .empty))
            GameModel.updateModels(play: play)
            return error
        } else {
            print("action card is not played, something went wrong")
            return error
        }
    }
    
    func swapCard(player: Player) -> swapPlayError {
        print("\(player.name) is swapping a card")
        if currentPlayer.id != player.id {
            return .notTurn
        }
        if selectedCard.cardType == .empty {return .noCard}
        let error = player.swapCard(card: selectedCard)
        setSelectedCard(card: Card(cardType: .empty))
        return error
    }
    
    func skipTurn(player: Player) -> skipPlayError{
        print("\(player.name) is skipping a turn")
        if player.id != currentPlayer.id {
            return .notTurn
        } else {
            player.skipTurn()
            return .succes
        }
        
    }


}
