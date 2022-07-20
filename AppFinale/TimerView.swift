//
//  TimerView.swift
//  AppFinale
//
//  Created by Vincenzo Emanuele Martone on 19/07/22.
//

import SwiftUI

struct TimerView: View {
    @StateObject var vm = TimerModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
        VStack {
            Text("\(vm.time)")
                .font(.system(size: 50, weight: .medium, design: .rounded))
                .alert("Timer done!", isPresented: $vm.showingAlert) {
                    Button("Continue", role: .cancel) {
                        // Code
                    }
                }
                .padding()
                .frame(width: width, height: 50)
                .background(.thinMaterial)
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 4)
                    )

            
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        .onAppear {
            vm.start(minutes: 2)
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
