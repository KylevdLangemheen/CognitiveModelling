//
//  PlayingFieldModel.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 24/02/2021.
//

import SwiftUI

class PlayingFieldViewModel: ObservableObject {
    @Published private var PlayingFieldModel: Game = Game()
    
    // MARK: Acces to the model
    var grid: Array<Array<Game.Cell>>{
        PlayingFieldModel.grid
    }
    
    var playDeck: Array<Game.Card> {
        PlayingFieldModel.playDeck
    }
    
    var staticDeck: Array<Game.Card> {
        PlayingFieldModel.staticDeck
    }
    
    var currrentPlayer: Game.Player {
        PlayingFieldModel.currentPlayer
    }
    
    // MARK: Intent(s)
//    func playCard(card: playingField.Card){
//        PlayingFieldModel.choose(card: card)
//    }
    
    func changeStatus(status: String){
        PlayingFieldModel.changeStatus(status: status)
    }
    
    func placeCard(cell: Game.Cell) {
        PlayingFieldModel.placeCard(cell: cell)
    }
    
    
//    func addCard(card: playingField.Card, loc: Array<Int>) {
//        PlayingFieldModel.addCard(card: card, loc: loc)
//    }
    func currentPlayer() -> Game.Player {
        PlayingFieldModel.currentPlayer
    }
    
    func getCard(cell: Game.Cell) -> Game.Card{
        PlayingFieldModel.getCard(cell: cell)
    }
    
    func flip(card: Game.Card) {
        PlayingFieldModel.flip(card: card)
    }
}
