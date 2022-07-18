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
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
            HStack{
                Text("Ricetta").font(.largeTitle).bold()
                
                
            }
                
            VStack(alignment: .leading) {
                                
                HStack {
                                    
                    Image("pancake").resizable().aspectRatio(contentMode: .fit).frame(width: 250, height: 250).clipShape(Rectangle())
                                    
                VStack(alignment: .center) {
                    Text("Pancakes are a typical breakfast dessert from the United States of America. Difficulty: easy \nPreparation time: 20 min").font(.title)
    
                                    }
                                }
                                
                                }
                                .padding()
                
            Spacer()
            
                Button(action: {}, label: {Text("Start")}).font(.title).border(.red)
                Divider().scaledToFit()
            HStack{
                Text("Here some hint for you").font(.title).bold()
            }
            HStack{
                
                    VStack(alignment: .leading){
                        
                        Text("Separate yolk from white").fontWeight(.medium)
                        
                        Button(action: {
                            self.searchIsPresented=true
                        }, label: {Image("egg_separate").resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 250).clipShape(Rectangle())})
                        
                        
                        
                        
                    }//chiusura Vstack 1 consiglio
                    
                
            
                
                
                    VStack(alignment: .leading){
                        
                        Text("Decorate sweets").fontWeight(.medium)
                        
                        Button(action: {
                            self.hint=true
                        }, label: {Image("decorate").resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 250).clipShape(Rectangle())})
                        
                    }//chiusura Vstack 2 consiglio
                    
                
                
                
            }//Chiusura hstack parte inferiore
            Spacer()
            }//Chiusura VStack Principale
            
        }.navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $searchIsPresented, content: {
                
                VStack(alignment: .center){
                    Text("Separate yolk from white")
                    
                    Text("Learn how to..")
                    
                    Button(action: {}, label: {Text("Start")}).font(.title)
                }
                Spacer()
                
            })
            .sheet(isPresented: $hint, content: {VStack(alignment: .center){
                Text("Decorate your dessert")
                
                Text("Learn how to..")
                
                Button(action: {}, label: {Text("Start")}).font(.title)
            }
            Spacer()})
    }
}

struct RicettaView_Previews: PreviewProvider {
    static var previews: some View {
        RicettaView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
