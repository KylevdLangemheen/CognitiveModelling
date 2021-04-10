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
    var deadEndCardsCount: Int
    var horizontalLinePathCardsCount: Int
    var tShapedPathCardsCount: Int
    var rightCornerPathCardsCount: Int
    var leftCornerPathCardsCount: Int
    var verticalLinePathCardsCount: Int
    var rotatedTShapedPathCardsCount: Int
    var crossShapedPathCardsCount: Int
    
    
    init(actionCardsCount: Int,
         deadEndCardsCount: Int,
         horizontalLinePathCardsCount: Int,
         tShapedPathCardsCount: Int,
         rightCornerPathCardsCount: Int,
         leftCornerPathCardsCount: Int,
             verticalLinePathCardsCount: Int,
         rotatedTShapedPathCardsCount: Int,
         crossShapedPathCardsCount: Int
    ) {
        self.actionCardsCount = actionCardsCount
        self.deadEndCardsCount = deadEndCardsCount
        self.horizontalLinePathCardsCount = horizontalLinePathCardsCount
        self.tShapedPathCardsCount = tShapedPathCardsCount
        self.rightCornerPathCardsCount = rightCornerPathCardsCount
        self.leftCornerPathCardsCount = leftCornerPathCardsCount
        self.verticalLinePathCardsCount = verticalLinePathCardsCount
        self.rotatedTShapedPathCardsCount = rotatedTShapedPathCardsCount
        self.crossShapedPathCardsCount = crossShapedPathCardsCount


        var id: Int = 1

        for _ in 0..<actionCardsCount {
            cards.append(Card( cardType: .tool, action: Action(actionType: .breakTool, tool: .pickaxe), cardImage: "AC6" ,id: id) )
            id += 1
            cards.append(Card( cardType: .tool, action: Action(actionType: .breakTool, tool: .minecart), cardImage: "AC11",id: id) )
            id += 1
            cards.append(Card( cardType: .tool, action: Action(actionType: .breakTool, tool: .lamp), cardImage: "AC16",id: id) )
            id += 1
            cards.append(Card( cardType: .tool, action: Action(actionType: .repairTool, tool: .pickaxe), cardImage: "AC9",id: id) )
            id += 1
            cards.append(Card( cardType: .tool, action: Action(actionType: .repairTool, tool: .minecart), cardImage: "AC14",id: id) )
            id += 1
            cards.append(Card( cardType: .tool, action: Action(actionType: .repairTool, tool: .lamp), cardImage: "AC19",id: id) )
            id += 1
        }

        // First 9 path cards
        for _ in 0..<deadEndCardsCount {
            cards.append(Card( cardType: cardType.path, cardImage: "PC1",
                         sides: Sides(
                            top: .none,
                            right: .blocked,
                            bottom: .blocked,
                            left: .none),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC2",
                         sides: Sides(
                            top: .none,
                            right: .none,
                            bottom: .blocked,
                            left: .blocked),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC3",
                         sides: Sides(
                            top: .blocked,
                            right: .none,
                            bottom: .blocked,
                            left: .none),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC4",
                         sides: Sides(
                            top: .none,
                            right: .blocked,
                            bottom: .none,
                            left: .none),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC5",
                         sides: Sides(
                            top: .blocked,
                            right: .none,
                            bottom: .none,
                            left: .none),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC6",
                         sides: Sides(
                            top: .blocked,
                            right: .blocked,
                            bottom: .blocked,
                            left: .none),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC7",
                         sides: Sides(
                            top: .blocked,
                            right: .blocked,
                            bottom: .blocked,
                            left: .blocked),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC8",
                         sides: Sides(
                            top: .none,
                            right: .blocked,
                            bottom: .none,
                            left: .blocked),
                         id: id))
            id+=1
            cards.append(Card( cardType: cardType.path, cardImage: "PC9",
                         sides: Sides(
                            top: .blocked,
                            right: .blocked,
                            bottom: .none,
                            left: .blocked),
                         id: id))
            id += 1
        }


        // Horizontal Line path cards
        for _ in 0..<horizontalLinePathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "horizontalLinePC",
                              sides: Sides(
                                top: .none,
                                right: .connection,
                                bottom: .none,
                                left: .connection),
                              id: id))
            id += 1
        }

        // t-shaped Path cards
        for _ in 0..<tShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "tShapedPC",
                              sides: Sides(
                                top: .none,
                                right: .connection,
                                bottom: .connection,
                                left: .connection),
                              id: id))
            id += 1
        }

        // right corner Path cards
        for _ in 0..<rightCornerPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "leftCornerPC",
                              sides: Sides(
                                top: .none,
                                right: .none,
                                bottom: .connection,
                                left: .connection),
                              id: id))
            id += 1
        }

        // left corner Path cards
        for _ in 0..<leftCornerPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "rightCornerPC",
                              sides: Sides(
                                top: .none,
                                right: .connection,
                                bottom: .connection,
                                left: .none),
                              id: id))
            id += 1
        }

        // Vertical Line path cards
        for _ in 0..<verticalLinePathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "verticalLinePC",
                              sides: Sides(
                                top: .connection,
                                right: .none,
                                bottom: .connection,
                                left: .none),
                              id: id))
            id += 1
        }

        // rotated T-shaped Path cards
        for _ in 0..<rotatedTShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "rotTShapedPC",
                              sides: Sides(
                                top: .connection,
                                right: .none,
                                bottom: .connection,
                                left: .connection),
                              id: id))
            id += 1
        }

        //cross shaped path cards
        for _ in 0..<crossShapedPathCardsCount {
            cards.append(Card(cardType: cardType.path,
                              cardImage: "crossShapedPC",
                              sides: Sides(
                                top: .connection,
                                right: .connection,
                                bottom: .connection,
                                left: .connection),
                              id: id))
            id += 1
        }
        cards.shuffle()
    }

    
    func drawCard() -> Card {
        return self.cards.popLast()!
    }
}

struct Card: Hashable {
    var isFaceUp: Bool = true
    var cardType: cardType = .empty
    var action: Action!
    var cardImage: String = " "
    var sides: Sides! = Sides()
    var id: Int = 0
    
}

struct Sides: Hashable {
    var top: pathType = .none
    var right: pathType = .none
    var bottom: pathType = .none
    var left: pathType = .none
}



struct Action: Hashable {
    var actionType: actionType
    var tool: toolType
}


