//
//  Players.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/03/2021.
//

import Foundation

struct Players {
    let playerCount: Int
    let handSize: Int
    var players: Array<Player> = []
    
    init(playerCount: Int, handSize: Int, deck: Deck) {
        self.playerCount = playerCount
        self.handSize = handSize
        
        var roles: Array<String> = Array(repeating: "Miner", count: playerCount) + Array(repeating: "Saboteur", count: playerCount-1)
        roles.shuffle()
        
        for id in 0..<playerCount {
            players.append(Player(role: roles[id], id: id, deck: deck, handSize: handSize))
        }
    }
    

}

class Player {
    var status: String = "Nothing" // placingCard, waiting (for other player), usingCard(action), redraw
    var role: String
    var playCard: Card!
    var hand: Array<Card> = []
    var id: Int
    
    init(role: String, id: Int, deck: Deck, handSize: Int) {
        self.role = role
        self.id = id
        for _ in 0..<handSize {
            self.hand.append(deck.drawCard())
        }
    }
    
    func newCard(card: Card){
        self.hand.append(card)
    }
    
    func changeStatus(status: String) {
        self.status = status
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
        self.playCard = card
    }
}
