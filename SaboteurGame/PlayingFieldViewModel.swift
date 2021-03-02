//
//  PlayingFieldModel.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 24/02/2021.
//

import SwiftUI

class PlayingFieldViewModel: ObservableObject {
    @Published private var GameModel: Game = Game()

    // MARK: Acces to the model
    var grid: Array<Array<Cell>>{
        GameModel.field.grid
    }
    
    var handSize: Int {
        GameModel.players.handSize
    }
    
    var playDeck: Deck {
        GameModel.deck
    }
    
    var currrentPlayer: Player {
        GameModel.gameStatus.currentPlayer
    }
    
    // MARK: Intent(s)
    
    func changeStatus(player: Player, status: String){
        player.changeStatus(status: status)
    }
    
    func placeCard(card: Card,cell: Cell) {
        objectWillChange.send()
        GameModel.field.placeCard(cell: cell, card: card)
        GameModel.gameStatus.currentPlayer.removeCardFromHand(card: card)
        GameModel.gameStatus.currentPlayer.newCard(card: GameModel.deck.drawCard())
    }
    
    func setCard(card: Card, player: Player) {
        GameModel.gameStatus.currentPlayer.setCard(card: card)
        
    }
    

}
