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
        self.deck = Deck(actionCardsCount: 4,
                         firstNinePathCardsCount: 9,
                         horizontalLinePathCardsCount: 3,
                         tShapedPathCardsCount: 5,
                         rightCornerPathCardsCount: 4,
                         leftCornerPathCardsCount: 5,
                         verticalLinePathCardsCount: 4,
                         rotatedTShapedPathCardsCount: 5,
                         crossShapedPathCardsCount: 5)
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
//        print("\(gameStatus.currentPlayer.type) is now \(gameStatus.currentPlayer.playerStatus)")
        play()
    }
    
    mutating func computerPlay(computer: Player){
        var possiblePathPlays: Array<cardPlay> = []
        var posibeToolPlays: Array<cardPlay> = []
        
        for card in computer.hand {
            switch card.cardType{
            case .path: possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))
            case .tool: posibeToolPlays.append(contentsOf: getPossibleToolPlays(card: card))
            default:
                break
            }
        }
    
        possiblePathPlays.shuffle()
        posibeToolPlays.shuffle()
        
        
        
        if possiblePathPlays.count != 0 && checkTools(tools: computer.tools) == .intact{
            computer.playerStatus = .usingPathCard
            placeCard(card: possiblePathPlays[0].card, cell: possiblePathPlays[0].cell)
        } else if posibeToolPlays.count > 0{
            computer.playerStatus = .usingToolCard
            playActionCard(player: posibeToolPlays[0].player, card: posibeToolPlays[0].card)
        } else if deck.cards.count > 0{
//            print("Computer is swapping a card")
            swapCard(card: computer.hand[0])
        }
        
        
    }
    
    func getPossibleToolPlays(card: Card) -> Array<cardPlay> {
        var possiblePlays: Array<cardPlay> = []
        
        for player in players.players {
            if player.id != gameStatus.currentPlayer.id {
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
    

    mutating func swapCard(card: Card){
        if deck.cards.count > 0 {
            gameStatus.currentPlayer.removeCardFromHand(id: card.id)
            gameStatus.currentPlayer.addCardToHand(card: deck.drawCard())
            endTurn()
        } else {
            print("no more cards in the deck")
        }

    }
    
    mutating func playActionCard(player: Player, card: Card){
        
        if gameStatus.currentPlayer.playerStatus == .usingToolCard {
            switch card.actionType {
            case .breakAxe:
                if player.tools.pickaxe == .broken {
                    print("Pickaxe is already broken")
                } else {
                    player.tools.pickaxe = .broken
                    endTurn()
                }
            case .breakCart:
                if player.tools.mineCart == .broken {
                    print("Minecart is already broken")
                } else {
                    player.tools.mineCart = .broken
                    endTurn()
                }
            case .breakLamp:
                if player.tools.lamp == .broken {
                    print("Lamp is already broken")
                } else {
                    player.tools.lamp = .broken
                    endTurn()
                }
            case .repairAxe:
                if player.tools.pickaxe == .intact {
                    print("Pickaxe is already intact")
                } else {
                    player.tools.pickaxe = .intact
                    endTurn()
                }
            case .repairCart:
                if player.tools.mineCart == .intact {
                    print("Minecart is already intact")
                } else {
                    player.tools.mineCart = .intact
                    endTurn()
                }
            case .repairLamp:
                if player.tools.lamp == .intact {
                    print("Lamp is already intact")
                } else {
                    player.tools.lamp = .intact
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
        print(gameStatus.currentPlayer.tools)
        if gameStatus.currentPlayer.playerStatus == .usingPathCard && checkTools(tools: gameStatus.currentPlayer.tools) == .intact{
            if field.placeCard(cell: cell, card: card) {
                gameStatus.currentPlayer.removeCardFromHand(id: card.id)
                gameStatus.currentPlayer.newCard(card: deck.drawCard())
                if field.checkGoalPath() {
                    endGame()
                }
                endTurn()
            } else {
                gameStatus.currentPlayer.changePlayerStatus(status: .playing)
            }
        } else {
            print("\(gameStatus.currentPlayer.type) did not select a card")
        }
        
    }
    mutating func endGame() {
        self.field = Field(columns: 7, rows: 11)
        self.deck = Deck(actionCardsCount: 4,
                         firstNinePathCardsCount: 9,
                         horizontalLinePathCardsCount: 3,
                         tShapedPathCardsCount: 5,
                         rightCornerPathCardsCount: 4,
                         leftCornerPathCardsCount: 5,
                         verticalLinePathCardsCount: 4,
                         rotatedTShapedPathCardsCount: 5,
                         crossShapedPathCardsCount: 5)
        self.players = Players(humanPlayers: 1, computers: 1, handSize: 6, deck: deck )
        self.gameStatus = GameStatus(currentPlayer: players.players[0])
        gameStatus.currentPlayer.playerStatus = .playing
        self.gameStatus.status = .playing
    }
    
    struct GameStatus {
        var status: gameStatus = .start
        var currentPlayer: Player
        var turnsNotPlayed: Int = 0
    }
    

}
    
enum gameStatus {
    case start, playing, end
}
