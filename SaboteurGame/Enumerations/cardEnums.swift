//
//  cardEnums.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 02/04/2021.
//

import Foundation

enum pathType {
    case none, connection, blocked
}

enum cardType {
    case gold, coal, tool, path, start, empty
}

enum actionType {
    case breakTool, repairTool
}

enum playType {
    case placeCard, toolModifier, swap, skip
}

enum side {
    case top, right, bottom, left
}
