//
//  gameModel.swift
//  SaboteurGame
//
//
//

import Foundation

struct gameModel {
    private var handSize: Int = 6
    var field: Field
    var deck: Deck
    var human: Player
    
    var players: Array<Player> = []
    var computers: Array<Player> = []
    var currentPlayer: Player
    
    var gameStatus: gameStatus = .playing


    init() {
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
        
        createPlayers()
    }


    mutating func createPlayers() {
        // Initiale roles 3 saboteurs and 1 saboteur
        var roles: Array<Role> = Array(repeating: .miner, count: 3) + Array(repeating: .saboteur, count: 1)
        roles.shuffle()
        
        // Initialize role of human player
        human.role = roles.popLast() ?? .miner
        players.append(human)
        
        // Initialze simulated players
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
    
    
    mutating func allPlayersSkipped() -> Bool {
        
        // Check if the game is finished because noboby can or does not want to make a play
        if deck.cards.count == 0 {
            for player in players {
                if !player.skipped {
                    return true
                }
            }
            endGame(winPlayer: .saboteur)
        
        }
        return false
    }

    
    
    mutating func endTurn() {
        // If either the gold card is reached or all the players skipped, the game is finished
        if field.checkGoalPath() || allPlayersSkipped(){
            endGame(winPlayer: currentPlayer.role)
        } else {
            nextPlayer()
        }
    }
    
    // Gives the turn to the next player
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

    // Update the ACT-R models for the simulated from a play
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
    
    // Update of an ACT-T model when a path card is played
    func updateFromPath(playerToUpdate: Player, play: cardPlay) {
        let minerThreshold: Float = 2
        let saboteurThreshold: Float = 0
        print("Updating the beliefs of \(playerToUpdate.name) after \(play.fromPlayer.name) played a path card!")
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

    // Update of an ACT-T model when an action card is played
    func updateFromAction(playerToUpdate: Player, play: cardPlay) {
        print("Updating the beliefs of \(playerToUpdate.name) after \(play.fromPlayer.name) played an action card!")
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

    // End the game by setting the gameStatus to a win for a certain role
    mutating func endGame(winPlayer: Role) {
        switch winPlayer {
        case .miner: gameStatus = .minersWin
        case .saboteur: gameStatus = .saboteursWin
        }
    }


}

