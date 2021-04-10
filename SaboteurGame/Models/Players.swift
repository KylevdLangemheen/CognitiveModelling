//
//  Players.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 02/03/2021.
//

import Foundation

class Player: Identifiable {
    var tools: Tools
    var role: Role
    var type: playerType
    var name: String
    var hand: Array<Card> = []
    var id: Int
    var skipped: Bool = false
    var field: Field
    var players: Array<Player> = []
    var deck: Deck
    let model = Model()
    
    let minerThreshold: Float = 2
    let saboteurThreshold: Float = 0
    
    init(role: Role, id: Int, deck: Deck, handSize: Int, type: playerType, name: String, field: Field) {
        tools = Tools()
        self.role = role
        self.id = id
        self.type = type
        self.name = name
        self.field = field
        self.deck = deck
        
        // Hand initialization
        for _ in 0..<handSize {
            let card = deck.drawCard()
            print(card.id)
            self.hand.append(card)
        }
        
        if type == .computer {
            model.loadModel(fileName: "rps")
            model.run()

        }
        
    }
    
    

    func addPlayers(players: Array<Player>){
        self.players = players
    }
    
    func checkTools(tools: Tools) -> toolStatus {
        if (tools.lamp == .broken || tools.mineCart == .broken || tools.pickaxe == .broken){
            return .broken
        }
        return .intact
    }

    func changeToolStatus(tool: toolType, actionType: actionType) -> toolPlayError{
        switch tool {
        case .pickaxe:
            switch (tools.pickaxe, actionType) {
            case (.intact, .breakTool): tools.pickaxe = .broken
            case (.broken, .repairTool): tools.pickaxe = .intact
            case (.intact, .repairTool): return .alreadyIntact
            case (.broken, .breakTool): return .alreadybroken}
        case .minecart:
            switch (tools.mineCart, actionType) {
            case (.intact, .breakTool): tools.mineCart = .broken
            case (.broken, .repairTool): tools.mineCart = .intact
            case (.intact, .repairTool): return .alreadyIntact
            case (.broken, .breakTool): return .alreadybroken}
        case .lamp:
            switch (tools.lamp, actionType) {
            case (.intact, .breakTool): tools.lamp = .broken
            case (.broken, .repairTool): tools.lamp = .intact
            case (.intact, .repairTool): return .alreadyIntact
            case (.broken, .breakTool): return .alreadybroken}
        }
        return .succes
    }

    
    func removeCardFromHand(id: Int) {
        print("\(name) removed a card from the hand")
        let cardIndex: Int = getCardIndexInHand(id: id)
        hand.remove(at: cardIndex)
    }
    
    func getCardIndexInHand(id: Int) -> Int{
        for handIdx in 0..<hand.count {
            if hand[handIdx].id == id {
                return handIdx
            }
        }
        return 0
    }
    
    func swapCard(card: Card) -> swapPlayError{
        if deck.cards.count > 0 {
            let cardIdx = getCardIndexInHand(id: card.id)
            self.hand[cardIdx] = deck.drawCard()
            return .succes
        } else {
            return .emptyDeck
        }
    }
    


    func skipTurn() {
        if deck.cards.count == 0 {
            skipped = true
        }
    }
    
    func placeCard(card: Card, cell: Cell) -> placeError{
        if checkTools(tools: tools) == .intact{
            if field.placeCard(cell: cell, card: card) {
                removePlayedCard(card: card)
                return .succes
            } else {
                return .invalidPlacement
            }
        } else {
            print("\(name)'s tools are broken")
            return .toolsBroken
            
        }
    }

    
    func removePlayedCard(card: Card){
        if swapCard(card: card) == .emptyDeck {
            removeCardFromHand(id: card.id)
        }
    }
    
    func playToolCard(play: cardPlay) -> toolPlayError{
        let error = play.toPlayer.changeToolStatus(tool: play.card.action.tool, actionType: play.card.action.actionType)
        if error == .succes {
            removePlayedCard(card: play.card)
        }
        return error
    }
    

    func getPossibleToolPlays() -> Array<cardPlay> {
        var possiblePlays: Array<cardPlay> = []
        for card in hand {
            if card.cardType == .tool {
                for player in players {
                        switch(card.action.tool, card.action.actionType){
                        case (.pickaxe , .breakTool): if player.tools.pickaxe == .intact && id != player.id {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                          card: card,
                                                                                                          toPlayer: player,
                                                                                                          coopValue: -5/2))}
                        case (.minecart , .breakTool): if player.tools.mineCart == .intact && id != player.id {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                           card: card,
                                                                                                           toPlayer: player,
                                                                                                           coopValue: -5/2))}
                        case (.lamp , .breakTool): if player.tools.lamp == .intact && id != player.id{possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                          card: card,
                                                                                                          toPlayer: player,
                                                                                                          coopValue: -5/2))}
                        case (.pickaxe , .repairTool): if player.tools.pickaxe == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                           card: card,
                                                                                                           toPlayer: player,
                                                                                                           coopValue: 2.5))}
                        case (.minecart , .repairTool): if player.tools.mineCart == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                          card: card,
                                                                                                          toPlayer: player,
                                                                                                          coopValue: 2.5))}
                        case (.lamp , .repairTool): if player.tools.lamp == .broken {possiblePlays.append(cardPlay(playType: .toolModifier,
                                                                                                           card: card,
                                                                                                           toPlayer: player, coopValue: 2.5))}
                        }
                        
                    }
                }
            }
        return possiblePlays
    }
    
    func play() -> cardPlay{

        var possiblePathPlays: Array<cardPlay> = []
        var possibleToolPlays: Array<cardPlay> = []
        possibleToolPlays = getPossibleToolPlays()
        if checkTools(tools: tools) == .intact {
            for card in hand {
                possiblePathPlays.append(contentsOf: field.getPosiblePathPlays(card: card))
            }
        }
        
        if possiblePathPlays.count != 0 || possibleToolPlays.count != 0 {
            
            var playerBeliefs: Array<Belief> = []
            
            for player in players {
                if player.id == id {
                    continue
                }

                let playerno = mapPlayerID(player: player)
                model.modifyLastAction(slot: "playerno", value: playerno)
                model.run()
                let (role, activation) = model.lastAction(slot: "role")!
//                print("Model \(name) believes \(player.name) is a \(role)")
                playerBeliefs.append(Belief(role: role, activation: activation))
                model.run()
            }
            
            playerBeliefs = playerBeliefs.sorted(by: {$0.activation > $1.activation})

            
            for beliefIdx in 0..<playerBeliefs.count-1 {
                if playerBeliefs[beliefIdx].role == "unknown" {
                    playerBeliefs.remove(at: beliefIdx)
                }
                
            }

            //First, the model tries to repair itself
            if checkTools(tools: tools) == .broken{
                for play in possibleToolPlays {
                    if play.toPlayer.id == id {
                        return play
                    }
                }
            }
            
            //If it doesn't have to or can't repair itself
            //The model tries to attack/repair players based on belief
            for play in possibleToolPlays {
                for belief in playerBeliefs {
                    if  play.toPlayer.id != id {
                        if play.card.action.actionType == .repairTool && belief.role == role.rawValue{
                            return play
                        } else if play.card.action.actionType == .breakTool && belief.role != role.rawValue {
                            return play
                        }
                    }
                }
            }

            if role == .miner {possiblePathPlays.sort {$0.coopValue > $1.coopValue}}
            else {possiblePathPlays.sort {$0.coopValue < $1.coopValue}}

            for play in possiblePathPlays {
                if role == .miner {
                    if play.coopValue > minerThreshold {
                        return play
                    }
                } else {
                    if play.coopValue < saboteurThreshold {
                        return play
                    }
                }
            }
        }
        
        if deck.cards.count > 0 {
            return cardPlay(playType: .swap, card: hand[0])
        } else {
            return cardPlay(playType: .skip)
        }


    }

    
    func mapPlayerID(player: Player) -> String {
        if player.id == id {return "one"} // Itself
        else if player.id == 0 {return "zero"} // Human
        else {return "two"} // Other computer
    }

}


struct Tools {
    var pickaxe: toolStatus = .intact
    var mineCart: toolStatus = .intact
    var lamp: toolStatus = .intact
}





