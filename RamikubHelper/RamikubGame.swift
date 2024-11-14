//
//  RamikubGame.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import Foundation

struct RamikubGame {
    
    private(set) var currentRound: Int = 0
    var players: PlayerArray = [Player(), Player()]
    var counterValue: Int = 60
    var roundWinners: [UUID?] = [nil, nil]
    var gameWinner: [Int] = []
    var gameOver: Bool = false
    var gameWinnerScore = 0
    
    mutating func addPlayer() {
        players.append(Player())
        updateScoreBoardsCounts()
        roundWinners.append(nil)
    }
    
    mutating private func updateScoreBoardsCounts() {
       for index in players.indices {
           players[index].scoreBoard = Array(repeating: 0, count: players.count)
        }
    }
    
    mutating func cleanBlankPlayerNames() {
        for index in players.indices {
            if players[index].name == "" {
                players[index].name = "Player \(index + 1)"
            }
        }
    }
    
    mutating func updateTotalScore (playerId: UUID) {
        if let playerIndex = players.idToIndex (playerId) {
            players[playerIndex].totalScore = 0
            for score in players[playerIndex].scoreBoard {
                players[playerIndex].totalScore += score
            }
        }
    }
    
    mutating func updateScores (playerId: UUID, roundIndex: Int) {
        updateTotalScore(playerId: playerId)
        (_,_) = checkForRoundWinner(playerIdThatChanged: playerId, roundIndex: roundIndex)
    }
    
    mutating func checkForRoundWinner (playerIdThatChanged: UUID, roundIndex: Int) -> (isThereaWinner: Bool, winnerIndex: Int?) {
        
        var numberOfPotentialWinners = 0
        var winnerIndex = 0
        var winnerScore = 0
        
        for index in players.indices {
            let score = players[index].scoreBoard[roundIndex]
            if score >= 0 {
                winnerIndex = index
                numberOfPotentialWinners += 1
                if numberOfPotentialWinners > 1 {
                    resetRoundWinner(round: roundIndex)
                    return (false, nil)
                }
            } else {
                if score < 0 { winnerScore -= score }
            }
        }
        handleWinner (winnerIndex: winnerIndex, round: roundIndex, winnerScore: winnerScore)
        return (true, winnerIndex)
    }
    
    mutating private func handleWinner (winnerIndex: Int, round: Int, winnerScore: Int) {
        players[winnerIndex].scoreBoard[round] = winnerScore
        roundWinners[round] = players[winnerIndex].id
        updateTotalScore(playerId: players[winnerIndex].id)
    }
    
    mutating private func resetRoundWinner (round: Int) {
        if let playerId = roundWinners[round] {
            if let playerIndex = players.idToIndex(playerId) {
                if players[playerIndex].scoreBoard[round] > 0 {
                    players[playerIndex].scoreBoard[round] = 0
                }
            }
            roundWinners[round] = nil
        }
    }
    
    mutating func determineGameWinner() {
        var maxScore: Int = 0
        var winner: [Int] = []
        for index in players.indices {
            if players[index].totalScore > maxScore {
                maxScore = players[index].totalScore
                winner = [index]
            } else if players[index].totalScore == maxScore {
                winner.append(index)
            }
        }
        gameWinner = winner
        gameWinnerScore = maxScore
        gameOver = true
    }
    
    mutating func resetScores() {
        for playerIndex in players.indices {
            for scoreIndex in players[playerIndex].scoreBoard.indices {
                players[playerIndex].scoreBoard[scoreIndex] = 0
            }
            players[playerIndex].totalScore = 0
        }
        for index in roundWinners.indices {
            roundWinners[index] = nil
        }
        gameOver = false
    }
    
    mutating func resetAll() {
        currentRound = 0
        counterValue = 60
        roundWinners = [nil, nil]
        gameWinner = []
        gameOver = false
        gameWinnerScore = 0
        
        players = [Player(), Player()]
    }
}

typealias Score = Int

struct Player: Identifiable {
   
    let id: UUID = UUID()
    var name: String = ""
    var scoreBoard: Array<Score> = [0, 0]
    var totalScore: Int = 0
}

typealias PlayerArray = Array<Player>

extension PlayerArray {
    func idToIndex (_ identifier: UUID ) -> Int? {
        self.firstIndex (where: { $0.id == identifier })
    }
}

