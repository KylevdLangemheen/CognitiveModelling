//
//  Deck.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct Deck {
    
    var deck = Array<Card>()

    
    struct Card {
        var isFaceUp: Bool = true
        var cardType: Int = 0
        var cardConent: String
        var id: Int
    }
}
