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
        self.human = (Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .human, name: "Human"))
        id += 1
      
        let names: Array<String> = ["Bob", "Jenny"]
        for _ in 0..<numOfComputers {
            self.computers.append(Player(role: roles[id], id: id, deck: deck, handSize: handSize, type: .computer, name: names[id-1]))

            id += 1
        }
    }
    

    
    func giveOutGold(winPlayer: Role) {
        if human.role == winPlayer {
            if winPlayer == .miner {
                human.gold += 2
            } else {
                human.gold += 4
            }
        }
        
        for player in computers {
            if player.role == winPlayer {
                if winPlayer == .miner {
                    player.gold += 2
                } else {
                    player.gold += 4
                }
            }
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
    var name: String
    var playCard: Card!
    var hand: Array<Card> = []
    var id: Int
    var skipped: Bool = false
    var gold: Int = 0
    let model = Model()
    
    
    init(role: Role, id: Int, deck: Deck, handSize: Int, type: playerType, name: String) {
        playerStatus = .waiting
        tools = Tools()
        self.role = role
        self.id = id
        self.type = type
        self.name = name
        for _ in 0..<handSize {
            self.hand.append(deck.drawCard())
        }
        model.loadModel(fileName: "rps")
        model.run()
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
        case .tool:
            changePlayerStatus(status: .usingToolCard)
        default:
            print("Something went wrong in setCard")
        }
   
    }
    
    func removeSetCard() {
        self.playCard = nil
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

enum Role: String {
    case miner, saboteur
}

enum playType {
    case destroyCard, placeCard, toolModifier
}

enum playerType {
    case computer, human
}
