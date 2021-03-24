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
            if players.human.skipped && players.computers[0].skipped {
                endGame()
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
            switch card.cardType{
            case .path: if checkTools(tools: computer.tools) == .intact {possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))}
            case .tool: posibeToolPlays.append(contentsOf: getPossibleToolPlays(card: card))
            default:
                break
            }
        }
    
        possiblePathPlays.shuffle()
        posibeToolPlays.shuffle()
        
        
        
        if possiblePathPlays.count != 0 && checkTools(tools: computer.tools) == .intact{
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
                switch(card.actionType){
                case .breakAxe: if player.tools.pickaxe == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case .breakCart: if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                case .breakLamp: if player.tools.pickaxe == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case .repairAxe: if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                case .repairCart: if player.tools.mineCart == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                  card: card,
                                                                                                  player: player,
                                                                                                  coopValue: 1.0))}
                case .repairLamp: if player.tools.lamp == .intact {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                   card: card,
                                                                                                   player: player,
                                                                                                   coopValue: 1.0))}
                default: break
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
        if deck.cards.count > 0 && currentPlayer.playCard != nil {
            currentPlayer.removeCardFromHand(id: card.id)
            currentPlayer.addCardToHand(card: deck.drawCard())
            currentPlayer.removeSetCard()
        } else if currentPlayer.playCard == nil {
            print("Did not select a card")
        } else{
            currentPlayer.removeCardFromHand(id: card.id)
            currentPlayer.removeSetCard()
        }

    }
    
    mutating func playActionCard(player: Player, card: Card){
        if currentPlayer.playCard != nil{
            switch card.actionType {
            case .breakAxe:
                if player.tools.pickaxe == .broken {
                    print("Pickaxe is already broken")
                } else {
                    player.tools.pickaxe = .broken
                    removePlayedCard()
                    endTurn()
                }
            case .breakCart:
                if player.tools.mineCart == .broken {
                    print("Minecart is already broken")
                } else {
                    player.tools.mineCart = .broken
                    removePlayedCard()
                    endTurn()
                }
            case .breakLamp:
                if player.tools.lamp == .broken {
                    print("Lamp is already broken")
                } else {
                    player.tools.lamp = .broken
                    removePlayedCard()
                    endTurn()
                }
            case .repairAxe:
                if player.tools.pickaxe == .intact {
                    print("Pickaxe is already intact")
                } else {
                    player.tools.pickaxe = .intact
                    removePlayedCard()
                    endTurn()
                }
            case .repairCart:
                if player.tools.mineCart == .intact {
                    print("Minecart is already intact")
                } else {
                    player.tools.mineCart = .intact
                    removePlayedCard()
                    endTurn()
                }
            case .repairLamp:
                if player.tools.lamp == .intact {
                    print("Lamp is already intact")
                } else {
                    player.tools.lamp = .intact
                    removePlayedCard()
                    endTurn()
                }
            default:
                print("something went wrong wen playing an action card")
            }
        } else {
            print("First set a card before trying to play a tool card")
        }

        
    }
    
    mutating func placeCard(card: Card, cell: Cell){
        if currentPlayer.playerStatus == .usingPathCard && checkTools(tools: currentPlayer.tools) == .intact{
            if field.placeCard(cell: cell, card: card) {
                removePlayedCard()
                if field.checkGoalPath() {
                    endGame()
                }
                endTurn()
            } else {
                currentPlayer.changePlayerStatus(status: .playing)
            }
        } else {
            print("\(currentPlayer.type) did something wrong when placing a card")
            print("\(currentPlayer.playerStatus)")
            print("\(currentPlayer.tools)")
        }
        
    }
    mutating func endGame() {
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
        self.players = Players(numOfComputers: numOfComputer, handSize: 6, deck: deck )
    }
    

}
    
enum gameStatus {
    case start, playing, end
}
