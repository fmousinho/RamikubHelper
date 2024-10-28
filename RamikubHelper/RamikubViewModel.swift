//
//  RamikubViewModel.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import SwiftUI

@Observable class RamikubViewModel {
    
    private(set) var game: RamikubGame = RamikubGame()

    let maxPlayers: Int = 4
    var players: Array<Player> = []
    
    var numberOfPlayers: Int {
        max (game.numberOfPlayers, 2)
    }
   
    init() {
        addPlayer ()
        addPlayer ()
    }
        
    func addPlayer() {
        game.addPlayer (to: &players)
    }
    
    func updateScoreFor (playerId: Int, score: Int, round: Int) {
        
    }
    
    func checkForRoundWinner(round: Int) {
        game.checkForRoundWinner(players: players, round: round)
    }
    
    func resetAll() {
        game = RamikubGame()
        players = []
        addPlayer ()
        addPlayer ()
    }
    
}


