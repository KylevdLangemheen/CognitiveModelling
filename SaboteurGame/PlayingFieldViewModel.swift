//
//  PlayingFieldModel.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 24/02/2021.
//

import SwiftUI

class PlayingFieldViewModel {
    private var PlayingFieldModel: playingField = playingField()
    
    
    var grid: Array<Array<playingField.Cell>>{
        PlayingFieldModel.grid
    }
    
//    func playCard(card: playingField.Card){
//        PlayingFieldModel.choose(card: card)
//    }
}
