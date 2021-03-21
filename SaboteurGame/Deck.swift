//
//  Deck.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 01/03/2021.
//

import Foundation



class Deck {
    var cards: Array<Card> = []
    var actionCardsCount: Int
    var firstNinePathCardsCount: Int
    var horizontalLinePathCardsCount: Int
    var tShapedPathCardsCount: Int
    var rightCornerPathCardsCount: Int
    var leftCornerPathCardsCount: Int
    var verticalLinePathCardsCount: Int
    var rotatedTShapedPathCardsCount: Int
    var crossShapedPathCardsCount: Int
    init(actionCardsCount: Int,
         firstNinePathCardsCount: Int,
         horizontalLinePathCardsCount: Int,         
         tShapedPathCardsCount: Int,
         rightCornerPathCardsCount: Int,
         leftCornerPathCardsCount: Int,
         verticalLinePathCardsCount: Int,
         rotatedTShapedPathCardsCount: Int,
         crossShapedPathCardsCount: Int
    ) {
        self.actionCardsCount = actionCardsCount
        self.firstNinePathCardsCount = firstNinePathCardsCount
        self.horizontalLinePathCardsCount = horizontalLinePathCardsCount
        self.tShapedPathCardsCount = tShapedPathCardsCount
        self.rightCornerPathCardsCount = rightCornerPathCardsCount
        self.leftCornerPathCardsCount = leftCornerPathCardsCount
        self.verticalLinePathCardsCount = verticalLinePathCardsCount        
        self.rotatedTShapedPathCardsCount = rotatedTShapedPathCardsCount
        self.crossShapedPathCardsCount = crossShapedPathCardsCount
//        let directions: Array<String> = ["⬆️","➡️","⬇️","⬅️"]
        
        var id: Int = 0
        
        for _ in 0..<actionCardsCount {
            cards.append(Card( cardType: .tool, actionType: actionType.breakAxe, cardContent: "Break Axe",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.breakCart, cardContent: "Break cart",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.breakLamp, cardContent: "Break lamp",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairAxe, cardContent: "Repair Axe",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairCart, cardContent: "Repair Cart",id: id) )
            cards.append(Card( cardType: .tool, actionType: actionType.repairLamp, cardContent: "Repair Lamp",id: id) )
            id += 1
        }
        
        // First 9 path cards
        for _ in 0..<firstNinePathCardsCount {
            cards.append(Card( cardType: cardType.path, cardContent: "PC1",
                         sides: Sides(
                            top: pathType.none,
                            right: pathType.connection,
                            bottom: pathType.connection,
                            left: pathType.none),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC2",
                         sides: Sides(
                            top: pathType.none,
                            right: pathType.none,
                            bottom: pathType.connection,
                            left: pathType.connection),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC3",
                         sides: Sides(
                            top: pathType.blocked,
                            right: pathType.none,
                            bottom: pathType.blocked,
                            left: pathType.none),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC4",
                         sides: Sides(
                            top: pathType.none,
                            right: pathType.blocked,
                            bottom: pathType.none,
                            left: pathType.none),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC5",
                         sides: Sides(
                            top: pathType.blocked,
                            right: pathType.none,
                            bottom: pathType.none,
                            left: pathType.none),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC6",
                         sides: Sides(
                            top: pathType.blocked,
                            right: pathType.blocked,
                            bottom: pathType.blocked,
                            left: pathType.none),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC7",
                         sides: Sides(
                            top: pathType.blocked,
                            right: pathType.blocked,
                            bottom: pathType.blocked,
                            left: pathType.blocked),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC8",
                         sides: Sides(
                            top: pathType.none,
                            right: pathType.blocked,
                            bottom: pathType.none,
                            left: pathType.blocked),
                         id: id))
            cards.append(Card( cardType: cardType.path, cardContent: "PC9",
                         sides: Sides(
                            top: pathType.blocked,
                            right: pathType.blocked,
                            bottom: pathType.none,
                            left: pathType.blocked),
                         id: id))
            id += 1
        }
        
              
        // Horizontal Line path cards
        for _ in 0..<horizontalLinePathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "horizontalLinePC",
                              sides: Sides(
                                top: pathType.none,
                                right: pathType.connection,
                                bottom: pathType.none,
                                left: pathType.connection),
                              id: id))
            id += 1
        }
    
        // t-shaped Path cards
        for _ in 0..<tShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "tShapedPC",
                              sides: Sides(
                                top: pathType.none,
                                right: pathType.connection,
                                bottom: pathType.connection,
                                left: pathType.connection),
                              id: id))
            id += 1
        }
        
        // right corner Path cards
        for _ in 0..<rightCornerPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "rightCornerPC",
                              sides: Sides(
                                top: pathType.none,
                                right: pathType.none,
                                bottom: pathType.connection,
                                left: pathType.connection),
                              id: id))
            id += 1
        }
        
        // left corner Path cards
        for _ in 0..<leftCornerPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "leftCornerPC",
                              sides: Sides(
                                top: pathType.none,
                                right: pathType.connection,
                                bottom: pathType.connection,
                                left: pathType.none),
                              id: id))
            id += 1
        }
              
        // Vertical Line path cards
        for _ in 0..<verticalLinePathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "verticalLinePC",
                              sides: Sides(
                                top: pathType.connection,
                                right: pathType.none,
                                bottom: pathType.connection,
                                left: pathType.none),
                              id: id))
            id += 1
        }
        
        // rotated T-shaped Path cards
        for _ in 0..<rotatedTShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "rotTShapedPC",
                              sides: Sides(
                                top: pathType.connection,
                                right: pathType.none,
                                bottom: pathType.connection,
                                left: pathType.connection),
                              id: id))
            id += 1
        }
        
        //cross shaped path cards
        for _ in 0..<crossShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardContent: "crossShapedPC",
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
    case gold, goal, tool, action, path, start
}

enum actionType {
    case breakAxe, breakCart, breakLamp, repairAxe, repairCart, repairLamp
}
