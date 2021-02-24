//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct playingField {
    var grid: Array<Cell>
    var columns = 5
    var rows = 9
    
//    func choose(card: Card) {
//        print("Card chosen: \(card.cardConent)")
//    }
    
    init() {
        grid = Array<Cell>()
        for columnIdx in 0...columns {
            for rowIdx in 0...rows {
                grid.append(Cell(pos: [columnIdx,rowIdx], id: columnIdx + rowIdx * columns))
            }
        }
        var goalCardsIdx: Array<Int> = [0,1,2]
        goalCardsIdx.shuffle()
        
        grid[44].hasCard = true
        grid[44].cardIdx = goalCardsIdx[0]
        grid[42].hasCard = true
        grid[42].cardIdx = goalCardsIdx[1]
        grid[40].hasCard = true
        grid[40].cardIdx = goalCardsIdx[2]
        
        grid[2].hasCard = true
        grid[2].cardIdx = 3
        
    }
    
    struct Cell: Identifiable, Hashable {
        var hasCard: Bool = false
        var cardIdx: Int = 0
        var pos: Array<Int>
        var id: Int
    }
    
//    struct Card {
//        var isFaceUp: Bool = true
//        var cardType: Int = 0
//        var cardConent: String
//        var id: Int
//    }
}
