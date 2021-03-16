//
//  Players.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/03/2021.
//

import Foundation

struct Players {
    let handSize: Int
    var players: Array<Player> = []
    
    init(humanPlayers: Int, computers: Int, handSize: Int, deck: Deck) {
        self.handSize = handSize

        var roles: Array<Role> = Array(repeating: .miner, count: humanPlayers + computers) + Array(repeating: .saboteur, count: humanPlayers + computers)
        roles.shuffle()
        
        var id = 0
        for _ in 0..<humanPlayers {
            players.append(Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .human))
            id += 1
        }
        
        for _ in 0..<computers {
            players.append(Computer(role: roles[id], id: id, deck: deck, handSize: handSize, type: .computer))
            id += 1
        }
    }
    

}

class Player {
    var playerStatus: playerStatus // placingCard, waiting (for other player), usingCard(action), redraw
    var tools: Tools
    var role: Role
    var type: playerType
    var playCard: Card!
    var hand: Array<Card> = []
    var id: Int
    
    init(role: Role, id: Int, deck: Deck, handSize: Int, type: playerType) {
        playerStatus = .waiting
        tools = Tools()
        self.role = role
        self.id = id
        self.type = type
        for _ in 0..<handSize {
            self.hand.append(deck.drawCard())
        }
    }
    
    func newCard(card: Card){
        hand.append(card)
    }
    
    func changePlayerStatus(status: playerStatus) {
        playerStatus = status
        print("Status: \(status)")
    }
    
    func removeCardFromHand(card: Card) {
        let cardIndex: Int = getCardIndexInHand(card: card)
        hand.remove(at: cardIndex)
    }
    
    func getCardIndexInHand(card: Card) -> Int{
        for handIdx in 0..<hand.count {
            if hand[handIdx].id == card.id {
                return handIdx
            }
        }
        return 0
    }
    
    func setCard(card: Card) {
        playCard = card
        switch card.cardType {
        case .path:
            changePlayerStatus(status: .placingCard)
        case .action:
            changePlayerStatus(status: .usingCard)
        default:
            changePlayerStatus(status: .playing)
        }
        
        
    }
}

class Computer: Player {
    var possiblePlays: Array<cardPlay> = []
}

struct cardPlay {
    var playType: playType
    var card: Card
    var cell: Cell!
    var player: Player!
    var coopValue: Float
}

enum playerStatus {
    case playing, waiting, placingCard, usingCard
}

struct Tools {
    var pickaxe: toolStatus = .intact
    var mineCart: toolStatus = .intact
    var lamp: toolStatus = .intact
}

enum toolStatus {
    case intact, broken
}

enum Role {
    case miner, saboteur
}

enum playType {
    case destroyCard, placeCard, toolModifier
}

enum playerType {
    case computer, human
}
