//
//  RamikubViewModel.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import SwiftUI

@Observable class RamikubViewModel {
    
    private(set) var game: RamikubGame = RamikubGame()
    
    init (counterValue: Int? = nil) {
        if counterValue != nil {
            self.counterValue = counterValue!
        }
    }
    
    var playState: PlayState = .setup
    var round: Int = 0
    var turnIndex: Int = 0
    let maxPlayers: Int = 4
    
    var playerIndexToUpdate: UUID?
    var roundIndexToUpdate: Int?

    enum PlayState {
        case setup
        case game
        case scoring
    }

    var players: PlayerArray {
        get { game.players }
        set { game.players = newValue }
    }
    var numberOfPlayers: Int {
        max (players.count, 2)
    }
    var counterValue: Int {
        get { game.counterValue }
        set { game.counterValue = newValue }
    }
    var roundWinners: [UUID?] {
        game.roundWinners
    }
    var gameOver: Bool {
        get { game.gameOver }
        set { game.gameOver = newValue}
    }
    var gameWinner: [Int] {
        game.gameWinner
    }
    var lastRound: Bool {
        if round < numberOfPlayers - 1 {
            return false
        } else {
            return true
        }
    }
    var gameWinnerScore: Int {
        game.gameWinnerScore
    }
    

        
    func addPlayer(name: String = "") {
        game.addPlayer ()
    }
    
    func cleanBlankPlayerNames() {
        game.cleanBlankPlayerNames()
    }
    
    func advanceRound() {
        if round < numberOfPlayers-1 {
            round += 1
        } else {
            game.determineGameWinner()
        }
    }
    
    func updateScores (playerIndexThatChanged: UUID, roundIndex: Int) {
        game.updateScores (playerId: playerIndexThatChanged, roundIndex: roundIndex)
    }
    
    func resetRound() {
        for index in players.indices {
            players[index].scoreBoard[round] = 0
        }
    }
    
    func resetScores() {
        round = 0
        turnIndex = 0
        game.resetScores()
    }
    
    func resetAll() {
        round = 0
        turnIndex = 0
        game.resetAll()
    }
}
