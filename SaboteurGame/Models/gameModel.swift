//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct gameModel {
    private var handSize: Int = 6
    var field: Field
    var deck: Deck
    var human: Player
    var computers: Array<Player> = []
    var currentPlayer: Player
    private let minerThreshold: Float = 2
    private let saboteurThreshold: Float = 0
    var players: Array<Player> = []
    var gameStatus: gameStatus = .playing


    init() {
        //print("Initializing the game")
        self.field = Field(columns: 11, rows: 7)
        self.deck = Deck(actionCardsCount: 4,
                         deadEndCardsCount: 1,
                         horizontalLinePathCardsCount: 1,
                         tShapedPathCardsCount: 1,
                         rightCornerPathCardsCount: 1,
                         leftCornerPathCardsCount: 1,
                         verticalLinePathCardsCount: 1,
                         rotatedTShapedPathCardsCount: 1,
                         crossShapedPathCardsCount: 20)
        
        self.human = Player(role: .miner, id: 0, deck: deck, handSize: 6, type: .human, name: "Koen", field: field)
        self.currentPlayer = self.human
//        self.currentPlayer.playerStatus = .playing
        
        createPlayers()
    }


    mutating func createPlayers() {
        // Initiale roles 3 saboteurs and 1 saboteur
        var roles: Array<Role> = Array(repeating: .miner, count: 3) + Array(repeating: .saboteur, count: 1)
        roles.shuffle()
        
        // Initialize role of human player
        human.role = roles.popLast() ?? .miner
        players.append(human)
        // Initialze computers
        var id = 1
        let computerNames = ["Bob", "Jenny"]
        for name in computerNames {
            computers.append(Player(role: roles.popLast() ?? .miner, id: id, deck: deck, handSize: 6, type: .computer, name: name , field: field))
            id += 1
        }
        
        // Reference all players in every player
        players.append(contentsOf: computers)
        for player in players {
            player.addPlayers(players: players)
        }
        
    }
    
    
    mutating func play() {
        if deck.cards.count == 0 {
            //print("No more cards in deck")
            for player in players {
                if !player.skipped {
                    return
                }
            }
            //print("Saboteur won the game")
            endGame(winPlayer: .saboteur)
        
        }
    }

    
    
    mutating func endTurn() {
        if field.checkGoalPath() {
            endGame(winPlayer: currentPlayer.role)
        } else {

            nextPlayer()
            play()
        }
    }


    mutating func nextPlayer() {
        if currentPlayer.id != players.count - 1 {
            currentPlayer = getPlayerFromId(id: currentPlayer.id + 1 )
        } else {
            currentPlayer = getPlayerFromId(id: 0)
        }
    }
    
    func getPlayerFromId(id: Int) -> Player {
        for player in players {
            if player.id == id {
                return player
            }
        }
        return players[0]
    }

    func updateModels(play: cardPlay){
        for player in players {
            if player.type != .human {
                if play.playType == .placeCard {
                    updateFromPath(playerToUpdate: player, play: play)
                } else {
                    updateFromAction(playerToUpdate: player, play: play)
                }
                
            }
        }
    
    }
    
    func updateFromPath(playerToUpdate: Player, play: cardPlay) {
        //print("Updating the beliefs of \(playerToUpdate.name) after \(play.fromPlayer.name) played a path card!")
        let playerno = playerToUpdate.mapPlayerID(player: play.fromPlayer)
        playerToUpdate.model.modifyLastAction(slot: "player", value: playerno)
        if play.coopValue > minerThreshold {
            //print("Role miner will be activated. \(String(describing: play.coopValue))")
            playerToUpdate.model.modifyLastAction(slot: "role", value: "miner")
        } else if play.coopValue < saboteurThreshold {
            //print("Role saboteur will be activated. \(String(describing: play.coopValue))")
            playerToUpdate.model.modifyLastAction(slot: "role", value: "saboteur")
        } else {
            //print("Role unknown will be activated. \(String(describing: play.coopValue))")
            playerToUpdate.model.modifyLastAction(slot: "role", value: "unknown")
        }
        playerToUpdate.model.run()
        
    }

    func updateFromAction(playerToUpdate: Player, play: cardPlay) {
        //print("Updating the beliefs of \(playerToUpdate.name) after \(play.fromPlayer.name) played an action card!")
        let fromPlayerModelId = playerToUpdate.mapPlayerID(player: play.fromPlayer)
        let toPlayerModelId = playerToUpdate.mapPlayerID(player: play.toPlayer)
        playerToUpdate.model.modifyLastAction(slot: "from", value: fromPlayerModelId)
        playerToUpdate.model.modifyLastAction(slot: "to", value: toPlayerModelId)
        let actionType = play.card.action.actionType
        if actionType == .breakTool {
            playerToUpdate.model.modifyLastAction(slot: "type", value: "break")
        }
        if actionType == .repairTool {
            playerToUpdate.model.modifyLastAction(slot: "type", value: "repair")
        }
        playerToUpdate.model.run()
    }



    mutating func resetGame() {
        //print("Initializing the game")
        gameStatus = .playing
        self.field = Field(columns: 11, rows: 7)
        self.deck = Deck(actionCardsCount: 4,
                         deadEndCardsCount: 1,
                         horizontalLinePathCardsCount: 1,
                         tShapedPathCardsCount: 1,
                         rightCornerPathCardsCount: 1,
                         leftCornerPathCardsCount: 1,
                         verticalLinePathCardsCount: 1,
                         rotatedTShapedPathCardsCount: 1,
                         crossShapedPathCardsCount: 20)
        createPlayers()
        self.currentPlayer = human
//        self.currentPlayer.playerStatus = .playing
    }

    mutating func endGame(winPlayer: Role) {
        switch winPlayer {
        case .miner: gameStatus = .minersWin
        case .saboteur: gameStatus = .saboteursWin
        }
    }


}

