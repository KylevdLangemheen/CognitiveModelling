//
//  gameEnums.swift
//  SaboteurGame
//
//  Created by Koen Buiten on 02/04/2021.
//

import Foundation

enum gameStatus: String{
    case playing, minersWin, saboteursWin
}

enum placeError: String {
    case invalidPlacement = "This card cannot be placed at this cell"
    case invalidStatus = "You did not select a path card"
    case toolsBroken = "One or multiple of your tools are broken, you cannot play path cards"
    case defaultError = "Something strange happend"
    case notTurn = "It is not your turn"
    case succes
}

enum toolPlayError: String {
    case alreadybroken = "You tried to break a tool which is already broken"
    case invalidStatus = "You did not select a tool card"
    case alreadyIntact = "You tried to repair a tool which is not broken"
    case defaultError = "Something strange happend"
    case notTurn = "It is not your turn"
    case succes
}

enum swapPlayError: String {
    case emptyDeck = "The deck is empty, you cannot swap cards anymore"
    case noCard = "You did not select a card to swap"
    case notTurn = "It is not your turn"
    case succes
}

enum skipPlayError: String {
    case succes
    case notTurn = "It is not your turn"
}
enum playTypes: String {
    case skip
    case swap
    case place
    case play
}
