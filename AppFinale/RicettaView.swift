//
//  RicettaView.swift
//  AppFinale
//
//  Created by Manuel Di Giacomo on 15/07/22.
//

import SwiftUI

struct RicettaView: View {
    @State var searchIsPresented: Bool = false
    @State var hint: Bool = false
    
    let color = Color(hex: 0x763129)

    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
            HStack{
                Text("Pancake").font(.largeTitle).bold()
                
                
            }
                
            VStack(alignment: .leading) {
                                
                HStack {
                                    
                    Image("image1").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                                    
                    VStack(alignment: .leading) {
                        Text("Pancakes are a typical breakfast dessert from the United States of America. \nDifficulty: easy \nPreparation time: 20 min")
    
                }
            }
                                
}.padding()
                
            Spacer()
            
                Button(action: {}, label: {Text("Start")}).tint(color)
                    .padding()
                    .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                Divider().scaledToFit()
            HStack{
                Text("Suggested lessons").font(.title).bold()
                
            }
                Spacer()
                HStack(alignment: .center, spacing: 200){
                
                VStack(alignment: .leading,spacing: -50){
                
                    Text("    Separate yolk from white").fontWeight(.medium)
                        
                        Button(action: {
                            self.searchIsPresented=true
                        }, label: {Image("image3").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)})
                        
                        
                        
                        
                    }//chiusura Vstack 1 consiglio
                    
                
                    
                
                
                VStack(alignment: .leading,spacing:-50){
                        
                        Text("    Decorate sweets").fontWeight(.medium)
                        
                        Button(action: {
                            self.hint=true
                        }, label: {Image("image2").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)})
                        
                    }//chiusura Vstack 2 consiglio
                    
                
                
                
            }//Chiusura hstack parte inferiore
            Spacer()
            }//Chiusura VStack Principale
            
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
