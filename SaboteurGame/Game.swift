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
            var playerRoles: [Int: (String, Double)] = [:]
            let playerMap: [Int: String] = [
                0: "one",
                1: "zero"
            ]
            var activation = 0.4
            for player in players.players {
                if let playerno = playerMap[player.id] {
                    //TODO: skip if playerno is "zero"
                    //model.modifyLastAction(slot: "playerno", value: playerno)
                    //(let role, let activation) = model.lastAction(slot: "role")
                    //playerRoles[player.id] = (role, activation)
                    playerRoles[player.id] = (playerno, activation)
                    activation += 0.2
                }
            }
            var sortedKeyValues = Array(playerRoles).sorted(by: {$0.value.1 > $1.value.1})
            var toRemove: Array<Int> = []
            for (index, (key, value)) in sortedKeyValues {
                if key == "unknown" {
                    toRemove.append(index)
                }
            }
            for i in toRemove {
                sortedKeyValues.remove(at: i)
            }
            for (key, (role, activation)) in sortedKeyValues {
                //TODO: find a possible action card to play:
                //Go over each possibleActions
                    //check if the role matches the player role
                        //possible action has to be helpful to that player
                    //else
                        //possible action has to be unhelpful to that player
            }
            //TODO: if action has been found, play it. else, if not blocked:
            //Sort possible players by coop value (desc for miner, asc for saboteur)
            //play most coop and value > 3 if miner
            //play most uncoop and value < 3 if saboteur
            //if nothing found or if blocked:
            //find cards to swap
            //swap worst cards, up to 3.
            
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
            print("something went wrong when playing an action card")
        }
        //depending on what was played, infer or update beliefs act-r model
        endTurn()
        print("played action card")
    }
    
    mutating func placeCard(card: Card, cell: Cell){
        if gameStatus.currentPlayer.playerStatus == .placingCard {
            if field.placeCard(cell: cell, card: card) {
                gameStatus.currentPlayer.removeCardFromHand(id: card.id)
                gameStatus.currentPlayer.newCard(card: deck.drawCard())
                //depending on who played what, update beliefs act-r model
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
