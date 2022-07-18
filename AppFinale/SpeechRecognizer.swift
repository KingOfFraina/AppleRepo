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
    var phase: Int = 0
    let synthetizer = AVSpeechSynthesizer()
    var userConfirms = ["i did it", "i've done", "let's go on"]
    var pancakesSteps = ["Hello! To make pancakes you need: 125 grams of flour, 25 grams of butter, 2 eggs, 200 milliliters of milk, 15 grams of sugar, 6 grams of baking powder for cakes, are you sure you have it",
                         
        "Good, then let’s get started! First you need to melt the butter. After putting the butter in a small saucepan, put it on the stove over low heat. Call me when it’s ready.",
                         
        "Now it’s time to separate the egg yolks from the whites. Use two different bowls. I’ll wait here.",
                         
        "Well done! Now use a whisk to beat eggs together with the melted butter and the milk. I suggest to add also a pinch of salt. Call me when the mixture is clear and homogeneous.",
                         
        "Add the baking powder to the flour and use a sieve to sift the mix of powders. Then mix it with the previous compound.",
                         
        "Add the sugar to the egg whites and use the electric whisk to whip them until the compound is white and foamy.",
                         
        "Now add this mixture to the one with the yolks and slowly mix it so that became a smooth cream. Come on, it’s almost over!",
                         
        "It’s time to cook! Put a cooking pan on the stove over low heat and grease it with butter. Use a scoop to take a small quantity of dough and pour it in the pan slowly. The more precise you’ll be the more perfect disk you’ll obtain. Wait about 2 minutes and you’ll see some bubbles on the pancakes. Do you see them?",
                         
        "Good so take a spatula and turn the pancake. Then wait another minute.",
                         
        "Perfect! You just have to repeat this stage until you cook the entire dough. Then use your creativity and fantasy to decorate the dessert and enjoy it! See you in the kitchen for another recipe, bye!"
    ]

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
     
        Creates a SFSpeechRecognitionTask that transcribes speech to text until you call stopTranscribing().
        The resulting transcription is continuously written to the published transcript property.
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
        if transcript.localizedCaseInsensitiveContains("ok john"){
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
                    if(phase == 0){

                        if(command.localizedCaseInsensitiveContains("yes")){
                           self.stopTranscribing()
                           self.transcribe()
                           print("DONE")
                           commandTimer?.invalidate();
                           givingCommand = false
                           notUnderstood = false
                           command = ""
                           phase = phase + 1
                           let utterance = AVSpeechUtterance(string: pancakesSteps[phase])
                           utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                           utterance.pitchMultiplier = 1.5
                           utterance.rate = 0.43
                           synthetizer.speak(utterance)
                       }
                    } else if(phase < pancakesSteps.capacity - 1){
                        var contains = false
                        for userConfirm in userConfirms {
                            if(command.localizedCaseInsensitiveContains(userConfirm)){
                                contains = true
                                break
                            }
                        }
                        if contains {
                           self.stopTranscribing()
                           self.transcribe()
                           print("DONE")
                           commandTimer?.invalidate();
                           givingCommand = false
                           notUnderstood = false
                           command = ""
                           phase = phase + 1
                           let utterance = AVSpeechUtterance(string: pancakesSteps[phase])
                           utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                           utterance.pitchMultiplier = 1.5
                           utterance.rate = 0.43
                           synthetizer.speak(utterance)
                       }

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
