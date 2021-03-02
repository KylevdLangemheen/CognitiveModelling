//
//  Grid.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/03/2021.
//

import Foundation

class Field {
    var columns: Int
    var rows: Int
    var grid: Array<Array<Cell>> = [[]]
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        grid = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)
        
        for rowIdx in 0..<rows {
            for columnIdx in 0..<columns {
                grid[rowIdx][columnIdx].id = columnIdx + rowIdx * columns
            }
        }
        
        var goalCards: Array<Card> = []
        goalCards.append(Card(isFaceUp: true, cardType: "coal", cardConent: "⚫️", connections: [1,1,0,0], id: 0))
        goalCards.append(Card(isFaceUp: true, cardType: "coal", cardConent: "💎",connections: [1,1,1,1],id: 0))
        goalCards.append(Card(isFaceUp: true, cardType: "gold", cardConent: "⚫️", connections: [0,1,1,0],id: 0))
        goalCards.shuffle()
        
        grid[0][0].hasCard = true
        grid[0][0].card = goalCards[0]
        grid[0][0].cellType = 1
        grid[0][2].hasCard = true
        grid[0][2].card = goalCards[1]
        grid[0][2].cellType = 1
        grid[0][4].hasCard = true
        grid[0][4].card = goalCards[2]
        grid[0][4].cellType = 1


        grid[8][2].hasCard = true
        grid[8][2].card = Card(isFaceUp: false, cardType: "start", cardConent: "Start", connections: [1,1,1,1], id: 0)
        grid[8][2].cellType = 0
    
    }
    
    func placeCard(cell: Cell, card: Card) {
        let cellPos = getCellIndexById(cellId: cell.id)
        grid[cellPos[0]][cellPos[1]].card = card
        grid[cellPos[0]][cellPos[1]].hasCard = true
        grid[cellPos[0]][cellPos[1]].cellType = 2
        print("Placed Card")
    }
    
    func getCellIndexById(cellId: Int) -> Array<Int> {
        for row in 0..<self.rows {
            for column in 0..<self.columns {
                if grid[row][column].id == cellId {
                    return [row,column]
                }
            }
        }
        return [0,0]
    }
}
    

//mutating func placeCard(cell: Cell, card: Card) {
//    let row: Int = cell.id / columns
//    let column: Int = cell.id % columns
//    let card = currentPlayer.hand[0]
//    grid[row][column].hasCard = true
//    grid[row][column].card = card
//    currentPlayer.status = "waiting"
//    currentPlayer.hand[0] = deck.cards.popLast()!
//    print("Placed card \(card.cardConent)")
//}

struct Cell: Hashable, Identifiable {
    var hasCard: Bool = false
    var cellType: Int! // 0 for start, 1 for goal, 2 for path card
    var card: Card!
    var id: Int = 0
}
