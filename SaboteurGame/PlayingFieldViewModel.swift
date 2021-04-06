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
    
    var deck: Deck {
        GameModel.deck
    }
    
    var humanHand: Array<Card> {
        GameModel.players.human.hand
    }
    var humanPlayer: Player {
        GameModel.players.human
    }
    
    var currrentPlayer: Player {
        GameModel.currentPlayer
    }
    
    var computerPlayers: Array<Player> {
        GameModel.players.computers
    }

    var gameStatus: gameStatus {
        return GameModel.gameStatus
    }
    // MARK: Intent(s)

    func getComputerPlayerById(id: Int) -> Player {
        objectWillChange.send()
        return GameModel.getComputerPlayerById(id:id)
    }
    func placeCard(card: Card,cell: Cell) {
        objectWillChange.send()
        let coopValue = GameModel.field.getCoopValue(card: card, cell: cell)
        let card2Play = cardPlay(playType: .placeCard, card: card, cell: cell, coopValue: coopValue)
        return GameModel.playTheCard(card2Play: card2Play)
    }
    
    
    func playActionCard(player: Player){
        objectWillChange.send()
        let card2Play = cardPlay(playType: .toolModifier, card: humanPlayer.playCard, player: player, coopValue: 0)
        return GameModel.playTheCard(card2Play: card2Play)
    }
    
    func setCard(card: Card, player: Player) {
        objectWillChange.send()
        player.setCard(card: card)
        
    }
    
    func swapCard(card: Card) {
        objectWillChange.send()
        GameModel.swapCard()
    }
    
    func skipTurn(){
        GameModel.skipTurn()
    }
    
    func resetGame() {
        GameModel.resetGame()
    }

}
