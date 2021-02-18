//
//   gameCore.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct gameCore<CardContent> {
    var cards: Array<Card>
    
    mutating func choose(card: Card) {
        let chosenIndex: Int = self.index(of: card)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
        
        print("Card chosen: \(card)")
    }
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return -1 // TODO: bogus!
    }
    
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var content: CardContent
        var id: Int
    }
}
