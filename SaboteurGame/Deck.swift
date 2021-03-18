//
//  Deck.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 01/03/2021.
//

import Foundation



class Deck {
    var cards: Array<Card> = []
    var crossCardCount: Int
    var actionCardCount: Int
    init(crossCardCount: Int, actionCardCount: Int) {
        self.crossCardCount = crossCardCount
        self.actionCardCount = actionCardCount
        
        let directions: Array<String> = ["⬆️","➡️","⬇️","⬅️"]
        
        var id: Int = 0
        
        for _ in 0..<actionCardCount {
            cards.append(Card( cardType: .tool, actionType: actionType.breakAxe, cardContent: "Break Axe",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.breakCart, cardContent: "Break cart",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.breakLamp, cardContent: "Break lamp",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairAxe, cardContent: "Repair Axe",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairCart, cardContent: "Repair Cart",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairLamp, cardContent: "Repair Lamp",id: id) )
            id += 1
        }
        // X-Shape
        for _ in 0..<crossCardCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: directions.joined(separator: ""),
                              sides: Sides(
                                top: pathType.connection,
                                right: pathType.connection,
                                bottom: pathType.connection,
                                left: pathType.connection),
                              id: id))
            id += 1
        }
        cards.shuffle()
    }


    func drawCard() -> Card {
        if self.cards.count != 0 {
            return self.cards.popLast()!
        } else {
            return Card(cardType: cardType.path,id:0)
        }
        
    }
}


struct Card: Hashable {

    var isFaceUp: Bool = true
    var cardType: cardType
    var actionType: actionType!
    var cardContent: String = " "
    var sides: Sides! = Sides()
    var id: Int = 0
}

struct Sides: Hashable {
    var top: pathType = .none
    var right: pathType = .none
    var bottom: pathType = .none
    var left: pathType = .none
}
	
enum pathType {
    case none, connection, blocked
}

enum cardType {
    case gold, coal, tool, action, path, start
}

enum actionType {
    case breakAxe, breakCart, breakLamp, repairAxe, repairCart, repairLamp
}
