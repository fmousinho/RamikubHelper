//
//  SwiftUIView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/29/24.
//

import SwiftUI

struct SetupView: View {
    
    @Environment(RamikubViewModel.self) private var vm
    
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
                    Text("How many seconds to finish a play?").font(controlFont)
                    counter
                    Spacer()
                    HStack {
                        resetGameButton
                        Spacer()
                        readyButton
                    }
                    .font(controlFont)
                    .padding()
                }
            }
           .onAppear() {
               vm.resetScores()
           }
            .onDisappear{
                vm.cleanBlankPlayerNames()
            }
        }
    }
    
    private func configuredPlayersView (boxWidth: CGFloat) -> some View {
        VStack {
            let players = Binding (
                get: { vm.players },
                set: { vm.players = $0 }
            )
            ForEach (players, id:\.id) {player in
                PlayersView (player: player, boxWidth: boxWidth)
            }
        }
    }
    
    private var addPlayerButton: some View {
        Button("Add Player") {
            vm.addPlayer()
        }
        .isHidden(vm.players.count == vm.maxPlayers)
    }
    
    private var counter: some View {
        let counterValue = Binding (
            get: { vm.counterValue },
            set: { vm.counterValue = $0 }
        )
        return CustomStepper(count: counterValue)
    }
    
    private var readyButton: some View {
        Button ("Start Game") {
            vm.playState = .game
        }
    }
    
    private var resetGameButton: some View {
        Button ("Reset Values") {
            vm.resetAll()
        }
    }
   
}
    


#Preview {
    let viewModel = RamikubViewModel()
    SetupView().environment(viewModel)
}


