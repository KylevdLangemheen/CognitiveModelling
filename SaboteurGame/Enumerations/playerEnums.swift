//
//  playerEnums.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/04/2021.
//

import Foundation

enum playerType {
    case computer, human
}

enum playerStatus {
    case playing, waiting, usingActionCard, usingPathCard, usingToolCard
}

enum Role: String {
    case miner, saboteur
}

struct Belief {
    var role: String
    var activation: Double
}
