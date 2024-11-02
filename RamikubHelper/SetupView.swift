//
//  SwiftUIView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/29/24.
//

import SwiftUI

struct SetupView: View {
    
    @Bindable var viewModel: RamikubViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Text ("Welcome to Ramikub Helper").font(.title)
                    Spacer()
                    Text("Who is playing?").font(.title3)
                    configuredPlayersView (boxWidth: geometry.size.width)
                    addPlayerButton
                    Spacer()
                    Text("How many seconds to finish a play?").font(.title3)
                    counter
                    Spacer()
                    HStack {
                        resetGameButton
                        Spacer()
                        readyButton
                    }
                    .font(.title3)
                    .padding()
                }
            }
        }

       
    }
    
    func configuredPlayersView (boxWidth: CGFloat) -> some View {
        VStack {
            ForEach (viewModel.players.indices, id: \.self) { index in
                PlayerSetupView (player: $viewModel.players[index], boxWidth: boxWidth)
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
        NavigationLink ("Start Game") {
            GameView (viewModel: viewModel)
                .navigationBarBackButtonHidden()
        }
    }
    
    var resetGameButton: some View {
        Button ("Reset Values") {
            viewModel.resetAll()
        }
    }
    
   
}
    
    
    

struct PlayerSetupView: View {
    
    let playerFont: Font = .system(.title3)
    let playerFontColor: Color = .black
    
    @Binding var player: Player
    let boxWidth: CGFloat
    
    init (player: Binding<Player>, boxWidth: CGFloat) {
        self._player = player
        self.boxWidth = boxWidth
    }
    
    var body: some View {
        TextField (player.name == "" ? "Player" : player.name, text:$player.name)
            .frame(maxWidth: boxWidth, alignment: .leading)
            .disableAutocorrection(true)
            .foregroundStyle(playerFontColor)
            .font(playerFont)
            .padding()
            .border(.gray)
            .padding(10)
        }}


#Preview {
    var viewModel = RamikubViewModel()
    SetupView(viewModel: viewModel)
}
