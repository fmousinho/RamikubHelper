//
//  RamikubGame.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import Foundation

struct RamikubGame {
    
    private(set) var currentRound: Int = 0
    private(set) var numberOfPlayers: Int = 0
    var players: Array<Player> = []
    var counterValue: Int = 60
    
    mutating func addPlayer() {
        players.append(Player())
        updateScoreBoardsCounts()
    }
    
    mutating private func updateScoreBoardsCounts() {
       
    }
    
    func checkForRoundWinner (players: [Player], round: Int) -> Bool {
        var potentialWinnerIndex: Int = 0
        var numberOfPlayersNotScoreZero: Int = 0
        var i: Int = 0
        
        repeat {
            if players[i].scoreBoard[round] == 0 {
                numberOfPlayersNotScoreZero += 1
                if numberOfPlayersNotScoreZero > 1 {
                    return false
                } else {
                    potentialWinnerIndex = i
                }
            }
            i += 1
        } while i < players.count
        updateWinnerScoreFor (playerId: potentialWinnerIndex, round: round)
        return true
    }
    
    func updateWinnerScoreFor (playerId: Int, round: Int) {
        
    }
    
}
    
struct Player: Identifiable {
   
    let id: UUID = UUID()
    var name: String = ""
    var scoreBoard: Array<Int> = [0]
    var totalScore: Int = 0
    
}
    

