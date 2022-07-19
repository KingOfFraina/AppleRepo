/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct ContentView: View {
    let items = Array(1...6).map({ "image\($0)" })
    
    @State private var isActive: Bool = false
    
    let layout = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50))
    ]
    
    
    @State var searchText = ""
    var body: some View {
        NavigationView{
            ScrollView(.vertical){
                LazyVGrid(columns: layout, content:{
                    VStack{
                        NavigationLink(destination: RicettaView(), isActive: self.$isActive){
                            Text("")
                        }
                        Button(action: { self.isActive = true}){
                            
                            Image("image1").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        }
                        Spacer()
                        
                        Text("Pancake").padding(-40)
                    }
                    VStack{
                        Image("image2").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        Spacer()
                        Text("Hot-Dog").padding(-40)
                    }
                    VStack{
                        Image("image3").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        Spacer()
                        Text("Pizza").padding(-40)
                    }
                    VStack{
                        Image("image4").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        Spacer()
                        Text("Pasta con la carbonara").padding(-40)
                    }
                    VStack{
                        Image("image5").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        Spacer()
                        Text("Torta di fragole").padding(-40)
                    }
                    VStack{
                        Image("image6").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(12).padding().frame(width: 250, height: 250, alignment: .leading)
                        Spacer()
                        Text("Hamburger").padding(-40)
                    }
                })
            }.navigationTitle("Recipes").searchable(text: $searchText)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

