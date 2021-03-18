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
    var validCardPlacementCells: Array<Cell> = []
    
    init(columns: Int, rows: Int) {
        
        // Initialize field
        self.columns = columns
        self.rows = rows
 
        grid = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)
        
        for rowIdx in 0..<rows {
            for columnIdx in 0..<columns {
                grid[rowIdx][columnIdx] = Cell(x: rowIdx, y: columnIdx,id: columnIdx + rowIdx * columns)
                
            }
        }
        
        // Set Goal cards
        let goalCards: Array<Card> = createGoalCards()
        
        // Place goal cards on the field
        grid[rows-9][columns/2+2].hasCard = true
        grid[rows-9][columns/2+2].card = goalCards[0]
        
        grid[rows-9][columns/2-2].hasCard = true
        grid[rows-9][columns/2-2].card = goalCards[1]
        
        grid[rows-9][columns/2].hasCard = true
        grid[rows-9][columns/2].card = goalCards[2]

        // Place start card on the field
        grid[rows-1][columns/2].hasCard = true
        grid[rows-1][columns/2].card = Card(isFaceUp: true, cardType: .start, cardContent: "Start", sides: Sides(
                                                top: pathType.connection,
                                                right: pathType.connection,
                                                bottom: pathType.connection,
                                                left: pathType.connection), id: 0)
    
        
        // Set goal cells
        self.startCell = grid[rows-1][columns/2]
        self.goalCells.append(grid[rows-9][columns/2+2])
        self.goalCells.append(grid[rows-9][columns/2-2])
        self.goalCells.append(grid[rows-9][columns/2])
        
        validCardPlacementCells.append(grid[rows-2][columns/2])
        validCardPlacementCells.append(grid[rows-1][columns/2 - 1])
        validCardPlacementCells.append(grid[rows-1][columns/2 + 1])

    }
    
    

    func placeCard(cell: Cell, card: Card) -> Bool {
        if validCardPlacement(cell: cell, sides: card.sides) {
            grid[cell.x][cell.y].card = card
            grid[cell.x][cell.y].hasCard = true
            updateValidCardPlacements(cell: cell,card: card)
//            print("Placed Card at cell \(cell.id)")
            return true
        } else {
            print("Did not place card, invalid move")
            return false
        }
    }
    
    func removeCellFromValidCardPlacements(cell: Cell) {
        for validCellIdx in 0..<validCardPlacementCells.count{
            if cell.id == validCardPlacementCells[validCellIdx].id {
                validCardPlacementCells.remove(at: validCellIdx)
                return
            }
        }
    }
    
    func updateValidCardPlacements(cell: Cell, card: Card){
        removeCellFromValidCardPlacements(cell: cell)
        
        let neighBours = getNeightbours(cell: cell)
        if card.sides.top == .connection {
            if !validCardPlacementCells.contains(neighBours.top){
                if !neighBours.top.hasCard{
                    validCardPlacementCells.append(neighBours.top)
                }
            }
        }
        
        if card.sides.right == .connection {
            if !validCardPlacementCells.contains(neighBours.right){
                if !neighBours.right.hasCard{
                    validCardPlacementCells.append(neighBours.right)
                }
            }
        }
        if card.sides.bottom == .connection {
            if !validCardPlacementCells.contains(neighBours.bottom){
                if !neighBours.bottom.hasCard{
                    validCardPlacementCells.append(neighBours.bottom)
                }
            }
        }
        if card.sides.left == .connection {
            if !validCardPlacementCells.contains(neighBours.left){
                if !neighBours.left.hasCard{
                    validCardPlacementCells.append(neighBours.left)
                }
            }
        }
    }
    
    func isCellValid(cell: Cell) -> Bool{
        for validCell in validCardPlacementCells{
            if cell.id == validCell.id {
                return true
            }
        }
        return false
    }
    
    func validCardPlacement(cell: Cell, sides: Sides) -> Bool {
        let neighBours = getNeightbours(cell: cell)
        
        if !isCellValid(cell: cell){
            return false
        }
        
        if (!neighBours.top.hasCard && !neighBours.right.hasCard && !neighBours.bottom.hasCard && !neighBours.left.hasCard) {
            return false
        }
        
        
        if sides.top != .none {
            if neighBours.top.hasCard {
                if neighBours.top.card.cardType == .path {
                    if neighBours.top.card.sides.bottom == pathType.none {
                        return false
                    }
                } 
            }
        } else {
            if (neighBours.top.hasCard && (neighBours.top.card.cardType == .path)) {
                if neighBours.top.card.sides.bottom != pathType.none {
                    return false
                }
            }
        }
        
        if sides.right != .none {
            if (neighBours.right.hasCard && (neighBours.right.card.cardType == .path)){
                if neighBours.right.card.sides.left == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.right.hasCard && (neighBours.right.card.cardType == .path)){
                if neighBours.right.card.sides.left != pathType.none {
                    return false
                }
            }
        }
        
        if sides.bottom != .none {
            if (neighBours.bottom.hasCard && (neighBours.bottom.card.cardType == .path)) {
                if neighBours.bottom.card.sides.top == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.bottom.hasCard && (neighBours.bottom.card.cardType == .path)) {
                if neighBours.bottom.card.sides.top != pathType.none {
                    return false
                }
            }
        }
        
        
        if sides.left != .none {
            if (neighBours.left.hasCard && (neighBours.left.card.cardType == .path)) {
                if neighBours.left.card.sides.right == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.left.hasCard && (neighBours.left.card.cardType == .path)) {
                if neighBours.left.card.sides.right != pathType.none {
                    return false
                }
            }
        }
        return true
    }
    
    
    func checkGoalPath() -> Bool{
        for goalcell in self.goalCells {
            let neighbours = getNeightbours(cell: goalcell)
            
            if neighbours.top.hasCard{
                if (neighbours.top.card.sides.bottom == .connection){
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        print ("Miners won!")
                        return true
                    }
                }
            }
            if neighbours.right.hasCard {
                if (neighbours.right.card.sides.left == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        print ("Miners won!")
                        return true
                    }
                }
            }
            if neighbours.bottom.hasCard {
                if (neighbours.bottom.card.sides.top == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        print ("Miners won!")
                        return true
                    }
                }
            }
            if neighbours.left.hasCard {
                if (neighbours.left.card.sides.right == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        print ("Miners won!")
                        return true
                    }
                }
            }
        }
        return false
    }


    func getNeightbours(cell: Cell) -> neighBours {
        var top, right, bottom, left: Cell
        if cell.x-1 >= 0{
            top = grid[cell.x-1][cell.y]
            
        } else {
            top = Cell()
        }
        
        if cell.y+1 < columns {
            right = grid[cell.x][cell.y+1]
        } else {
            right = Cell()
        }
        
        if cell.x+1 < rows {
            bottom = grid[cell.x+1][cell.y]
        } else {
            bottom = Cell()
        }
        
        if cell.y-1 >= 0 {
            left = grid[cell.x][cell.y-1]
        } else {
            left = Cell()
        }
        
        return neighBours(
            top: top,
            right: right,
            bottom: bottom,
            left: left)
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
    
    
    
    func getPosiblePathPlays(card: Card) ->  Array<cardPlay> {
        var possiblePlays: Array<cardPlay> = []
        for rowIdx in 0..<rows {
            for columnIdx in 0..<columns {
                if validCardPlacement(cell: grid[rowIdx][columnIdx], sides: card.sides) {
                    possiblePlays.append(cardPlay(playType: .placeCard,
                                                  card: card,
                                                  cell: grid[rowIdx][columnIdx],
                                                  coopValue: getCoopValue(card: card, cell: grid[rowIdx][columnIdx])))
                }
            }
        }
        return possiblePlays
    }
    
    func getCoopValue(card: Card, cell: Cell) -> Float{
        return 1.0
//        neighbours = getNeightbours(cell)
        
    }
}


func createGoalCards() -> Array<Card>{
    var goalCards: Array<Card> = []
    goalCards.append(Card(isFaceUp: false,
                          cardType: cardType.coal,
                          cardContent: "⚫️",
                          sides: Sides(
                            top: .connection,
                            right: .connection,
                            bottom: .none,
                            left: .none),
                          id: 0))
    goalCards.append(Card(isFaceUp: false,
                          cardType: cardType.gold,
                          cardContent: "💎",
                          sides: Sides(
                              top: pathType.connection,
                              right: pathType.connection,
                              bottom: pathType.connection,
                              left: pathType.connection),
                          id: 0))
    goalCards.append(Card(
                        isFaceUp: false,
                        cardType: cardType.coal,
                        cardContent: "⚫️",
                        sides: Sides(
                            top: .none,
                            right: .none,
                            bottom: .connection,
                            left: .connection)
                        ,id: 0))
    
    goalCards.shuffle()
    return goalCards
}

struct Cell: Hashable, Identifiable {
    var hasCard: Bool = false
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

struct cardPlay {
    var playType: playType
    var card: Card
    var cell: Cell!
    var player: Player!
    var coopValue: Float
}

// After playing path card update model accordingly Player number ("one", "two" ..) and calculated role ("unknown, "saboteur", "miner")
// After playing action cards update model differently
// Switch
