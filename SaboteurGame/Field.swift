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
    var directions: Array<String> = ["top", "right", "bottom", "left"]
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
 
        grid = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)
        
        for rowIdx in 0..<rows {
            for columnIdx in 0..<columns {
                grid[rowIdx][columnIdx] = Cell(x: rowIdx, y: columnIdx,id: columnIdx + rowIdx * columns)
                
            }
        }
        
        var goalCards: Array<Card> = []
        goalCards.append(Card(isFaceUp: false, cardType: cardType.goal, cardContent: "⚫️", sides: Sides(top: .connection, right: .connection, bottom: .none, left: .none), id: 0))
        goalCards.append(Card(isFaceUp: false, cardType: cardType.goal, cardContent: "💎", sides: Sides(
                              top: pathType.connection,
                              right: pathType.connection,
                              bottom: pathType.connection,
                              left: pathType.connection),id: 0))
        goalCards.append(Card(isFaceUp: false, cardType: cardType.goal, cardContent: "⚫️", sides: Sides(top: .none, right: .none, bottom: .connection, left: .connection),id: 0))
        goalCards.shuffle()
        
        grid[rows-9][columns/2+2].hasCard = true
        grid[rows-9][columns/2+2].card = goalCards[0]
        grid[rows-9][columns/2+2].cellType = cardType.goal
        
        grid[rows-9][columns/2-2].hasCard = true
        grid[rows-9][columns/2-2].card = goalCards[1]
        grid[rows-9][columns/2-2].cellType = cardType.goal
        
        grid[rows-9][columns/2].hasCard = true
        grid[rows-9][columns/2].card = goalCards[2]
        grid[rows-9][columns/2].cellType = cardType.goal

        grid[rows-1][columns/2].hasCard = true
        grid[rows-1][columns/2].card = Card(isFaceUp: true, cardType: .goal, cardContent: "Start", sides: Sides(
                                                top: pathType.connection,
                                                right: pathType.connection,
                                                bottom: pathType.connection,
                                                left: pathType.connection), id: 0)
        grid[rows-1][columns/2].cellType = cardType.goal
    
        
        self.startCell = grid[rows-1][columns/2]
        self.goalCells.append(grid[rows-9][columns/2+2])
        self.goalCells.append(grid[rows-9][columns/2-2])
        self.goalCells.append(grid[rows-9][columns/2])
    }
    
    func placeCard(cell: Cell, card: Card) -> Bool {
        
        if validCardPlacement(x:cell.x,y: cell.y, sides: card.sides) {
            grid[cell.x][cell.y].card = card
            grid[cell.x][cell.y].hasCard = true
            grid[cell.x][cell.y].cellType = cardType.path
//            checkGoalPath()
            print("Placed Card")
            return true
        } else {
            print("Did not place card, invalid move")
            return false
        }
    }
    
    func validCardPlacement(x: Int, y: Int, sides: Sides) -> Bool {

        let topCell = grid[x-1][y]
        let rightCell = grid[x][y+1]
        let bottomCell = grid[x+1][y]
        let leftCell = grid[x][y-1]
//        let surroundingCells = [topCell,rightCell,bottomCell,leftCell]
        
        if (!topCell.hasCard && !rightCell.hasCard && !bottomCell.hasCard && !leftCell.hasCard){
            return false
        }
        
        if sides.top != .none {
            if topCell.hasCard {
                if topCell.card.sides.bottom == pathType.none {
                    return false
                }
            }
        } else {
            if topCell.hasCard {
                if topCell.card.sides.bottom != pathType.none {
                    return false
                }
            }
        }
        
        if sides.right != .none {
            if rightCell.hasCard {
                if rightCell.card.sides.left == pathType.none {
                    return false
                }
            }
        } else {
            if rightCell.hasCard {
                if rightCell.card.sides.left != pathType.none {
                    return false
                }
            }
        }
        
        if sides.bottom != .none {
            if bottomCell.hasCard {
                if bottomCell.card.sides.top == pathType.none {
                    return false
                }
            }
        } else {
            if bottomCell.hasCard {
                if bottomCell.card.sides.top != pathType.none {
                    return false
                }
            }
        }
        
        
        if sides.left != .none {
            if leftCell.hasCard {
                if leftCell.card.sides.right == pathType.none {
                    return false
                }
            }
        } else {
            if leftCell.hasCard {
                if leftCell.card.sides.right != pathType.none {
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
                    openCard(cell: goalcell)
                    print("opening card")
                    switch neighbourIndex {
                        case 0:
                            if neighbours[neighbourIndex].card.sides.bottom == pathType.connection {
                                if checkCellConnection(cell: goalcell, side: side.bottom) {
                                    print("Connection between path and goal card")
                                }
                            }
                        case 1:
                            if neighbours[neighbourIndex].card.sides.left == pathType.connection {
                                if checkCellConnection(cell: goalcell, side: side.left) {
                                    print("Connection between path and goal card")
                                }
                            }
                        case 2:
                            if neighbours[neighbourIndex].card.sides.top == pathType.connection {
                                if checkCellConnection(cell: goalcell, side: side.top) {
                                    print("Connection between path and goal card")
                                }
                            }
                        case 3:
                            if neighbours[neighbourIndex].card.sides.right == pathType.connection {
                                if checkCellConnection(cell: goalcell, side: side.right) {
                                    print("Connection between path and goal card")
                                }
                            }
                
                    default:
                        print("something went wrong with checkking goal path")
                    }
                }
            }
        }
    }


    func getNeightbours(cell: Cell) -> Array<Cell> {
        return [grid[cell.x-1][cell.y],
                grid[cell.x][cell.y+1],
                grid[cell.x+1][cell.y],
                grid[cell.x][cell.y-1]]
    }
    
    func openCard(cell: Cell) {
        grid[cell.x][cell.y].card.isFaceUp = true
    }
    
    func checkCellConnection(cell: Cell, side: side) -> Bool{
        switch side{
        case .top:
            if cell.card.sides.top != pathType.none {
                return true
            }
        case .right:
            if cell.card.sides.right != pathType.none  {
                return true
            }
        case .bottom:
            if cell.card.sides.bottom != pathType.none {
                return true
            }
        case .left:
            if cell.card.sides.left != pathType.none {
                return true
            }
        }
        return false
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
//    print("Placed card \(card.cardContent)")
//}

struct Cell: Hashable, Identifiable {
    
    var hasCard: Bool = false
    var cellType: cardType!
    var card: Card!
    var x: Int = 0
    var y: Int = 0
    var id: Int = 0
}


struct neighBours {
    var top: Cell
    var right: Cell
    var bottom: Cell
    var left: Cell
}

enum side {
    case top, right, bottom, left
}
