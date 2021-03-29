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
    var currentPlayer: Player
    var turnsNotPlayed: Int = 0
    let numOfComputer: Int = 2
    let model = Model()


    init() {
        print("Initializing the game")
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
        self.players = Players(numOfComputers: numOfComputer, handSize: 6, deck: deck)
        self.currentPlayer = players.human
        self.currentPlayer.playerStatus = .playing

        model.loadModel(fileName: "rps")
        model.run()
    }



    mutating func play() {
        if deck.cards.count == 0 {
            print("No more cards in deck")
            if players.human.skipped && players.computers[0].skipped && players.computers[1].skipped{
                print("Saboteur won the game")
                endGame(winPlayer: .saboteur)
            }
        }

        if currentPlayer.type == .computer {
            computerPlay(computer: currentPlayer)
        }
    }

    func playableActions(players: Array<Player>) -> Int {
        var possiblePathPlays: Array<cardPlay> = []
        var posibeToolPlays: Array<cardPlay> = []

        for player in players {
            for card in player.hand {
                switch card.cardType{
                case .path: if checkTools(tools: player.tools) == .intact {possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))}
                case .tool: posibeToolPlays.append(contentsOf: getPossibleToolPlays(card: card))
                default:
                    break
                }
            }
        }
        return posibeToolPlays.count + possiblePathPlays.count
    }

    mutating func endTurn() {
        currentPlayer.changePlayerStatus(status: .waiting)

        if currentPlayer.type == .computer {
            currentPlayer = nextPlayer(currentPlayerId: currentPlayer.id, players: players)
            currentPlayer.changePlayerStatus(status: .playing)
        } else {
            currentPlayer = nextPlayer(currentPlayerId: currentPlayer.id, players: players)
            currentPlayer.changePlayerStatus(status: .playing)
        }
        play()
    }

    mutating func computerPlay(computer: Player){
        var possiblePathPlays: Array<cardPlay> = []
        var posibeToolPlays: Array<cardPlay> = []
        var possiblePlays: Array<cardPlay> = []

        for card in computer.hand {
            if card.cardType == .path {
                possiblePlays.append(contentsOf: field.getPosiblePathPlays(card: card))
            }
            switch card.cardType{
                case .path: if checkTools(tools: computer.tools) == .intact {possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))}
                case .tool: posibeToolPlays.append(contentsOf: getPossibleToolPlays(card: card))
                default:
                    break
            }
        }
        possiblePlays.shuffle()
        if possiblePlays.count != 0 {
            
            //computer.playerStatus = .placingCard
            var playerRoles: [Int: (String, Double)] = [:]
            var playerMap: [Int: String] = [
                0: "one"
            ]
            var toAssign: Array<String> = ["three", "two"]
            for i in 1...3 {
                if i == computer.id {
                    playerMap[i] = "zero"
                } else {
                    playerMap[i] = toAssign.popLast()
                }
            }
            for i in 0..<players.numberOfPlayers {
                if i == computer.id {
                    continue
                }
                var player = players.human
                if i != 0 {
                    player = players.computers[i]
                }
                    
                if let playerno = playerMap[player.id] {
                    model.modifyLastAction(slot: "playerno", value: playerno)
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
        }

        possiblePathPlays.shuffle()
        posibeToolPlays.shuffle()



        if possiblePathPlays.count != 0 && checkTools(tools: computer.tools) == .intact{
//            var playerRoles: [Int: (String, Double)] = [:]
//            let playerMap: [Int: String] = [
//                0: "one",
//                1: "zero"
//            ]
//            var activation = 0.4
            model.modifyLastAction(slot: "playerno", value: "one")
            let roleActivation: (String, Double) = model.lastAction(slot: "role")!

            print("Role activation \(roleActivation)" as String)
//            playerRoles[player.id] = (role, activation)
//            for player in players.players {
//                if let playerno = playerMap[player.id] {
//                    //TODO: skip if playerno is "zero"
//                    //model.modifyLastAction(slot: "playerno", value: playerno)
//                    //(let role, let activation) = model.lastAction(slot: "role")
//                    //playerRoles[player.id] = (role, activation)
//                    playerRoles[player.id] = (playerno, activation)
//                    activation += 0.2
//                }
//            }
//            var sortedKeyValues = Array(playerRoles).sorted(by: {$0.value.1 > $1.value.1})
//            var toRemove: Array<Int> = []
//            for (index, (key, value)) in sortedKeyValues {
//                if key == "unknown" {
//                    toRemove.append(index)
//                }
//            }
//            for i in toRemove {
//                sortedKeyValues.remove(at: i)
//            }
//            for (key, (role, activation)) in sortedKeyValues {
                //TODO: find a possible action card to play:
                //Go over each possibleActions
                    //check if the role matches the player role
                        //possible action has to be helpful to that player
                    //else
                        //possible action has to be unhelpful to that player
//            }
            //TODO: if action has been found, play it. else, if not blocked:
            //Sort possible players by coop value (desc for miner, asc for saboteur)
            //play most coop and value > 3 if miner
            //play most uncoop and value < 3 if saboteur
            //if nothing found or if blocked:
            //find cards to swap
            //swap worst cards, up to 3.

            currentPlayer.setCard(card: possiblePathPlays[0].card)
            placeCard(card: possiblePathPlays[0].card, cell: possiblePathPlays[0].cell)
//        } else if posibeToolPlays.count != 0{
//            currentPlayer.setCard(card: posibeToolPlays[0].card)
//            playActionCard(player: posibeToolPlays[0].player, card: posibeToolPlays[0].card)
        } else if deck.cards.count > 0{
            print(computer.tools)
            computer.playCard = computer.hand[0]
            swapCard()
        } else {
            skipTurn()
        }

    }

    func getComputerPlayerById(id: Int) -> Player!{
        for computer in players.computers {
            if computer.id == id {
                return computer
            }
        }
        return nil
    }

    func getPossibleToolPlays(card: Card) -> Array<cardPlay> {
        var possiblePlays: Array<cardPlay> = []
        var allPlayers: Array<Player> = players.computers
        allPlayers.append(players.human)
        for player in allPlayers {
            if player.id != currentPlayer.id {
                switch(card.action.tool, card.action.actionType){
                case (.pickaxe , .breakTool): if player.tools.pickaxe == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case (.minecart , .breakTool): if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                case (.lamp , .breakTool): if player.tools.pickaxe == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case (.pickaxe , .repairTool): if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                case (.minecart , .repairTool): if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case (.lamp , .repairTool): if player.tools.lamp == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                }
            }
        }
        return possiblePlays
    }


    func checkTools(tools: Tools) -> toolStatus {
        if (tools.lamp == .broken || tools.mineCart == .broken || tools.pickaxe == .broken){
            return .broken
        }
        return .intact
    }


    mutating func swapCard(){
        if deck.cards.count > 0 && currentPlayer.playCard != nil {
            currentPlayer.swapCard(card: deck.drawCard())
            currentPlayer.removeSetCard()
            endTurn()
        } else if currentPlayer.playCard == nil {
            print("Did not select a card")
        } else{
            print("no more cards in the deck")
        }

    }

    mutating func skipTurn() {
        if deck.cards.count == 0 {
            currentPlayer.skipped = true
            endTurn()
        }
    }

    mutating func removePlayedCard(){
        let card: Card = currentPlayer.playCard
        if deck.cards.count > 0 {
            swapCard()
        } else {
            currentPlayer.removeCardFromHand(id: card.id)
            currentPlayer.removeSetCard()
            endTurn()
        }

    }

    mutating func playActionCard(player: Player, card: Card){
        if currentPlayer.playerStatus == .usingToolCard{
            if player.changeToolStatus(tool: card.action.tool, actionType: card.action.actionType) {
                removePlayedCard()
            } else {

            }
        } else {
            print("First set a card before trying to play a tool card")
        }


    }

    mutating func placeCard(card: Card, cell: Cell){
        if currentPlayer.playerStatus == .usingPathCard && checkTools(tools: currentPlayer.tools) == .intact{
            if field.placeCard(cell: cell, card: card) {
                if field.checkGoalPath() {
                    endGame(winPlayer: .miner)
                }
                removePlayedCard()
            } else {
                currentPlayer.changePlayerStatus(status: .playing)
            }
        } else {
            print("\(currentPlayer.type) did something wrong when placing a card")
        }

    }


    mutating func endGame(winPlayer: Role) {

        players.giveOutGold(winPlayer: winPlayer)
        field = Field(columns: 11, rows: 7)
        deck = Deck(actionCardsCount: 4,
                         deadEndCardsCount: 1,
                         horizontalLinePathCardsCount: 1,
                         tShapedPathCardsCount: 1,
                         rightCornerPathCardsCount: 1,
                         leftCornerPathCardsCount: 1,
                         verticalLinePathCardsCount: 1,
                         rotatedTShapedPathCardsCount: 1,
                         crossShapedPathCardsCount: 20)
        players = Players(numOfComputers: numOfComputer, handSize: 6, deck: deck )
    }


}

enum gameStatus {
    case start, playing, end
}
