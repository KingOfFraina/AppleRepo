/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation

struct ContentView: View {
    //@StateObject var speechRecognizer
    @State private var isRecording = false
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        Button(action: {SpeechRecognizer(recipe: Recipe.pancake).transcribe()}) {
            Text("Pancake")
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }

}

