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
    
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.red],
        startPoint: .top, endPoint: .bottom)
    
    
    
    @State var searchText = ""
    var body: some View {
        
        
        NavigationView{
            GeometryReader{ geo in
                ZStack{
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment:.center)
                        .opacity(1.0)
                    
                    ScrollView(.vertical){
                        HStack{
                            VStack{
                                Text("Recipes")
                                    .font(.custom("cookie-crisp", size: 46))
                            }
                            
                        }
                        LazyVGrid(columns: layout, content:{
                            VStack{
                                NavigationLink(destination: RicettaView(), isActive: self.$isActive){
                                    Text("")
                                }
                                Button(action: { self.isActive = true}){
                                    
                                    Image("image1").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                }
                                Spacer()
                                
                                Text("Pancake").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                            }
                            VStack{
                                Image("image4").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                Spacer()
                                Text("Hot-Dog").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                            }
                            VStack{
                                Image("image8").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                Spacer()
                                Text("Pizza").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                            }
                            VStack{
                                Image("image7").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                Spacer()
                                Text("Carbonara").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                            }
                            VStack{
                                Image("image9").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                Spacer()
                                Text("Raspberry Tart").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                            }
                            VStack{
                                Image("image5").resizable().aspectRatio(contentMode:  .fit).border(Color.secondary).cornerRadius(30).padding().frame(width: 250, height: 250, alignment: .leading)
                                Spacer()
                                Text("Hamburger").padding(-40)
                                    .font(.custom("cream-DEMO", size: 23))
                                
                            }
                        })
                    }.searchable(text: $searchText).padding(.horizontal)
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

