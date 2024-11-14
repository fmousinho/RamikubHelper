//
//  Style.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 11/3/24.
//

import SwiftUI

let controlFont: Font = .title3
let goldColor = Color(red: 255/255, green: 215/255, blue: 0/255)
let playerFont: Font = .system(.title2)
let playerFontColor: Color = .black
let scoreColor = Color.secondary
let padFont = Font.system(.title)

struct roundControlStyle:  ViewModifier {
    func body (content: Content) -> some View {
        content
            .foregroundStyle (Color.blue)
            .padding()
            .background (goldColor)
    }
}

extension View {
    func buttonStyle () -> some View {
        modifier(roundControlStyle())
    }
}

struct playerBoxStyle:  ViewModifier {
    let boxWidth: CGFloat
    init (boxWidth: CGFloat) {
        self.boxWidth = boxWidth
    }
    func body (content: Content) -> some View {
        content
            .frame(maxWidth: boxWidth, alignment: .leading)
            .foregroundStyle(playerFontColor)
            .font(playerFont)
            .padding(10)
            .border(.gray)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
    }
}

extension View {
    func playerBoxAllStyle (boxWidth: CGFloat) -> some View {
        modifier (playerBoxStyle(boxWidth: boxWidth))
    }
}


