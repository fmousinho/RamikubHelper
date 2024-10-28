//
//  ContentView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var viewModel: RamikubViewModel
    
    var body: some View {
        VStack {
            listActivePlayers
            addPlayerButton
            Spacer()
            resetGameButton
        }
        .padding()
    }
    
    @ViewBuilder
    var listActivePlayers: some View {
        VStack {
            ForEach (0 ..< viewModel.numberOfPlayers, id: \.self) { index in
                PlayerView (player: $viewModel.players[index])
            }
        }
    }
    
    
    var addPlayerButton: some View {
        Button("Add Player") {
            viewModel.addPlayer()
        }
        .disabled(viewModel.numberOfPlayers >= viewModel.maxPlayers)
    }
    
    var resetGameButton: some View {
        Button("Reset Game") {
            viewModel.resetAll()
        }
    }
    
}
    
struct ScoresView: View {
    @Binding var player: Player
    var body: some View {
        HStack() {
            ForEach(player.scoreBoard.indices, id: \.self) {index in
                TextField(String(player.scoreBoard[index]), value: $player.scoreBoard[index], format: .number)
                    .onChange (of: player.scoreBoard[index]) { _ , newScore in
                            player.checkForRoundWinner(round: index)
                    }
            }
        }
    }
}


struct PlayerView: View {
    
    let playerFont: Font = .system(size: 30 , weight: .bold)
    let playerFontColor: Color = .white
    
    @Binding var player: Player
    var scores: ScoresView?
    
    init (player: Binding<Player>) {
        self._player = player
        self.scores = ScoresView(player: $player)
    }
    
    var body: some View {
        VStack {
            TextField (player.name == "" ? "Player \(player.id + 1)" : player.name, text:$player.name)
            scores
        }
        .foregroundStyle(playerFontColor)
        .font(playerFont)
        .padding()
        .background(.blue)
        .border(Color.black)
        .padding()
    }
}
    


#Preview {
    ContentView(viewModel: .init())
}
