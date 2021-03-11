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
    let numPathCards: Int = 44
    let numActionCards: Int = 27
    let numGoalCards: Int = 3
    let numGoldenNuggetCards: Int = 28
    let numRoleCards: Int = 2
    
    // MARK: Path Cards
    let PC1: Card = Card(cardType: cardType.path,
                   cardContent: "PC1",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                     left: pathType.none),
                   id: 1)
    
    let PC2: Card = Card(cardType: cardType.path,
                   cardContent: "PC2",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                     left: pathType.connection),
                   id: 2)
    
    let PC3: Card = Card(cardType: cardType.path,
                   cardContent: "PC3",
                   sides: Sides(
                     top: pathType.blocked,
                     right: pathType.none,
                     bottom: pathType.blocked,
                     left: pathType.none),
                   id: 3)
    
    let PC4: Card = Card(cardType: cardType.path,
                   cardContent: "PC4",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.blocked,
                     bottom: pathType.none,
                     left: pathType.none),
                   id: 4)
    
    let PC5: Card = Card(cardType: cardType.path,
                   cardContent: "PC5",
                   sides: Sides(
                     top: pathType.blocked,
                     right: pathType.none,
                     bottom: pathType.none,
                     left: pathType.none),
                   id: 5)
    
    let PC6: Card = Card(cardType: cardType.path,
                   cardContent: "PC6",
                   sides: Sides(
                     top: pathType.blocked,
                     right: pathType.blocked,
                     bottom: pathType.blocked,
                    left: pathType.none),
                   id: 6)
    
    let PC7: Card = Card(cardType: cardType.path,
                   cardContent: "PC7",
                   sides: Sides(
                     top: pathType.blocked,
                     right: pathType.blocked,
                     bottom: pathType.blocked,
                    left: pathType.blocked),
                   id: 7)
    
    let PC8: Card = Card(cardType: cardType.path,
                   cardContent: "PC8",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.blocked,
                     bottom: pathType.none,
                    left: pathType.blocked),
                   id: 8)
    
    let PC9: Card = Card(cardType: cardType.path,
                   cardContent: "PC9",
                   sides: Sides(
                     top: pathType.blocked,
                     right: pathType.blocked,
                     bottom: pathType.none,
                    left: pathType.blocked),
                   id: 9)
    
    let PC10: Card = Card(cardType: cardType.path,
                   cardContent: "PC10",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.none,
                    left: pathType.connection),
                   id: 10)
    
    let PC11: Card = Card(cardType: cardType.path,
                   cardContent: "PC11",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.none,
                    left: pathType.connection),
                   id: 11)
    
    let PC12: Card = Card(cardType: cardType.path,
                   cardContent: "PC12",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.none,
                    left: pathType.connection),
                   id: 12)
    
    let PC13: Card = Card(cardType: cardType.path,
                   cardContent: "PC13",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 13)
    
    let PC14: Card = Card(cardType: cardType.path,
                   cardContent: "PC14",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 14)
    
    let PC15: Card = Card(cardType: cardType.path,
                   cardContent: "PC15",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 15)
    
    let PC16: Card = Card(cardType: cardType.path,
                   cardContent: "PC16",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 16)
    
    let PC17: Card = Card(cardType: cardType.path,
                   cardContent: "PC17",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 17)
    
    let PC18: Card = Card(cardType: cardType.path,
                   cardContent: "PC18",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 18)
    
    let PC19: Card = Card(cardType: cardType.path,
                   cardContent: "PC19",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 19)
    
    let PC20: Card = Card(cardType: cardType.path,
                   cardContent: "PC20",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 20)
    
    let PC21: Card = Card(cardType: cardType.path,
                   cardContent: "PC21",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 21)
    
    let PC22: Card = Card(cardType: cardType.path,
                   cardContent: "PC22",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 22)
    
    let PC23: Card = Card(cardType: cardType.path,
                   cardContent: "PC23",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 23)
    
    let PC24: Card = Card(cardType: cardType.path,
                   cardContent: "PC24",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 24)
    
    let PC25: Card = Card(cardType: cardType.path,
                   cardContent: "PC25",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 25)
    
    let PC26: Card = Card(cardType: cardType.path,
                   cardContent: "PC26",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 26)
    
    let PC27: Card = Card(cardType: cardType.path,
                   cardContent: "PC26",
                   sides: Sides(
                     top: pathType.connection,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 26)
    
    let PC28: Card = Card(cardType: cardType.path,
                   cardContent: "PC26",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.none),
                   id: 26)
    
    let PC29: Card = Card(cardType: cardType.path,
                   cardContent: "PC26",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.none),
                   id: 26)
    
    let PC30: Card = Card(cardType: cardType.path,
                   cardContent: "PC30",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.none),
                   id: 30)
    
    let PC31: Card = Card(cardType: cardType.path,
                   cardContent: "PC31",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 31)
    
    let PC32: Card = Card(cardType: cardType.path,
                   cardContent: "PC32",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 32)
    
    let PC33: Card = Card(cardType: cardType.path,
                   cardContent: "PC33",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 33)
    
    let PC34: Card = Card(cardType: cardType.path,
                   cardContent: "PC34",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 34)
    
    let PC35: Card = Card(cardType: cardType.path,
                   cardContent: "PC35",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.none,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 35)
    
    let PC36: Card = Card(cardType: cardType.path,
                   cardContent: "PC36",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.connection,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 36)
    
    let PC37: Card = Card(cardType: cardType.path,
                   cardContent: "PC37",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.connection,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 37)
    
    let PC38: Card = Card(cardType: cardType.path,
                   cardContent: "PC38",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.connection,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 38)
    
    let PC39: Card = Card(cardType: cardType.path,
                   cardContent: "PC39",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.connection,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 39)
    
    let PC40: Card = Card(cardType: cardType.path,
                   cardContent: "PC40",
                   sides: Sides(
                    top: pathType.connection,
                    right: pathType.connection,
                    bottom: pathType.connection,
                   left: pathType.connection),
                   id: 40)
    
    let PC41: Card = Card(cardType: cardType.path,
                   cardContent: "PC41",
                   sides: Sides(
                     top: pathType.connection,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 41)
    
    let PC42: Card = Card(cardType: cardType.goal,
                   cardContent: "PC42",
                   sides: Sides(
                     top: pathType.connection,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 42)
    
    let PC43: Card = Card(cardType: cardType.goal,
                   cardContent: "PC43",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.connection,
                     bottom: pathType.connection,
                    left: pathType.none),
                   id: 43)
    
    let PC44: Card = Card(cardType: cardType.goal,
                   cardContent: "PC44",
                   sides: Sides(
                     top: pathType.none,
                     right: pathType.none,
                     bottom: pathType.connection,
                    left: pathType.connection),
                   id: 44)
       
    
    
    init(directionCount: Int, crossCardCount: Int) {
        self.directionCount = directionCount
        self.crossCardCount = crossCardCount       
        
       
        
                
        let directions: Array<String> = ["⬆️","➡️","⬇️","⬅️"]
        
        var id: Int = 0
        
        // Corners
//        for start in 0..<directionCount {
//            for end in start+1..<directionCount {
//                var newCard = Card(cardType: "path",id: id)
//                newCard.connections[start] = 1
//                newCard.connections[end] = 1
//                let newDirections = [directions[start],directions[end]]
//                newCard.cardContent = newDirections.joined(separator: "")
//                cards.append(newCard)
//                id += 1
//            }
//        }
//
//        // T-Shape
//        for closed in 0..<directionCount {
//            var newCard = Card(cardType: cardType.path,
//                               connections: connections(
//                                 top: pathType.connection,
//                                 right: pathType.connection,
//                                 bottom: pathType.connection,
//                                 left: pathType.connection),
//                               id: id)
//            newCard.connections = 0
//            var newDirections = directions
//            newDirections.remove(at: closed)
//            newCard.cardContent = newDirections.joined(separator: "")
//            cards.append(newCard)
//            id += 1
//        }
        
        // X-Shape
//        for _ in 0..<crossCardCount {
//            cards.append(Card(cardType: cardType.path,
//                              cardContent: directions.joined(separator: ""),
//                              sides: Sides(
//                                top: pathType.connection,
//                                right: pathType.connection,
//                                bottom: pathType.connection,
//                                left: pathType.connection),
//                              id: id))
//            id += 1
//        }
        
        cards.append(PC1) //TODO: Append all action and oath cards
        print("\(cards)")
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
    var cardContent: String = " "
    var sides: Sides = Sides()
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
    case goal, action, path, start, role
}
