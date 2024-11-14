//
//  RamikubHelperApp.swift
//  RamikubHelper
//
//  Created by Fernando Mousinho on 10/13/24.
//

import SwiftUI

@main
struct RamikubHelperApp: App {
    @State private var game = RamikubViewModel()
    var body: some Scene {
        WindowGroup {
            MainView().environment(game)
        }
    }
}
