//
//  GameView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/30/24.
//

import SwiftUI

struct GameView: View {
    
    @Bindable var viewModel: RamikubViewModel
    @State var turnIndex: Int = 0
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("Player Turn").font(.title3)
            playersGameView
            Spacer()
            Text("Time Left").font(.title3)
            HStack {
                pauseTimerButton
                counter
                nextPlayerButton
            }
            
            Spacer()
            HStack {
                resetGameButton
            }
            .font(.title3)
            .padding()
            
        }
    }
    
    var pauseTimerButton: some View {
        Button("Pause Timer") {
                    }
    }
    
    var nextPlayerButton: some View {
        Button("Next Player") {
            
        }
    }
    
    var playersGameView: some View {
        VStack {
            ForEach (viewModel.players.indices, id: \.self) { index in
                PlayerGameView (player: viewModel.players[index])
            }
        }
    }
    
    var addPlayerButton: some View {
        Button("Add Player") {
            viewModel.addPlayer()
        }
        .disabled(viewModel.numberOfPlayers >= viewModel.maxPlayers)
    }
    
    var counter: some View {
        CustomStepper(count: $viewModel.counterValue)
    }
    
    var readyButton: some View {
        Button ("Start Game") {
            
        }
    }
    
    var resetGameButton: some View {
        Button ("Reset Values") {
            viewModel.resetAll()
        }
    }
    
   
}
    
    
    

struct PlayerGameView: View {
    
    let playerFont: Font = .system(.title3)
    let playerFontColor: Color = .black
    
    let player: Player
    
    var body: some View {
        Text (player.name == "" ? "Player" : player.name)
        .foregroundStyle(playerFontColor)
        .font(playerFont)
        .padding()
        .border(.gray)
        .frame(width: .infinity, alignment: .leading)

    }
}

struct ScoresView: View {
    @Binding var player: Player
    var body: some View {
        HStack() {
            ForEach(player.scoreBoard.indices, id: \.self) {index in
                TextField(String(player.scoreBoard[index]), value: $player.scoreBoard[index], format: .number)
                    .onChange (of: player.scoreBoard[index]) { _ , newScore in
                           
                    }
            }
        }
    }
}





#Preview {
    var viewModel = RamikubViewModel()
    GameView(viewModel: viewModel)
}
