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
    let minerThreshold: Float = 3
    let saboteurThreshold: Float = 3
    let numOfComputer: Int = 2

    var gameStatus: gameStatus = .playing


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

        for card in computer.hand {
            if checkTools(tools: computer.tools) == .intact{
                if card.cardType == .path {
                    possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))
                }
            }
            switch card.cardType{
                case .path: if checkTools(tools: computer.tools) == .intact {
                    possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))}
                case .tool: posibeToolPlays.append(contentsOf: getPossibleToolPlays(card: card))
                default:
                    continue
            }
        }
        var played: Bool = false
        if possiblePathPlays.count != 0 || posibeToolPlays.count != 0 {

            //computer.playerStatus = .placingCard
            var playerRoles: [Int: (String, Double)] = [:]

            for i in 0..<players.numberOfPlayers {
                if i == computer.id {
                    continue
                }
                var player = players.human
                if i != 0 {
                    player = players.computers[i-1]
                }

                let playerno = mapPlayerID(currentModel: computer, ID: player.id)
                computer.model.modifyLastAction(slot: "playerno", value: playerno)
                computer.model.run()
                let (role, activation) = computer.model.lastAction(slot: "role")!
                print("Model \(computer.name) believes \(playerno) is a \(role)")
                playerRoles[player.id] = (role, activation)
                computer.model.run()
            }
            var sortedKeyValues = Array(playerRoles).sorted(by: {$0.value.1 > $1.value.1})
            var toRemove: Array<Int> = []
            var i = 0
            for (_, (key, _)) in sortedKeyValues {
                if key == "unknown" {
                    toRemove.append(i)
                }
                i += 1
            }

            toRemove = toRemove.sorted().reversed()
            for i in toRemove {
                sortedKeyValues.remove(at: i)
            }
            var cardToPlay: cardPlay
            if possiblePathPlays.count != 0 {cardToPlay = possiblePathPlays[0]}
            else {cardToPlay = posibeToolPlays[0]}
            //First, the model tries to repair itself
            for card in posibeToolPlays {
                let at = card.card.action.actionType
                let pid = card.player.id
                if at == .repairTool && pid == computer.id{
                    cardToPlay = card
                    played = true
                }
            }
            //If it doesn't have to or can't repair itself
            //The model tries to attack/repair players based on belief
            if sortedKeyValues.count != 0 && !played {
                //print("Model \(computer.name) is looking for an action card to play.")
                for (key, (role, _)) in sortedKeyValues {
                    for card in posibeToolPlays {
                        let at = card.card.action.actionType
                        let pid = card.player.id
                        if pid != key {continue}
                        if at == .repairTool && role == computer.role.rawValue {
                            cardToPlay = card
                            played = true
                        }
                        if at == .breakTool && role != computer.role.rawValue {
                            cardToPlay = card
                            played = true
                        }
                    }
                }
            }
            if !played {
                //print("Model \(computer.name) is looking for a path card to play.")
                if computer.role == .miner {
                    possiblePathPlays = possiblePathPlays.sorted(by: {$0.card.coopValue > $1.card.coopValue})
                } else {
                    possiblePathPlays = possiblePathPlays.sorted(by: {$0.card.coopValue < $1.card.coopValue})
                }
                for card in possiblePathPlays {
                    if computer.role == .miner {
                        if card.card.coopValue > minerThreshold {
                            played = true
                            cardToPlay = card
                        }
                    } else {
                        if card.card.coopValue < saboteurThreshold {
                            played = true
                            cardToPlay = card
                        }
                    }
                }
            }
            if played {
                playTheCard(card2Play: cardToPlay, by: currentPlayer)
            } else {
                //No card has been played. A card will need to be swapped.
                print("No card has been played. Time to swap cards.")
            }
        }
        if !played {
            if deck.cards.count > 0{
                //TODO: set least desireable card as playCard
//                print(computer.tools)
//                computer.playCard = computer.hand[0]
                computer.setCard(card: computer.hand[0])
                swapCard()
            } else {
                print("No cards can be swapped as the deck is empty, and no cards could be played. Time to skip a turn.")
                skipTurn()
            }
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
                                                                                                  coopValue: -5/2))}
                case (.minecart , .breakTool): if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: -5/2))}
                case (.lamp , .breakTool): if player.tools.lamp == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: -5/2))}
                case (.pickaxe , .repairTool): if player.tools.pickaxe == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 2.5))}
                case (.minecart , .repairTool): if player.tools.mineCart == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 2.5))}
                case (.lamp , .repairTool): if player.tools.lamp == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player, coopValue: 2.5))}
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

    mutating func playTheCard(card2Play: cardPlay, by: Player) {
        let card = card2Play.card
        by.setCard(card: card)
        let type = card2Play.playType
        if type == .toolModifier {
            print("Player \(by.name) is going to play a \(card.action.actionType) card against \(card2Play.player.name).")
            playActionCard(player: card2Play.player, card: card)
        }
        if type == .placeCard {
            print("Player \(by.name) is going to play a path card.")
            placeCard(card: card, cell: card2Play.cell)
            updateFromPath(by: by, coopVal: card.coopValue)
        }
    }

    func mapPlayerID(currentModel: Player, ID: Int) -> String {
        if ID == 0 {return "one"}
        if ID == currentModel.id {return "zero"}
        var toAssign: Array<String> = ["four", "three", "two"]
        for i in 1..<players.numberOfPlayers {
            if i != currentModel.id {
                let cur = toAssign.popLast()!
                if i == ID {return cur}
            }
        }
        return "error"
    }

    func updateFromPath(by: Player, coopVal: Float) {
        for player in players.computers {
            let playerno = mapPlayerID(currentModel: player, ID: by.id)
            player.model.modifyLastAction(slot: "player", value: playerno)
            if coopVal > 3.6 {
                player.model.modifyLastAction(slot: "role", value: "miner")
            } else if coopVal < 2.4 {
                player.model.modifyLastAction(slot: "role", value: "saboteur")
            } else {
                player.model.modifyLastAction(slot: "role", value: "unknown")
            }
            player.model.run()
        }
    }

    func updateFromAction(from: Player, to: Player, type: actionType) {
        for player in players.computers {
            let fromplayer = mapPlayerID(currentModel: player, ID: from.id)
            let toplayer = mapPlayerID(currentModel: player, ID: to.id)
            player.model.modifyLastAction(slot: "from", value: fromplayer)
            player.model.modifyLastAction(slot: "to", value: toplayer)
            if type == .breakTool {
                player.model.modifyLastAction(slot: "type", value: "break")
            }
            if type == .repairTool {
                player.model.modifyLastAction(slot: "type", value: "repair")
            }
            player.model.run()
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
        } else if currentPlayer.playerStatus != .usingPathCard{
            print("\(currentPlayer.type)'s status is not correct")
        } else {
            print("\(currentPlayer.type)'s tools are broken")
        }

    }

    mutating func resetGame() {
        gameStatus = .playing
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

    mutating func endGame(winPlayer: Role) {
        switch winPlayer {
        case .miner: gameStatus = .minersWin
        case .saboteur: gameStatus = .saboteursWin
        }
        players.giveOutGold(winPlayer: winPlayer)

    }


}

enum gameStatus: String{
    case playing, minersWin, saboteursWin
}
