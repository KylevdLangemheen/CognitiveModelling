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
        self.deck = Deck(directionCount: 4, crossCardCount: 30, actionCardCount: 16)
        self.players = Players(humanPlayers: 1, computers: 1, handSize: 6, deck: deck )
        self.gameStatus = GameStatus(currentPlayer: players.players[0])
        self.gameStatus.status = .playing
        play()
    }
    
    mutating func changeStatus(status: gameStatus) {
        gameStatus.status = status
    }
    
    mutating func play() {
        print(gameStatus.status)
        if self.gameStatus.status == .playing {
            switch (gameStatus.currentPlayer.type, gameStatus.currentPlayer.playerStatus) {
            case (.human, .waiting):
                changePlayer(player: players.players[1])
                computerPlay(computer: gameStatus.currentPlayer as! Computer)
            case (.computer, .waiting):
                changePlayer(player: players.players[0])
            default:
                return
            }
        }
        
    }
    
    mutating func changePlayer(player: Player) {
        gameStatus.currentPlayer = player
    }
    
    mutating func computerPlay(computer: Computer){
        print("computer is now Playing")
        for card in computer.hand {
            print(card.cardType)
            if card.cardType == .path {
                computer.possiblePlays.append(contentsOf: field.getPosiblePathPlays(card: card))
            }
        }
        print(computer.possiblePlays.count)
//        print(computer.possiblePlays)
        gameStatus.currentPlayer.changePlayerStatus(status: .waiting)
        play()
    }
    
    mutating func playActionCard(){
        let card: Card = gameStatus.currentPlayer.playCard
        let player = players.players[1]
        
        switch card.actionType {
        case .breakAxe:
            if player.tools.pickaxe == .broken {
                print("Pickaxe is already broken")
            } else {
                player.tools.pickaxe = .broken
            }
        case .breakCart:
            if player.tools.mineCart == .broken {
                print("Minecart is already broken")
            } else {
                player.tools.mineCart = .broken
            }
        case .breakLamp:
            if player.tools.lamp == .broken {
                print("Lamp is already broken")
            } else {
                player.tools.lamp = .broken
            }
        case .repairAxe:
            if player.tools.pickaxe == .intact {
                print("Pickaxe is already intact")
            } else {
                player.tools.pickaxe = .intact
            }
        case .repairCart:
            if player.tools.mineCart == .intact {
                print("Minecart is already intact")
            } else {
                player.tools.mineCart = .intact
            }
        case .repairLamp:
            if player.tools.lamp == .intact {
                print("Lamp is already intact")
            } else {
                player.tools.lamp = .intact
            }
        default:
            print("something went wrong wen playing an action card")
        }
        gameStatus.currentPlayer.changePlayerStatus(status: .waiting)
        play()
        print("played action card")
    }
    
    mutating func placeCard(card: Card, cell: Cell){
        if gameStatus.currentPlayer.playerStatus == .placingCard {
            if field.placeCard(cell: cell, card: card) {
                gameStatus.currentPlayer.removeCardFromHand(card: card)
                gameStatus.currentPlayer.newCard(card: deck.drawCard())
                gameStatus.currentPlayer.changePlayerStatus(status: .waiting)
                print("placed card")
            } else {
                gameStatus.currentPlayer.changePlayerStatus(status: .playing)
                print("invalid move")
            }
        } else {
            print("Did not select a card")
        }
        play()
        
    }
    
    

    
    
    struct GameStatus {
        var status: gameStatus = .start
        var currentPlayer: Player
    }
}
    


enum gameStatus {
    case start, playing, end
}
