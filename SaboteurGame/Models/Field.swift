//
//  Grid.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 02/03/2021.
//

import Foundation

class Field {
    private var columns: Int
    private var rows: Int
    var grid: Array<Array<Cell>> = [[]]
    private var goalCells: Array<Cell> = []
    private var validCardPlacementCells: Array<Cell> = []
    private var depth: Int = 0
    
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
        grid[rows/2+2][columns-2].hasCard = true
        grid[rows/2+2][columns-2].card = goalCards[0]
        
        grid[rows/2-2][columns-2].hasCard = true
        grid[rows/2-2][columns-2].card = goalCards[1]
        
        grid[rows/2][columns-2].hasCard = true
        grid[rows/2][columns-2].card = goalCards[2]

        // Place start card on the field
        grid[rows/2][columns-10].hasCard = true
        grid[rows/2][columns-10].card = Card(isFaceUp: true, cardType: .start, cardImage: "PC41", sides: Sides(
                                                top: pathType.connection,
                                                right: pathType.connection,
                                                bottom: pathType.connection,
                                                left: pathType.connection), id: 0)
    
        
        // Set goal cells

        self.goalCells.append(grid[rows/2+2][columns-2])
        self.goalCells.append(grid[rows/2-2][columns-2])
        self.goalCells.append(grid[rows/2][columns-2])
        
        validCardPlacementCells.append(grid[rows/2][columns-9])
        validCardPlacementCells.append(grid[rows/2][columns-11])
        validCardPlacementCells.append(grid[rows/2 - 1][columns-10])
        validCardPlacementCells.append(grid[rows/2 + 1][columns-10])

    }
    
    

    func placeCard(cell: Cell, card: Card) -> Bool{
        if validCardPlacement(cell: cell, sides: card.sides) {
            grid[cell.x][cell.y].card = card
            grid[cell.x][cell.y].hasCard = true
            updateValidCardPlacements(cell: cell,card: card)
            if cell.x > depth {
                depth = cell.x
            }
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
            if (neighBours.top.hasCard && (neighBours.top.card.cardType == .path || neighBours.top.card.cardType == .start)) {
                if neighBours.top.card.sides.bottom == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.top.hasCard && (neighBours.top.card.cardType == .path || neighBours.top.card.cardType == .start)) {
                if neighBours.top.card.sides.bottom != pathType.none {
                    return false
                }
            }
        }
        
        if sides.right != .none {
            if (neighBours.right.hasCard && (neighBours.right.card.cardType == .path || neighBours.right.card.cardType == .start)){
                if neighBours.right.card.sides.left == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.right.hasCard && (neighBours.right.card.cardType == .path || neighBours.right.card.cardType == .start)){
                if neighBours.right.card.sides.left != pathType.none {
                    return false
                }
            }
        }
        
        if sides.bottom != .none {
            if (neighBours.bottom.hasCard && (neighBours.bottom.card.cardType == .path || neighBours.bottom.card.cardType == .start)) {
                if neighBours.bottom.card.sides.top == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.bottom.hasCard && (neighBours.bottom.card.cardType == .path || neighBours.bottom.card.cardType == .start)) {
                if neighBours.bottom.card.sides.top != pathType.none {
                    return false
                }
            }
        }
        
        
        if sides.left != .none {
            if (neighBours.left.hasCard && (neighBours.left.card.cardType == .path || neighBours.left.card.cardType == .start)) {
                if neighBours.left.card.sides.right == pathType.none {
                    return false
                }
            }
        } else {
            if (neighBours.left.hasCard && (neighBours.left.card.cardType == .path || neighBours.left.card.cardType == .start)) {
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
                        return true
                    }
                }
            }
            if neighbours.right.hasCard {
                if (neighbours.right.card.sides.left == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        return true
                    }
                }
            }
            if neighbours.bottom.hasCard {
                if (neighbours.bottom.card.sides.top == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
                        return true
                    }
                }
            }
            if neighbours.left.hasCard {
                if (neighbours.left.card.sides.right == .connection) {
                    openCard(cell: goalcell)
                    if goalcell.card.cardType == .gold {
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
        var coopValue: Float = 0.0
        let y = Float(cell.y)
        let neighBours: neighBours = getNeightbours(cell: cell)
        // The further the card in the field, the more impact it will have
        let depthMultiplier = 1 + y/7
        
        // How far is you card compared to the furthest card, thus are you making progress
        // if 1: you stay on the same depth -> progressMuliplier = 1
        // if < 1: you regress -> progresMultiplier = x/depth -> decrease of the coopvalue
        // if > 1: you progress -> ProgressMultiplier = x/depth * 1.5 -> increase of the coopvalue
        var progressMultiplier: Float = 0
        if  y/Float(depth) > 1 {progressMultiplier = y/Float(depth) * 1.5}
        else {progressMultiplier = y/Float(depth)}
        
        let top = card.sides.top
        let right = card.sides.right
        let bottom = card.sides.bottom
        let left = card.sides.left
        
        // **** Dead end connections with neighbours cards ****
        if top == .blocked && (neighBours.top.hasCard && neighBours.top.card.sides.bottom == .connection){coopValue -= 1/2 * depthMultiplier * progressMultiplier} // Blocking a downward path
        if right == .blocked && (neighBours.right.hasCard && neighBours.right.card.sides.left == .connection){coopValue -= 1/4 * depthMultiplier * progressMultiplier} // Blocking a leftward path
        if bottom == .blocked && (neighBours.bottom.hasCard && neighBours.bottom.card.sides.top == .connection){coopValue -= 1/2 * depthMultiplier * progressMultiplier} // Blocking a upward path
        if left == .blocked && (neighBours.left.hasCard && neighBours.left.card.sides.right == .connection){coopValue -= 1.0 * depthMultiplier * progressMultiplier} // Blocking a rightward path

        

        // **** Connections with neighbouring cards ****
        // Connection with card at top cell
        if  (neighBours.top.hasCard && top == .connection && neighBours.top.card.sides.bottom == .connection) {
            if (neighBours.right.hasCard) {
                if neighBours.right.card.sides.left == .connection {coopValue += 1/8} // Connection from top to right path
                else {coopValue -= 1/4}// Connection from top to right dead end
            }else {coopValue += 1 * depthMultiplier * progressMultiplier} // Connection from top to right open field

            if neighBours.bottom.hasCard {
                if neighBours.bottom.card.sides.top == .connection {coopValue += 3/4} // Connection from top to bottom path
                else {coopValue -= 1/2} // Connection from top tor bottom dead end
            } else {coopValue += 3/4} // Connection from top to bottom open field

            if neighBours.left.hasCard {
                if neighBours.left.card.sides.right == .connection {coopValue += 1/8} // Connection from top to left path
                else {coopValue -= 1/4 } // Connection from top to left dead end
            } else {coopValue += 1/8     * depthMultiplier * progressMultiplier} // Connection from top to left open field
        }

        // Path connection with card at right cell
        if (neighBours.right.hasCard && right == .connection && neighBours.right.card.sides.left == .connection) {
            if !neighBours.top.hasCard {coopValue += 1/2 * depthMultiplier * progressMultiplier} // Connection from right to top open field
            if neighBours.bottom.hasCard {
                if neighBours.bottom.card.sides.top == .connection {coopValue += 1/8} // Connection from right to bottom path
                else {coopValue -= 1/2} // Connection from right to bottom dead end
            } else {coopValue += 1/2} // Connection from right to bottom open field

            if neighBours.left.hasCard {
                if neighBours.left.card.sides.right == .connection {coopValue += 3/4} // Connection from left to right path
                else {coopValue -= 1/2} // Connection from left to right dead end
            } else {coopValue += 1 * depthMultiplier * progressMultiplier} // Connection from left to right open field
        }

        // Path connection with card at bottom cell
        if (neighBours.bottom.hasCard && bottom == .connection && neighBours.bottom.card.sides.top  == .connection) {
            if !neighBours.top.hasCard {coopValue += 1/2 * depthMultiplier * progressMultiplier} // Connection from bottom to top open field
            if !neighBours.right.hasCard {coopValue += 3/4 * depthMultiplier * progressMultiplier} // Connectino from bottom to right open field
            if neighBours.left.hasCard {
                if neighBours.left.card.sides.right == .connection {coopValue += 1/8} // Connection from bottom to left path
                else {coopValue -= 1/4} // Connection from bottom to left dead end
            } else {coopValue += 1/8 * depthMultiplier * progressMultiplier} // Connection from bottom to left open field
            
        }
        
        // Path connection with card a the left cell
        if (neighBours.left.hasCard && left == .connection && neighBours.left.card.sides.right == .connection) {
            if !neighBours.top.hasCard {coopValue += 1/2 * depthMultiplier * progressMultiplier} // Connection from left to top open field
            if !neighBours.right.hasCard {coopValue += 1 * depthMultiplier * progressMultiplier} // Connection from left to right open field
            if !neighBours.bottom.hasCard {coopValue += 1/2 * depthMultiplier * progressMultiplier} // Connection from left to bottom open field
        }
    
        return coopValue
    }
}


func createGoalCards() -> Array<Card>{
    var goalCards: Array<Card> = []
    goalCards.append(Card(isFaceUp: false,
                          cardType: cardType.coal,
                          cardImage: "PC43",
                          sides: Sides(
                            top: .connection,
                            right: .none,
                            bottom: .none,
                            left: .connection),
                          id: 0))
    goalCards.append(Card(isFaceUp: false,
                          cardType: cardType.gold,
                          cardImage: "PC42",
                          sides: Sides(
                              top: pathType.connection,
                              right: pathType.connection,
                              bottom: pathType.connection,
                              left: pathType.connection),
                          id: 0))
    goalCards.append(Card(
                        isFaceUp: false,
                        cardType: cardType.coal,
                        cardImage: "PC44",
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



struct cardPlay {
    var playType: playType
    var card: Card!
    var cell: Cell!
    var toPlayer: Player!
    var fromPlayer: Player!
    var coopValue: Float!
}
