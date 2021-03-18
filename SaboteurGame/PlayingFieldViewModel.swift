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
    
    var players: Array<Player> {
        GameModel.players.players
    }
    
    var handSize: Int {
        GameModel.players.handSize
    }
    
    var playDeck: Deck {
        GameModel.deck
    }
    
//    var playCard: Card {
//        currrentPlayer.playCard
//    }
    var currrentPlayer: Player {
        GameModel.gameStatus.currentPlayer
    }
    var playerHand: Array<Card> {
        GameModel.gameStatus.currentPlayer.hand
    }
    
    var playerRole: Role {
        GameModel.gameStatus.currentPlayer.role
    }
    var playerStatus: playerStatus {
        GameModel.gameStatus.currentPlayer.playerStatus
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
    
    func playActionCard(player: Player){
        return GameModel.playActionCard(player: player, card: currrentPlayer.playCard)
    }
    
    func setCard(card: Card, player: Player) {
        objectWillChange.send()
        print("set card \(card.cardType)")
        player.setCard(card: card)
        
    }
    
    func swapCard(card: Card) {
        objectWillChange.send()
        GameModel.swapCard(card: card)
    }
    

}
