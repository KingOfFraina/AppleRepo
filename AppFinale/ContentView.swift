/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
        }
        .padding()
        .onAppear {
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            isRecording = true
        }
        .onDisappear {
            speechRecognizer.stopTranscribing()
            isRecording = false
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

