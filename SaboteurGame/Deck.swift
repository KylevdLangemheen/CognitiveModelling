//
//  Deck.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 01/03/2021.
//

import Foundation



class Deck {
    var cards: Array<Card> = []
    var directionCount: Int
    var crossCardCount: Int
    init(directionCount: Int, crossCardCount: Int) {
        self.directionCount = directionCount
        self.crossCardCount = crossCardCount
        
        let directions: Array<String> = ["⬆️","➡️","⬇️","⬅️"]
        
        var id: Int = 0
        
        // Corners
        for start in 0..<directionCount {
            for end in start+1..<directionCount {
                var newCard = Card(cardType: "path",id: id)
                newCard.connections[start] = 1
                newCard.connections[end] = 1
                let newDirections = [directions[start],directions[end]]
                newCard.cardConent = newDirections.joined(separator: "")
                cards.append(newCard)
                id += 1
            }
        }
        
        // T-Shape
        for closed in 0..<directionCount {
            var newCard = Card(cardType: "path", connections: [1,1,1,1],id: id)
            newCard.connections[closed] = 0
            var newDirections = directions
            newDirections.remove(at: closed)
            newCard.cardConent = newDirections.joined(separator: "")
            cards.append(newCard)
            id += 1
        }
        
        // X-Shape
        for _ in 0..<crossCardCount {
            cards.append(Card(cardType: "path", cardConent: directions.joined(separator: ""), connections: [1,1,1,1],id: id))
            id += 1
        }
        cards.shuffle()
    }

    func drawCard() -> Card {
        print(cards)
        if self.cards.count != 0 {
            return self.cards.popLast()!
        } else {
            return Card(cardType: "None",id:0)
        }
        
    }
}


struct Card: Hashable {
    var isFaceUp: Bool = false
    var cardType: String = "" // goal, action or path
    var cardConent: String = " "
    var connections: Array<Int> = [0,0,0,0] // If 1 then there a open connection at [Top,Right,Bottom,Left] if  2, then there is closed connection from that side thus, [2,0,2,0] can be connected at the top and bottom but both have a dead end.
    var id: Int
}
    
