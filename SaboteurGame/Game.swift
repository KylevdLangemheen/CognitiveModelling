//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct Game {
    var handSize: Int = 6
    var field: Field
    var deck: Deck
    var players: Players
    var gameStatus: GameStatus
    
    init() {
        self.field = Field(columns: 7, rows: 11)
        self.deck = Deck(directionCount: 4, crossCardCount: 16)
        self.players = Players(playerCount: 2, handSize: 6, deck: deck)
        self.gameStatus = GameStatus(currentPlayer: players.players[0])
    }
    
    mutating func changeStatus(status: String) {
        gameStatus.status = status
    }

    func placeCard(card: Card,cell: Cell) -> Bool{
        if gameStatus.currentPlayer.status == "placingCard" {
            if field.placeCard(cell: cell, card: card) {
                gameStatus.currentPlayer.removeCardFromHand(card: card)
                gameStatus.currentPlayer.newCard(card: deck.drawCard())
                gameStatus.currentPlayer.status = "waiting"
                
                return true
            } else {
                gameStatus.currentPlayer.status = "waiting"
                return false
            }
        } else {
            return false
        }


    }
    struct GameStatus {
        var status: String = "start"
        var currentPlayer: Player
        var paths: Array<Array<Int>> = [[]]
    }
}
    


