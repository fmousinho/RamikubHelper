//
//  RamikubGame.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import Foundation

struct RamikubGame {
    
    private var nextPlayerId: Int = 0
    private(set) var currentRound: Int = 0
    private(set) var numberOfPlayers: Int = 0
    
    mutating func addPlayer(to players: inout [Player]) {
        players.append(Player(nextPlayerId))
        nextPlayerId += 1
        numberOfPlayers += 1
        updateScoreBoardsCounts(for: &players)
    }
    
    mutating private func updateScoreBoardsCounts(for players: inout [Player]) {
        let numberOfPlayers = players.count
        for index in 0...numberOfPlayers - 1 {
            players[index].updateSoreBoardforPlayer(numberOfPlayers)
        }
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
    var id: Int
    
    init (_ nextPlayerId: Int) {
        id = nextPlayerId
    }
    var name: String = ""
    var scoreBoard: Array<Int> = [0] 
        
    var totalScore: Int = 0
    
    mutating func updateSoreBoardforPlayer(_ scoreCounts: Int) {
        self.scoreBoard = Array(repeating: 0, count: scoreCounts)
    }
    
    func checkForRoundWinner (round: Int) {
        
    }
    
}
    

