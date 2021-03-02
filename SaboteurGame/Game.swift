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
        self.field = Field(columns: 5, rows: 9)
        self.deck = Deck(directionCount: 4, crossCardCount: 16)
        self.players = Players(playerCount: 2, handSize: 6, deck: deck)
        self.gameStatus = GameStatus(currentPlayer: players.players[0])
    }
    
    mutating func changeStatus(status: String) {
        gameStatus.status = status
    }

    struct GameStatus {
        var status: String = "start"
        var currentPlayer: Player
        var paths: Array<Array<Int>> = [[]]
    }
}
    


