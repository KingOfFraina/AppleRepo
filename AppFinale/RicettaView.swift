import SwiftUI

struct RicettaView: View {
    @State var searchIsPresented: Bool = false
    @State var hint: Bool = false
    
    let color = Color(hex: 0x763129)
    let color2 = Color(hex: 0x4a5364)
    let bgcolor = Color(hex: 0xF9EEE6)
    
    
    var body: some View {
        
            NavigationView(){
                GeometryReader{ geo in

                    ZStack(){
                        bgcolor.ignoresSafeArea()
                
                        ScrollView(.vertical){
                    
                        VStack(alignment: .center){
                            HStack{
                                Text("Pancakes")
                                    .foregroundColor(color2)
                                    .font(.custom("cream-DEMO", size: 65))
                                
                                
                            }.padding(-100) //Titolo
                            
                            VStack(alignment: .center) {
                                
                                HStack {
                                    
                                    Image("image1").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Pancakes are a typical breakfast dessert from the United States of America. \nDifficulty: easy \nPreparation time: 20 min")
                                            .foregroundColor(color2)
                                            .font(.custom("cream-DEMO", size: 24))
                                        
                                        
                                    }
                                }.padding(-50) //Ricetta con descrizione
                                
                            }.padding(-20)
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: AssistantView(), label: {Text("Start")}).tint(color)
                                .font(.custom("cream-DEMO", size: 23))
                                .padding(40)
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .controlSize(.large)
                                
                            
                            
                            Divider().scaledToFit()
                            HStack{
                                Text("Suggested lessons").bold()
                                    .font(.custom("cream-DEMO", size: 25))
                                    .foregroundColor(color2)
                                    .underline()
                                
                            }.padding(20)
                            
                            HStack(alignment: .center, spacing: 300){
                                
                                VStack(alignment: .leading,spacing: -50){
                                    
                                    Text("Separate yolk from white").foregroundColor(color2)
                                        .font(.custom("cream-DEMO", size: 23))
                                   
                                    
                                    Button(action: {
                                        self.searchIsPresented=true
                                    }, label: {Image("image3").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)})
                                    
                                    
                                    
                                    
                                }//chiusura Vstack 1 consiglio
                                
                                
                                
                                
                                
                                VStack(alignment: .leading,spacing:-50){
                                    
                                    Text("   Decorate sweets").foregroundColor(color2)
                                        .font(.custom("cream-DEMO", size: 23))
                                    
                                
                                    Button(action: {
                                        self.hint=true
                                    }, label: {Image("image2").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)})
                                    
                                }//chiusura Vstack 2 consiglio
                                
                                
                            }
                                
                            }.padding(50)//Chiusura hstack parte  inferiore
                            Spacer()
                        }//Chiusura VStack Principale
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
                .sheet(isPresented: $searchIsPresented, content: {
                    
                    ModalView()
                    Spacer()
                    
                })
                .sheet(isPresented: $hint, content: {
                    ModalView()
                })
        
        
    }
}

struct RicettaView_Previews: PreviewProvider {
    static var previews: some View {
        RicettaView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
