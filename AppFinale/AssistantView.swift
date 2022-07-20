import SwiftUI

struct AssistantView: View {

    

   @State var frase:String = "Ciao"

    

    var body: some View {

        

        VStack(alignment: .center){

            HStack(alignment: .center, spacing: 100){

                Button(action: {}, label: {Text("<").bold().padding()

                        .buttonStyle(.borderedProminent)

                            .buttonBorderShape(.capsule)

                    .controlSize(.large).font(.largeTitle)})

                Text("Step x").font(.largeTitle).bold()

                Button(action: {}, label: {Text(">").bold().padding()

                        .buttonStyle(.borderedProminent)

                            .buttonBorderShape(.capsule)

                    .controlSize(.large).font(.largeTitle)})

            }

            Form {

                

                

                

                Section(header:Text("John:")){

                    TextField("", text: $frase).padding()

                }.padding(.all)

                

                

                

                

                

                

            }.padding(.all)

            

            Button(action: {}, label: {Image("mic").resizable().frame(width: 100, height: 100, alignment: .center)})

             

            

            

       

            

        

            

        

    }.navigationBarBackButtonHidden(true)

}

struct AssistantView_Previews: PreviewProvider {

    static var previews: some View {

        AssistantView()

            .previewInterfaceOrientation(.landscapeLeft)

    }

}

}
