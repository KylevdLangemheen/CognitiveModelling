//
//  playingField.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 17/02/2021.
//

import Foundation

struct Game {
    
    var grid: Array<Array<Cell>> = [[]]
    var playDeck: Array<Card> = []
    var path: Array<Array<Int>> = []
    var staticDeck: Array<Card> = []
    var currentDeck: Array<Int> = []
    var players: Array<Player> = []
    var currentPlayer: Player = Player()
    
    
    let columns: Int = 5
    let rows: Int = 9
    let actionCardQty: Int = 4
    let qtyPerPathCard: Int = 8
    let actionCards: Array<String> = ["collapse"]
    let directionCount: Int = 4
    let crossCardCount: Int = 4
    let playerCount: Int = 1
    let handSize: Int = 1
    let directions: Array<String> = ["⬆️","➡️","⬇️","⬅️"]
    
    init() {
        createGrid()
        createDeck()
        createPlayers()
        currentPlayer = players[0]
        
    }
    

    mutating func createPlayers() {
        var roles: Array<String> = Array(repeating: "Miner", count: playerCount) + Array(repeating: "Saboteur", count: playerCount-1)
        roles.shuffle()
        
        for id in 0..<playerCount {
            var cards: Array<Int> = []
            for _ in 0..<handSize {
                cards.append(currentDeck.popLast()!)
            }
            players.append(Player(role: roles[id], cards: cards, id: id))
        }
        
    }
    
    mutating func changeStatus(status: String) {
        currentPlayer.status = status
        print("Status: \(status)")
    }
    
    func getCard(cell: Cell) -> Card {
        
        if cell.cellType == 1 {
            return playDeck[cell.cardIdx]
            
        } else{
            return staticDeck[cell.cardIdx]
        }
    }
    
    mutating func flip(card: Card) {
        let chosenIndex: Int = card.id
        playDeck[chosenIndex].isFaceUp = !playDeck[chosenIndex].isFaceUp
    }
    
    
    mutating func placeCard(cell: Cell) {
        let row: Int = cell.id / columns
        let column: Int = cell.id % columns
        let id = currentPlayer.cards[0]
        grid[row][column].hasCard = true
        grid[row][column].cardIdx = id
        currentPlayer.status = "waiting"
        currentPlayer.cards[0] = currentDeck.popLast()!
        print("Placed card \(id)")
    }
    
    
    mutating func createDeck() {
        var id: Int = 0
        staticDeck.append(Card(cardType: "goal", cardConent: "💎", id: id))
        id += 1
        staticDeck.append(Card(cardType: "goal", cardConent: "⚫️", id: id))
        id += 1
        staticDeck.append(Card(cardType: "goal", cardConent: "⚫️", id: id))
        id += 1
        
        staticDeck.append(Card(cardType: "start", cardConent: "Start", id: id))
        id += 1
        
//        for _ in 0..<actionCardQty {
//            playDeck.append(Card(cardType: "action" , cardConent: "Collapse", id:id))
//            id += 1
//        }
        
        // Corners
        for start in 0..<directionCount {
            for end in start+1..<directionCount {
                var newCard = Card(cardType: "path", id:id)
                newCard.connections[start] = 1
                newCard.connections[end] = 1
                let newDirections = [directions[start],directions[end]]
                newCard.cardConent = newDirections.joined(separator: "")
                playDeck.append(newCard)
                id += 1
            }
        }
        
        // T-Shape
        for closed in 0..<directionCount {
            var newCard = Card(cardType: "path", connections: [1,1,1,1], id:id)
            newCard.connections[closed] = 0
            var newDirections = directions
            newDirections.remove(at: closed)
            newCard.cardConent = newDirections.joined(separator: "")
            playDeck.append(newCard)
            id += 1
        }
        
        // X-Shape
        for _ in 0..<crossCardCount {
            playDeck.append(Card(cardType: "path", cardConent: directions.joined(separator: ""), connections: [1,1,1,1], id: id))
            id += 1
        }
        
        currentDeck = Array(0..<playDeck.count)
        currentDeck.shuffle()
        
    }
    

    
    mutating func createGrid() {
        // Set size of the grid

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
        grid[0][0].cellType = 0
        grid[0][2].hasCard = true
        grid[0][2].cardIdx = goalCardsIdx[1]
        grid[0][2].cellType = 0
        grid[0][4].hasCard = true
        grid[0][4].cardIdx = goalCardsIdx[2]
        grid[0][4].cellType = 0
        
        
        grid[8][2].hasCard = true
        grid[8][2].cardIdx = 3
        grid[8][2].cellType = 0
        
    }
    
    struct Cell: Identifiable, Hashable {
        var hasCard: Bool = false
        var cellType: Int = 1 // 0 for goal, start. 1 for path card
        var cardIdx: Int = 0
        var pos: Array<Int> = [0,0]
        var id: Int = 0
    }

    struct Card {
        var isFaceUp: Bool = false
        var cardType: String = "" // 1: Action 2: Path
        var cardConent: String = " "
        var connections: Array<Int> = [0,0,0,0] // Is there a open connection at [Top,Right,Bottom,Left]
        var id: Int
    }
    
    struct Player {
        var status: String = "Nothing" // placingCard, waiting (for other player), usingCard(action), redraw
        var role: String = ""
        var cards: Array<Int> = []
        var id: Int = 0
        
    }
}
    

