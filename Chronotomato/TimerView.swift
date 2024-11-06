//
//  ContentView.swift
//  Chronotomato
//
//  Created by Michiaki Mizoguchi on 2024/10/07.
//

import SwiftUI

struct TimerView: View {
    @StateObject var viewModel = TimerViewModel()

    var body: some View {
        VStack {
            let timerStatus = viewModel.timerStatus
            switch timerStatus {
            case .stopped:
                Text(timerStatus.remainingTime)
                Button("Start") {
                    viewModel.play()
                }
            case .alarming:
                Text(timerStatus.remainingTime)
                Button("Stop") {
                    viewModel.stop()
                }
            case .playing:
                Text(timerStatus.remainingTime)
                Button("Stop") {
                    viewModel.stop()
                }
            }
        }
        .padding()
    }
}

#Preview {
    TimerView()
}
