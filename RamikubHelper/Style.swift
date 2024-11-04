//
//  Style.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 11/3/24.
//

import SwiftUI

let controlFont: Font = .title3
let goldColor = Color(red: 255/255, green: 215/255, blue: 0/255)

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
