//
//  SwiftUIView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/29/24.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PlayerSetupView: View {
    
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
    SwiftUIView()
}
