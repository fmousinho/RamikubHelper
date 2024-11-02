//
//  GameView.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/30/24.
//

import SwiftUI
import AVFAudio

struct GameView: View {
    
    @Bindable var viewModel: RamikubViewModel
    @State var turnIndex: Int = 0
    
    private let controlFont: Font = .title3
    private let goldColor = Color(red: 255/255, green: 215/255, blue: 0/255)
    
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
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        
    }
    
    @ViewBuilder
    private var gameControls: some View {
        VStack {
            Spacer()
            nextPlayerButton
            Spacer()
            animatedCounter
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
    
    init (viewModel: RamikubViewModel) {
        self.viewModel = viewModel
        timeRemaining = viewModel.counterValue
        let buzzerSoundFilePath = Bundle.main.path (forResource: "mixkit-wrong-long-buzzer-954", ofType: "wav")
        let buzzerSoundFileURL = URL (fileURLWithPath: buzzerSoundFilePath!)
        self.buzzerPlayer = try! AVAudioPlayer(contentsOf: buzzerSoundFileURL)
    }
    
    @State private var timeRemaining: Int
    @State private var timerIsPaused: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var muted = false
   

    var animatedCounter: some View {
        counter
        .onReceive(timer) { _ in
            if timeRemaining > 0 && !timerIsPaused {
                timeRemaining -= 1
                if timeRemaining <= 5 &&
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
    
//    var animatedCounter: some View {
//        Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
//            .opacity(Constants.Pie.opacity)
//            .overlay(cardContents.padding(Constants.Pie.inset))
//            .padding(Constants.inset)
//            .cardify(isFaceUp: card.isFaceUp)
//            .transition(.scale)
//    }
    
    var pauseTimerButton: some View {
        Button(timerIsPaused ? "Resume Timer" : "Pause Timer") {
            timerIsPaused.toggle()
        }
    }
    
    var muteButton: some View {
        Button (muted ? "Unmute" : "Mute") {
            muted.toggle()
        }
    }
    
    var nextPlayerButton: some View {
        VStack {
            Image(systemName: "forward.fill")
            Text("Next Player")
        }
        .foregroundStyle(.blue)
        .padding()
        .background(goldColor)
        .onTapGesture {
            withAnimation {
                advancePlayer()
                timeRemaining = viewModel.counterValue
            }
        }
    }
    
    func advancePlayer () {
        if turnIndex < viewModel.players.count - 1  {
            turnIndex += 1
        } else {
            turnIndex = 0
        }
    }
    
    func playersGameView (boxWidth: CGFloat) -> some View {
        VStack {
            ForEach (viewModel.players.indices, id: \.self) { index in
                PlayerGameView (player: viewModel.players[index], boxWidth: boxWidth)
                    .border(index == turnIndex ? goldColor : Color.white, width: 10)
            }
        }
    }
    
    var counter: some View {
        CustomStepper(count: $timeRemaining)
    }
    
    var resetGameButton: some View {
        NavigationLink ("Back to Setup") {
            SetupView (viewModel: viewModel)
        }
    }
    
   
}
    
    
    

struct PlayerGameView: View {
    
    let playerFont: Font = .system(.title3)
    let playerFontColor: Color = .black
    
    let player: Player
    let boxWidth: CGFloat
    
    var body: some View {
        Text (player.name == "" ? "Player" : player.name)
            .frame(maxWidth: boxWidth, alignment: .leading)
            .foregroundStyle(playerFontColor)
            .font(playerFont)
            .padding()
            .border(.gray)
            .padding(10)
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


struct GameView_Previews: PreviewProvider {
   
    static var previews:some View {
        @State var viewModel = RamikubViewModel(counterValue: 10)
        GameView(viewModel: viewModel)
    }
}
