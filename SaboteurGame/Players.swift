//
//  Players.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/03/2021.
//

import Foundation

struct Players {
    let handSize: Int
    var human: Player
    var computers: Array<Player> = []
    var numberOfPlayers = 0
    init(numOfComputers: Int, handSize: Int, deck: Deck) {
        self.handSize = handSize
        self.numberOfPlayers = numOfComputers + 1
        var roles: Array<Role> = Array(repeating: .miner, count: numberOfPlayers) + Array(repeating: .saboteur, count: numberOfPlayers)
        roles.shuffle()
        
        var id = 0
        self.human = (Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .human))
        id += 1
      
        
        for _ in 0..<numOfComputers {
            self.computers.append(Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .computer))
            id += 1
        }
    }
}

func nextPlayer(currentPlayerId: Int, players: Players) -> Player {
    if currentPlayerId != players.numberOfPlayers - 1 {
        for computer in players.computers {
            if computer.id == currentPlayerId + 1 {
                return computer
            }
        }
    }
    return players.human
}


class Player: Identifiable {
    var playerStatus: playerStatus // placingCard, waiting (for other player), usingCard(action), redraw
    var tools: Tools
    var role: Role
    var type: playerType
    var playCard: Card!
    var hand: Array<Card> = []
    var id: Int
    var skipped: Bool = false
    
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
    
    func changeToolStatus(tool: toolType, actionType: actionType) -> Bool{
        switch tool {
        case .pickaxe:
            switch (tools.pickaxe, actionType) {
            case (.intact, .breakTool): tools.pickaxe = .broken
            case (.broken, .repairTool): tools.pickaxe = .intact
            default: print("Pickaxe already broken or already intact"); return false}
        case .minecart:
            switch (tools.mineCart, actionType) {
            case (.intact, .breakTool): tools.mineCart = .broken
            case (.broken, .repairTool): tools.mineCart = .intact
            default: print("Pickaxe already broken or already intact"); return false}
        case .lamp:
            switch (tools.lamp, actionType) {
            case (.intact, .breakTool): tools.lamp = .broken
            case (.broken, .repairTool): tools.lamp = .intact
            default: print("Pickaxe already broken or already intact"); return false}
        }
        return true
    }
    
    func changePlayerStatus(status: playerStatus) {
        playerStatus = status
        print("\(self.type) is now \(self.playerStatus)")
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
    
    func swapCard(card: Card) {
        let cardIdx = getCardIndexInHand(id: playCard.id)
        self.hand[cardIdx] = card
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
    
    func removeSetCard() {
        self.playCard = nil
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

enum toolType {
    case pickaxe, minecart, lamp
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
