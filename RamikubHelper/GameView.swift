//
//  GameView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/30/24.
//

import SwiftUI
import AVFAudio
import Combine

struct GameView: View {
    
    @Environment(RamikubViewModel.self) private var vm
    
    @State private var timeRemaining: Int = 0
    @State private var timerIsPaused: Bool = false
    @State private var muted = true
    @State private var timer: AnyCancellable?
    
    init () {
        let buzzerSoundFilePath = Bundle.main.path (forResource: "mixkit-wrong-long-buzzer-954", ofType: "wav")
        let buzzerSoundFileURL = URL (fileURLWithPath: buzzerSoundFilePath!)
        self.buzzerPlayer = try! AVAudioPlayer(contentsOf: buzzerSoundFileURL)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Player Turn").font(.title3)
                playersGameView (boxWidth: geometry.size.width)
                Spacer()
                gameControls
                Spacer()
                HStack {
                    resetGameButton
                }
                .font(controlFont)
                .padding()
            }
        }
        .onAppear {
            timeRemaining = vm.counterValue
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() -> Void {
        let clickStartTime = 5
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink {_ in
                if timeRemaining > 0 && !timerIsPaused {
                    timeRemaining -= 1
                    if timeRemaining <= clickStartTime &&
                        timeRemaining > 0 &&
                        !muted {
                        AudioServicesPlaySystemSound(1306)
                    }
                    if timeRemaining == 0 && !muted {
                        Task {
                            buzzerPlayer?.prepareToPlay()
                            buzzerPlayer?.play()
                        }
                    }
                }
            }
    }
    
    private func stopTimer() -> Void {
        timer?.cancel()
        timer = nil
    }
    
    @ViewBuilder
    private var gameControls: some View {
        VStack {
            Spacer()
            HStack {
                roundOverButton
                nextPlayerButton
            }
            Spacer()
            counter
            HStack {
                pauseTimerButton
                Spacer()
                muteButton
            }
            .padding()
        }
        .font(controlFont)
    }
    
    private let buzzerPlayer: AVAudioPlayer?
    
//    var animatedCounter: some View {
//        Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
//            .opacity(Constants.Pie.opacity)
//            .overlay(cardContents.padding(Constants.Pie.inset))
//            .padding(Constants.inset)
//            .cardify(isFaceUp: card.isFaceUp)
//            .transition(.scale)
//    }
    
    private var pauseTimerButton: some View {
        Button(timerIsPaused ? "Resume Timer" : "Pause Timer") {
            timerIsPaused.toggle()
        }
    }
    
    private var muteButton: some View {
        Button (muted ? "Unmute" : "Mute") {
            muted.toggle()
        }
    }
    
    private var nextPlayerButton: some View {
        VStack {
            Image(systemName: "forward.fill").frame(height: 10)
            Text("Next Player")
        }
        .buttonStyle()
        .onTapGesture {
            withAnimation {
                advancePlayer()
                timeRemaining = vm.counterValue
            }
        }
    }

    private var roundOverButton: some View {
        Button (action: {
            vm.playState = .scoring
        }, label: {
            VStack {
                Image(systemName: "star.square.on.square").frame(height: 10)
                Text("Finish Round")
            }
            .buttonStyle()
        })
    }
    
    private func advancePlayer () {
        if vm.turnIndex < vm.players.count - 1 {
            vm.turnIndex += 1
        } else {
            vm.turnIndex = 0
        }
    }
    
    private func playersGameView (boxWidth: CGFloat) -> some View {
        VStack {
            let players = Binding (
                get: { vm.players },
                set: { vm.players = $0 }
            )
            ForEach (players, id: \.id) { player in
                PlayersView (player: player, boxWidth: boxWidth)
                    .border (players.firstIndex(where: { $0.id == player.id} ) == vm.turnIndex ? goldColor : Color.clear, width: 10)
            }
        }
    }
    
    private var counter: some View {
        CustomStepper(count: $timeRemaining)
    }
    
    private var resetGameButton: some View {
        Button ("Back to Setup") {
            vm.playState = .setup
        }
    }
        
}


struct GameView_Previews: PreviewProvider {
   
    static var previews:some View {
        @State var viewModel = RamikubViewModel(counterValue: 10)
        GameView().environment(viewModel)
    }
}
