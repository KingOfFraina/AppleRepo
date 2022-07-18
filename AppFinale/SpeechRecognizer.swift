/*
See LICENSE folder for this sample’s licensing information.
*/

import AVFoundation
import Foundation
import Speech
import SwiftUI

/// A helper for transcribing speech to text using SFSpeechRecognizer and AVAudioEngine.
class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }

    
    var transcript: String = ""
    private var commandTimer: Timer?
    var notUnderstood = false //if the assistant already said "I didn't understand" he won't say it anymore until he will receive a valid command
    var recipe: Recipe
    var command: String = ""
    var lastInteraction: String = ""
    var givingCommand: Bool = false
    var phase: Int = 1
    let synthetizer = AVSpeechSynthesizer()

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init(recipe: Recipe) {
        self.recipe = recipe
        recognizer = SFSpeechRecognizer()
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
            if !self.givingCommand {
                self.stopTranscribing()
                self.transcribe()
                print("Timer fired!")
            }
        }
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
        let utterance = AVSpeechUtterance(string: "Hello! To make pancakes you need: 125 grams of flour, 25 grams of butter, 2 eggs, 200 milliliters of milk, 15 grams of sugar, 6 grams of baking powder for cakes, are you sure you have it all?")
//        let utterance = AVSpeechUtterance(string: "Hello")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synthetizer.speak(utterance)
    }
    
    @objc func fireTimer() {
        if !notUnderstood{
            print("Scusa non ho capito...")
            notUnderstood = true
        }
        self.stopTranscribing()
        self.transcribe()
    }
    
    deinit {
        reset()
    }
    
    /**
        Begin transcribing audio.
     
        Creates a `SFSpeechRecognitionTask` that transcribes speech to text until you call `stopTranscribing()`.
        The resulting transcription is continuously written to the published `transcript` property.
     */
    func transcribe() {
        DispatchQueue(label: "Speech Recognizer Queue", qos: .background).async { [weak self] in
            guard let self = self, let recognizer = self.recognizer, recognizer.isAvailable else {
                self?.speakError(RecognizerError.recognizerIsUnavailable)
                return
            }
            
            do {
                let (audioEngine, request) = try Self.prepareEngine()
                self.audioEngine = audioEngine
                self.request = request
                self.task = recognizer.recognitionTask(with: request, resultHandler: self.recognitionHandler(result:error:))
            } catch {
                self.reset()
                self.speakError(error)
            }
        }
    }
    
    /// Stop transcribing audio.
    func stopTranscribing() {
        reset()
    }
    
    /// Reset the speech recognizer.
    func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(result: SFSpeechRecognitionResult?, error: Error?) {
        print("TRANSCRIPT: \(transcript)")
        print("COMMAND: \(command)")
        if transcript.localizedCaseInsensitiveContains("ok fabio"){
            givingCommand = true
            stopTranscribing()
            transcribe()
            transcript = ""
            commandTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
            return
        }
        if givingCommand {
            print("COMMAND")
            switch recipe {
                case .pancake:
                    switch phase{
                        case 1:
                            if command.localizedCaseInsensitiveContains("yes"){
                                commandTimer?.invalidate();
                                givingCommand = false
                                notUnderstood = false
                                command = ""
                                phase = 2
                                let utterance = AVSpeechUtterance(string: "Good, then let’s get started! First you need to melt the butter. After putting the butter in a small saucepan, put it on the stove over low heat. Call me when it’s ready.")
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                                utterance.pitchMultiplier = 1.5
                                utterance.rate = 0.43
                                synthetizer.speak(utterance)
                            }
                        case 2:
                            print(command.localizedCaseInsensitiveContains("i've done"))
                            if command.localizedCaseInsensitiveContains("i've done"){
                                self.stopTranscribing()
                                self.transcribe()
                                print("DONE")
                                commandTimer?.invalidate();
                                givingCommand = false
                                notUnderstood = false
                                command = ""
                                phase = 3
                                let utterance = AVSpeechUtterance(string: "Now it’s time to separate the egg yolks from the whites. Use two different bowls. I’ll wait here.")
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                                utterance.pitchMultiplier = 1.5
                                utterance.rate = 0.43
                                synthetizer.speak(utterance)
                            }
                    case 3:
                        if command.localizedCaseInsensitiveContains("i did it"){
                            self.stopTranscribing()
                            self.transcribe()
                            commandTimer?.invalidate();
                            givingCommand = false
                            notUnderstood = false
                            command = ""
                            phase = 4
                            let utterance = AVSpeechUtterance(string: "Well done! Now use a whisk to beat eggs together with the melted butter and the milk. I suggest to add also a pinch of salt. Call me when the mixture is clear and homogeneous.")
                            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                            utterance.pitchMultiplier = 1.5
                            utterance.rate = 0.43
                            synthetizer.speak(utterance)
                        }
                    case 4:
                        if command.localizedCaseInsensitiveContains("let's go on"){
                            self.stopTranscribing()
                            self.transcribe()
                            commandTimer?.invalidate();
                            givingCommand = false
                            notUnderstood = false
                            command = ""
                            phase = 4
                            let utterance = AVSpeechUtterance(string: "Add the baking powder to the flour and use a sieve to sift the mix of powders. Then mix it with the previous compound.")
                            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                            utterance.pitchMultiplier = 1.5
                            utterance.rate = 0.43
                            synthetizer.speak(utterance)
                        }
                        default: print("error")
                
                    }
            }
        }
        
        if command.localizedCaseInsensitiveContains("cuciniamo la pizza"){
            commandTimer?.invalidate();
            givingCommand = false
            notUnderstood = false
            command = ""
        }

//        let receivedFinalResult = result?.isFinal ?? false
//        let receivedError = error != nil
//
//        if receivedFinalResult || receivedError {
//            audioEngine?.stop()
//            audioEngine?.inputNode.removeTap(onBus: 0)
//        }
        
        if let result = result {
            if givingCommand {
                command = result.bestTranscription.formattedString
            } else {
                transcript = result.bestTranscription.formattedString
            }
        }
    }
    
    private func speak(_ message: String) {
        transcript = message
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
