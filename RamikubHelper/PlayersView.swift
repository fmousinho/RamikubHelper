//
//  PlayersView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 11/7/24.
//

import SwiftUI

struct PlayersView: View {
    
    @Environment(RamikubViewModel.self) private var vm
    
    private let player: Binding<Player>
    private let boxWidth: CGFloat

    init (player: Binding<Player>, boxWidth: CGFloat) {
        self.player = player
        self.boxWidth = boxWidth
    }
    
    var body: some View {
        VStack {
            let name = player.name  // name is a binding
            TextField (name.wrappedValue == "" ? "Player" : name.wrappedValue, text: name)
                .disabled (vm.playState == .setup ? false : true)
                .disableAutocorrection(true)
            ScoresView (player: player)
                .disabled (vm.playState == .scoring ? false : true)
        }
        .playerBoxAllStyle (boxWidth: boxWidth)
    }
}

struct ScoresView: View {

    @Environment(RamikubViewModel.self) private var vm
    private var player: Binding<Player>
    
    init (player: Binding<Player>) {
        self.player = player
    }
    
    var body: some View {
        HStack() {
            roundScores
            Spacer()
            totalScore
        }
        .padding(.horizontal, 10)
        .font(.body)
    }
    
    private var roundScores: some View {
        ForEach(player.scoreBoard.indices, id: \.self) {roundIndex in
            let canChange =
                roundIndex == vm.round &&                   //only allow editing current round
                vm.playState == .scoring                   //only allow editing during scoring view
            let scoreValue = player.scoreBoard[roundIndex].wrappedValue
            let textColor = selectColor(value: scoreValue, defaultColor: canChange ? .black : scoreColor)
            Text ("R\(roundIndex + 1): \(scoreValue)")
                .foregroundStyle(textColor)
                .onTapGesture {
                    if canChange {
                        if player.id != vm.roundWinners[roundIndex]  {
                            vm.playerIndexToUpdate = player.id
                            vm.roundIndexToUpdate = roundIndex
                        } else {
                            vm.playerIndexToUpdate = nil
                            vm.roundIndexToUpdate = nil
                        }
                            
                    }
                }
            Spacer()
        }
    }
    
    private var totalScore: some View {
        let value = player.totalScore.wrappedValue
        let totalColor = selectColor(value: value, defaultColor: scoreColor)
        return Text("T: \(player.totalScore.wrappedValue)").foregroundStyle(totalColor)
    }
    
    private func selectColor (value: Int, defaultColor: Color) -> Color {
        var color:  Color {
            switch value {
            case let x where x < 0: .red
            case let x where x > 0: .blue
            default: defaultColor
            }
        }
        return color
    }
    
}
       



