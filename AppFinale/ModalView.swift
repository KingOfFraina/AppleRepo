//
//  ModalView.swift
//  AppFinale
//
//  Created by Manuel Di Giacomo on 19/07/22.
//

import SwiftUI

struct ModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let color = Color(hex: 0x763129)
    let col = Color(hex: 0xF9EEE6)
    
    var body: some View {
        NavigationView{
        VStack(alignment: .center, spacing: 150){
            Text("Separate yolk from white").font(.largeTitle)
            
            Text("Learn how to separate egg yolk from white. \nThis is an important stage during lots of recipes.").font(.title)
            
            Button(action: {}, label: {Text("Start")}).tint(color)
                .padding()
                .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
        }.background(col).navigationBarItems(trailing: Button(action: {
            
            dismiss()
            
        }){ Text("x")})
        Spacer()
            
        }.navigationViewStyle(StackNavigationViewStyle())
            
        
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
