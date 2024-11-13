//
//  SwiftUIView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 11/12/24.
//



import SwiftUI

struct MainView: View {
    
    @Environment(RamikubViewModel.self) private var vm
    
    var body: some View {
        
        switch vm.playState {
            case .game: GameView()
            case .scoring: roundScoringView()
            default: SetupView()
        }
    }
}

#Preview {
    let vm = RamikubViewModel()
    MainView().environment(vm)
}
