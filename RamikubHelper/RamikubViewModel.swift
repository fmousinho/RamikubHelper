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
    var players: Array<Player> {
        get { game.players }
        set { game.players = newValue }
    }
    
    var numberOfPlayers: Int {
        max (players.count, 2)
    }
    
    var counterValue: Int {
        get {
            game.counterValue
        }
        set {
            game.counterValue = newValue
        }
    }
   
    init(counterValue: Int? = nil) {
        addPlayer ()
        addPlayer ()
        if counterValue != nil {
            self.counterValue = counterValue!
        }
    }
        
    func addPlayer(name: String = "") {
        game.addPlayer ()
       
    }
    
    func updateScoreFor (playerId: Int, score: Int, round: Int) {
        
    }
    
    func checkForRoundWinner(round: Int) {
        game.checkForRoundWinner(players: players, round: round)
    }
    
    func resetAll() {
        game = RamikubGame()
        addPlayer ()
        addPlayer ()
    }
    
}


