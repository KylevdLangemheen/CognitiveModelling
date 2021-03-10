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
    var paths: Array<Array<Int>> = [[]]
    var startCell: Cell
    var goalCells: Array<Cell> = []
    var directions: Array<String> = ["top", "right", "bottom", "left"
    ]
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
 
        
        grid = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)
        
        self.startCell = grid[rows-1][columns/2]
        self.goalCells.append(grid[rows-9][columns/2+2])
        self.goalCells.append(grid[rows-9][columns/2-2])
        self.goalCells.append(grid[rows-1][columns/2])
        
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
        
        grid[rows-9][columns/2+2].hasCard = true
        grid[rows-9][columns/2+2].card = goalCards[0]
        grid[rows-9][columns/2+2].cellType = 1
        
        grid[rows-9][columns/2-2].hasCard = true
        grid[rows-9][columns/2-2].card = goalCards[1]
        grid[rows-9][columns/2-2].cellType = 1
        
        grid[rows-9][columns/2].hasCard = true
        grid[rows-9][columns/2].card = goalCards[2]
        grid[rows-9][columns/2].cellType = 1


        grid[rows-1][columns/2].hasCard = true
        grid[rows-1][columns/2].card = Card(isFaceUp: false, cardType: "start", cardConent: "Start", connections: [1,1,1,1], id: 0)
        grid[rows-1][columns/2].cellType = 0
    
    }
    
    func placeCard(cell: Cell, card: Card) -> Bool {
        let cellPos = getCellIndexById(cellId: cell.id)
        
        if validCardPlacement(cellPos: cellPos, directions: card.connections) {
            grid[cellPos[0]][cellPos[1]].card = card
            grid[cellPos[0]][cellPos[1]].hasCard = true
            grid[cellPos[0]][cellPos[1]].cellType = 2
            print("Placed Card")
            return true
        } else {
            print("Did not place card, invalid move")
            return false
        }
    }
    
    func validCardPlacement(cellPos: Array<Int>, directions: Array<Int>) -> Bool {
        let topCell = grid[cellPos[0]-1][cellPos[1]]
        let rightCell = grid[cellPos[0]][cellPos[1]+1]
        let bottomCell = grid[cellPos[0]+1][cellPos[1]]
        let leftCell = grid[cellPos[0]][cellPos[1]-1]
//        let surroundingCells = [topCell,rightCell,bottomCell,leftCell]

        print(directions)
        if directions[0] == 1 {
            if topCell.hasCard {
                if topCell.card.connections[2] == 0 {
                    return false
                }
            }
        } else {
            if topCell.hasCard {
                if !(topCell.card.connections[2] == 0) {
                    return false
                }
            }
        }
        
        if directions[0] == 1 {
            if rightCell.hasCard {
                if rightCell.card.connections[3] == 0 {
                    return false
                }
            }
        } else {
            if rightCell.hasCard {
                if !(rightCell.card.connections[3] == 0) {
                    return false
                }
            }
        }
        
        if directions[2] == 1 {
            if bottomCell.hasCard {
                if bottomCell.card.connections[0] == 0 {
                    return false
                }
            }
        } else {
            if bottomCell.hasCard {
                if !(bottomCell.card.connections[0] == 0) {
                    return false
                }
            }
        }
        
        
        if directions[3] == 1 {
            if leftCell.hasCard {
                if leftCell.card.connections[1] == 0 {
                    return false
                }
            }
        } else {
            if leftCell.hasCard {
                if !(leftCell.card.connections[1] == 0) {
                    return false
                }
            }
        }
        return true
    }
    
    
    func checkGoalPath() {
        
        for goalcell in self.goalCells {
            let neighbours = getNeightbours(cell: goalcell)
            for neighbourIndex in 0..<neighbours.count {
                if neighbours[neighbourIndex].hasCard {
                    switch neighbourIndex {
                        case 0:
                            if neighbours[neighbourIndex].card.connections[2] == 1 {
                                openCard(cell: goalcell)
                                checkCellConnection(cell: goalcell, direction: 2)
                            }
                        case 1:
                            if neighbours[neighbourIndex].card.connections[3] == 1 {
                                openCard(cell: goalcell)
                            }
                        case 2:
                            if neighbours[neighbourIndex].card.connections[0] == 1 {
                                openCard(cell: goalcell)
                            }
                        case 3:
                            if neighbours[neighbourIndex].card.connections[1] == 1 {
                                openCard(cell: goalcell)
                            }
                
                    default:
                        print("something went wrong with checkking goal path")
                    }
                }
            }
        }
    }
    
    func checkCellConnection(cell: Cell, direction: Int) {
        
    }
    
    func openCard(cell: Cell) {
        
    }
//    func updatePath() {
//        var queue: Array<Cell> = []
//        var explored: Array<Cell> = []
//        queue.append(startCell)
//        var currentCell: Cell
//        var currentCellNeighbours: neighBours
//        while queue != [] {
//            currentCell = queue.popLast()!
//            currentCellNeighbours = getNeightbours(cell: currentCell)
//
//            if currentCellNeighbours.top.hasCard {
//                if currentCellNeighbours.top.card.connections[2] == 1 {
//                    queue.append(currentCellNeighbours.top)
//                }
//            }
//
//            if currentCellNeighbours.right.hasCard {
//                if currentCellNeighbours.right.card.connections[3] == 1 {
//                    queue.append(currentCellNeighbours.right)
//                }
//            }
//
//            if currentCellNeighbours.bottom.hasCard {
//                if currentCellNeighbours.bottom.card.connections[0] == 1 {
//                    if
//                    queue.append(currentCellNeighbours.bottom)
//                }
//            }
//
//            if currentCellNeighbours.left.hasCard {
//                if currentCellNeighbours.left.card.connections[1] == 1 {
//                    queue.append(currentCellNeighbours.left)
//                }
//            }
//
//            explored.append(currentCell)
//        }
//
//
//    }
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
    
    func getNeightbours(cell: Cell) -> Array<Cell> {
        let cellPos = getCellIndexById(cellId: cell.id)
        return [grid[cellPos[0]-1][cellPos[0]],
                grid[cellPos[0]][cellPos[0]+1],
                grid[cellPos[0]+1][cellPos[0]],
                grid[cellPos[0]][cellPos[0]-1]]
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

struct neighBours {
    var top: Cell
    var right: Cell
    var bottom: Cell
    var left: Cell
}
