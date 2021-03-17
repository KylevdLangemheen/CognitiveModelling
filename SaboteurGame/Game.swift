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
        print("Initializing the game")
        self.field = Field(columns: 7, rows: 11)
        self.deck = Deck(crossCardCount: 30, actionCardCount: 16)
        self.players = Players(humanPlayers: 1, computers: 1, handSize: 6, deck: deck )
        self.gameStatus = GameStatus(currentPlayer: players.players[0])
        gameStatus.currentPlayer.playerStatus = .playing
        self.gameStatus.status = .playing
    }
    
    mutating func changeStatus(status: gameStatus) {
        gameStatus.status = status
    }
    
    mutating func play() {
        if gameStatus.currentPlayer.type == .computer {
            computerPlay(computer: gameStatus.currentPlayer)
        }
    }
    
    mutating func endTurn() {
        gameStatus.currentPlayer.changePlayerStatus(status: .waiting)
        if gameStatus.currentPlayer.type == .computer {
            gameStatus.currentPlayer = players.players[0]
            gameStatus.currentPlayer.changePlayerStatus(status: .playing)
        } else {
            gameStatus.currentPlayer = players.players[1]
            gameStatus.currentPlayer.changePlayerStatus(status: .playing)
        }
        print("\(gameStatus.currentPlayer.type) is now \(gameStatus.currentPlayer.playerStatus)")
        for card in gameStatus.currentPlayer.hand {
            print(card.id)
        }
        play()
    }
    
    mutating func computerPlay(computer: Player){
        var possiblePlays: Array<cardPlay> = []
        for card in computer.hand {
            if card.cardType == .path {
                possiblePlays.append(contentsOf: field.getPosiblePathPlays(card: card))
            }
        }
        possiblePlays.shuffle()
        if possiblePlays.count != 0 {
            computer.playerStatus = .placingCard
            placeCard(card: possiblePlays[0].card, cell: possiblePlays[0].cell)
        } else {
            for card in computer.hand {
                print(card.id)
            }
            print("Possible plays is zero" )
        }
        
        
        
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
        endTurn()
        print("played action card")
    }
    
    mutating func placeCard(card: Card, cell: Cell){
        if gameStatus.currentPlayer.playerStatus == .placingCard {
            if field.placeCard(cell: cell, card: card) {
                gameStatus.currentPlayer.removeCardFromHand(id: card.id)
                gameStatus.currentPlayer.newCard(card: deck.drawCard())
                endTurn()
            } else {
                gameStatus.currentPlayer.changePlayerStatus(status: .playing)
            }
        } else {
            print("\(gameStatus.currentPlayer.type) did not select a card")
        }
        
    }
    
    

    
    
    struct GameStatus {
        var status: gameStatus = .start
        var currentPlayer: Player
    }
}
    


enum gameStatus {
    case start, playing, end
}
