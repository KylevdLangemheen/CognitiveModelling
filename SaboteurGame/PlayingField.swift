//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct playingField {
    
    var grid = Array<Array<Cell>>()

    init() {
        // Set size of the grid
        let columns: Int = 5
        let rows: Int = 9
        grid = Array(repeating: Array(repeating: Cell(), count: columns), count: rows)

        
        for rowIdx in 0..<rows {
            for columnIdx in 0..<columns {
                grid[rowIdx][columnIdx].id = columnIdx + rowIdx * columns
            }
        }
        print("\(grid.count)")
        print("\(grid[0].count)")
        var goalCardsIdx: Array<Int> = [0,1,2]
        goalCardsIdx.shuffle()
        
        grid[0][0].hasCard = true
        grid[0][0].cardIdx = goalCardsIdx[0]
        grid[0][2].hasCard = true
        grid[0][2].cardIdx = goalCardsIdx[1]
        grid[0][4].hasCard = true
        grid[0][4].cardIdx = goalCardsIdx[2]
        
        grid[8][2].hasCard = true
        grid[8][2].cardIdx = 3
        
    }
    
    struct Cell: Identifiable, Hashable {
        var hasCard: Bool = false
        var cardIdx: Int = 0
        var id: Int = 0
    }
    
}
