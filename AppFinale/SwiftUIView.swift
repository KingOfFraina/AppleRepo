//
//  SwiftUIView.swift
//  AppFinale
//
//  Created by Francesco Esposito on 19/07/22.
//

import SwiftUI

struct SwiftUIView: View {
    
    
    
    var body: some View {
        
        Text("Ciao")
            .font(.custom("cream-DEMO", size: 50))
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
