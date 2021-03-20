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
            players.append(Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .computer))
            id += 1
        }
    }
    

}

class Player: Identifiable {
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
    }
    
    func removeCardFromHand(id: Int) {
        let cardIndex: Int = getCardIndexInHand(id: id)
        hand.remove(at: cardIndex)
    }
    
    func getCardIndexInHand(id: Int) -> Int{
        for handIdx in 0..<hand.count {
            if hand[handIdx].id == id {
                return handIdx
            }
        }
        return 0
    }
    
    func setCard(card: Card) {
        self.playCard = card
        switch card.cardType {
        case .path:
            changePlayerStatus(status: .usingPathCard)
        case .action:
            changePlayerStatus(status: .usingActionCard)
        case .tool:
            changePlayerStatus(status: .usingToolCard)
        
        default:
            print("Something went wrong in setCard")
        }        
    }
    
    func addCardToHand(card: Card){
        if hand.count <= 7 {
            hand.append(card)
        } else {
            print("Hand has already 6 cards, not valid to get another card. Something went wrong")
        }
        
    }
}

enum playerStatus {
    case playing, waiting, usingActionCard, usingPathCard, usingToolCard
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
