import SwiftUI

struct AssistantView: View {
    
   @State var frase : String = "Ciao"
    @State var animateBigCircle = false
    @State var animateSmallCircle = false
   @ObservedObject var speechRecognizer : SpeechRecognizer = SpeechRecognizer(recipe: Recipe.pancake)
    var timerView : TimerView = TimerView()

    
    var body: some View {
        ZStack{
            Color(hex: 0xF9EEE6).ignoresSafeArea()
            VStack(alignment: .center){
                HStack(alignment: .center, spacing: 100){
                    Button(action: {speechRecognizer.previousStep()}, label: {Text("<").bold().padding()
                            .foregroundColor(Color(hex: 0x763129))
                            .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                        .controlSize(.large).font(.largeTitle)})
                    Text("Step \(speechRecognizer.step + 1)").foregroundColor(Color(hex: 0x4a5364))
                        .font(.custom("cream-DEMO", size: 26))
                    Button(action: {speechRecognizer.nextStep()}, label: {Text(">").bold().padding()
                            .foregroundColor(Color(hex: 0x763129))
                            .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                        .controlSize(.large).font(.largeTitle)})
                }
                
                
                    
                        Text(speechRecognizer.pancakesSteps[speechRecognizer.step])
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(130)
                    .foregroundColor(Color(hex: 0x4a5364))
                    .font(.custom("cream-DEMO", size: 26))
                
                        
                    
                
            
                VStack {
                    if speechRecognizer.displayTimer {
                        timerView
                    }
                }
                
                if !speechRecognizer.displayTimer{
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
                            .foregroundColor(Color(hex: 0x763129))
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
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                speechRecognizer.transcribe()
            }
            .onDisappear{
                speechRecognizer.stopTranscribing()
                speechRecognizer.synthetizer.stopSpeaking(at: .immediate)
            }
        }
       

}

struct AssistantView_Previews: PreviewProvider {
    static var previews: some View {
        AssistantView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
}
