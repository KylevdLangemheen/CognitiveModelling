//
//  Deck.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct Deck {
    
    var deck = Array<Card>()
    
    let pathCards: Int = 44
    let goldenNuggetCards: Int = 28
    let actionCards: Int = 27
    
    
//      let goldDiggers = 2
//      let saboteurs = 1
    
    init(){
        deck = Array(repeating: Card(isFaceUp: true, cardType: 0, cardContent: "⛏", id: 0), count: pathCards)
    }

//    func returnIds(pathCards: Int) -> Array<Int> {
//        var pathCardsIdx = Array(0...pathCards)
//        pathCardsIdx.shuffle()
//        return pathCardsIdx
//    }
            
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var cardType: Int = 0
        var cardContent: String
        var id: Int
    }
}
