//
//  roundScoringView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 11/2/24.
//

import SwiftUI

struct roundScoringView: View {
    
    @Environment(RamikubViewModel.self) private var vm
    @State var lastRound: Bool = false
    
    var body: some View {
        let gameOver = Binding (
            get: { vm.gameOver },
            set: { vm.gameOver = $0 }
        )
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Select score to update").font(controlFont)
                playersGameView (boxWidth: geometry.size.width)
                Spacer()
                scoreInputTitle
                scoreInputControl
                Spacer()
                HStack {
                    cancelChangesButton
                    Spacer()
                    finishScoringButton
                }
                .font(controlFont)
                .padding()
            }
            .alert(isPresented: gameOver) {
                gameOverAlert()
            }
        }
        .onAppear {
            vm.playerIndexToUpdate = nil
            vm.roundIndexToUpdate = nil
            lastRound = vm.lastRound
        }
    }
        
    private func playersGameView (boxWidth: CGFloat) -> some View {
        return VStack {
            let players = Binding (
                get: { vm.players },
                set: { vm.players = $0 }
            )
            ForEach (players, id: \.id) { player in
                PlayersView (player: player, boxWidth: boxWidth)
            }
        }
    }
      
    @ViewBuilder
    private var scoreInputTitle: some View {
        if let player = vm.players.first (where: {$0.id == vm.playerIndexToUpdate }),
           let roundIndex = vm.roundIndexToUpdate {
                Text("Input score for \(player.name) in round \(roundIndex + 1)")
                    .font(controlFont)
        } else { Text ("placeholder").opacity (0) }
    }
    
    @State var temp: Int = 0
    
    @ViewBuilder
    private var scoreInputControl: some View {
        @Bindable var vm = vm
        if let playerId = vm.playerIndexToUpdate, let roundIndex = vm.roundIndexToUpdate {
            if let playerIndex = vm.players.firstIndex (where: {$0.id == playerId}) {
                let scoreBinding = Binding (
                    get: { vm.players[playerIndex].scoreBoard[roundIndex] },
                    set: { vm.players[playerIndex].scoreBoard[roundIndex] = $0 }
                )
                NumberSetter (
                    count: scoreBinding,
                    range: -200..<0
                )
                .onChange (of: scoreBinding.wrappedValue) {
                    vm.updateScores (playerIndexThatChanged: playerId, roundIndex: roundIndex)
                }
            }
        } else {
            NumberSetter (count: $temp, range: 0..<10, disabled: true, disabledColor: goldColor)
                .disabled(true)
                .foregroundStyle (goldColor)
        }
    }
    
    @ViewBuilder
    private var finishScoringButton: some View {
        Button ("Finish Scoring") {
            if !vm.lastRound {
                vm.advanceRound()
                vm.turnIndex = vm.round
                vm.playState = .game
            } else {
                vm.advanceRound()
            }
        }
        .disabled(vm.roundWinners[vm.round] == nil)
    }
    
    private var cancelChangesButton: some View {
        Button ("Cancel Changes") {
            vm.resetRound()
            vm.playState = .game
        }
    }
    
    private var winnerMessage: Text {
        var winnerName: String = ""
        for playerIndex in vm.gameWinner {
            let conjunction = winnerName.isEmpty ? "" : "and "
            winnerName = winnerName + conjunction + vm.players[playerIndex].name + " "
        }
        let verb = vm.gameWinner.count > 1 ? "win " : "wins "
        let point = vm.gameWinnerScore == 1 ? "point" : "points"
        return Text ("\(winnerName)\(verb)the game with \(vm.gameWinnerScore) \(point)!")
    }
    
    private func gameOverAlert() -> Alert {
        Alert (
            title: Text("Game Over"),
            message: winnerMessage,
            dismissButton: .default(Text("OK")) {
                vm.resetScores()
                vm.playState = .setup
            }
        )
    }
    
        
}

struct roundScoringView_Previews: PreviewProvider {
    static var previews:some View {
        @State var viewModel = RamikubViewModel()
        roundScoringView ().environment (viewModel)
    }
}
