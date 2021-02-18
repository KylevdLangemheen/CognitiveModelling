//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct playingField<Field> {
    var cards: Array<Card>
    
    
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return -1 // TODO: bogus!
    }
    
//    init(numberOfCards: Int){
//        for index in 0..<numberOfCards {
//            cards.append(Card(content:"",id:index,category:""))
//        }
//    }
    
    struct Card: Identifiable {
        var category: String
        var content: String
        var id: Int
    }
}
