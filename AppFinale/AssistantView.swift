import SwiftUI

struct AssistantView: View {
    
   @State var frase : String = "Ciao"
    @State var animateBigCircle = false
    @State var animateSmallCircle = false
   @ObservedObject var speechRecognizer : SpeechRecognizer = SpeechRecognizer(recipe: Recipe.pancake)
    var timerView : TimerView = TimerView()

    
    var body: some View {
        
        VStack(alignment: .center){
            HStack(alignment: .center, spacing: 100){
                Button(action: {speechRecognizer.previousStep()}, label: {Text("<").bold().padding()
                        .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                    .controlSize(.large).font(.largeTitle)})
                Text("Step \(speechRecognizer.step + 1)").font(.largeTitle).bold()
                Button(action: {speechRecognizer.nextStep()}, label: {Text(">").bold().padding()
                        .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                    .controlSize(.large).font(.largeTitle)})
            }
            Form {
                
                Section(){
                    Text(speechRecognizer.pancakesSteps[speechRecognizer.step]).padding()
                }.padding(.all)
                
            }
            VStack {
                if speechRecognizer.displayTimer {
                    timerView
                }
            }
            
            ZStack { //here
                if speechRecognizer.givingCommand {
                Circle()
                    .stroke()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .scaleEffect(animateBigCircle ? 1 : 0.3)
                    .opacity(animateBigCircle ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                        .onAppear(){
                            self.animateBigCircle.toggle()
                        }
                Circle()
                    .foregroundColor(Color(red: 0.905, green: 0.91, blue: 0.91))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateSmallCircle ? 0.9 : 1.1)
                    .animation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: false))
                    .onAppear(){
                        self.animateSmallCircle.toggle()
                    }
                }
                ZStack{
                    Circle()
                        .frame(width: 72, height: 72)
                        .foregroundColor(.red)
                    Capsule()
                        .frame(width: 12, height: 24)
                        .foregroundColor(.white)
                        .offset(y: -5)
                    Capsule()
                        .trim(from: 1/2, to: 1)
                        .stroke(lineWidth: 3)
                        .frame(width: 22, height: 24)
                        .rotationEffect(.degrees(180))
                        .foregroundColor(.white)
                        .offset(y: -2)
                    Rectangle()
                        .frame(width: 4, height: 6)
                        .foregroundColor(.white)
                        .offset(y: 14)
                }
            }.padding(.all)
        
    }
        .onAppear{
            speechRecognizer.transcribe()
        }
        .onDisappear{
            speechRecognizer.stopTranscribing()
            speechRecognizer.synthetizer.stopSpeaking(at: .immediate)
        }

}

struct AssistantView_Previews: PreviewProvider {
    static var previews: some View {
        AssistantView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
}
