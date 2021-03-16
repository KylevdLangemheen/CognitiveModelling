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
    
    func changePlayerStatus(player: Player, status: playerStatus){
        objectWillChange.send()
        player.changePlayerStatus(status: status)
    }
    
    func placeCard(card: Card,cell: Cell) {
        objectWillChange.send()
        return GameModel.placeCard(card: card,cell: cell)
    }
    
    func playActionCard(){
        return GameModel.playActionCard()
    }
    func setCard(card: Card, player: Player) {
        objectWillChange.send()
        GameModel.gameStatus.currentPlayer.setCard(card: card)
        
    }
    

}
