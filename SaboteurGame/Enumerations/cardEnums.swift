//
//  cardEnums.swift
//  SaboteurGame
//
//  Created by Nico Buiten on 02/04/2021.
//

import Foundation

enum pathType {
    case none, connection, blocked
}

enum cardType {
    case gold, coal, tool, path, start
}

enum actionType {
    case breakTool, repairTool
}

enum playType {
    case placeCard, toolModifier
}

enum side {
    case top, right, bottom, left
}
