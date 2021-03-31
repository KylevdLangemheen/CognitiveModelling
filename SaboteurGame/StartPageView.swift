//
//  StartPageView.swift
//  SaboteurGame
//
//  Created by Alex on 21/3/21.
//

import SwiftUI
import PopupView

struct StartPageView: View {

    @State private var selection: String? = nil
    @State private var isGameViewShowing: Bool = false
    @State private var isPopUpShowing: Bool = false

    var body: some View {

        NavigationView {
            NavigationLink(destination: GameView(viewModel: PlayingFieldViewModel()), tag: "Game", selection: $selection) { EmptyView()}

            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))]), startPoint: .leading, endPoint: .trailing).ignoresSafeArea()
                VStack{
                    Image("Saboteur_letters")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading)
                    Button(action: {
                        self.selection = "Game"
                        self.isGameViewShowing = true
                        self.isPopUpShowing =  true
                    }) {
                        HStack {
                            Text("Start Game").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))).multilineTextAlignment(.center)
                        }
                        .frame(minWidth: 0, maxWidth: 340.0)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4494178891, green: 0.3634631038, blue: 0.003429454286, alpha: 1)), Color(#colorLiteral(red: 0.979470551, green: 0.9008276463, blue: 0.006413663272, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
                                        )
                        .cornerRadius(40)
                    }


                }
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
//         .popup(isPresented: $isPopUpShowing, type: .toast, position: .bottom, animation: .easeInOut, autohideIn: 3, closeOnTap: true, closeOnTapOutside: false, view: {
//            Toast()
//        })
    }
}


struct Toast: View {
    var body: some View {
        ZStack {
            Color.blue
            HStack {
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .foregroundColor(Color.white)
                    .padding()
                Text("Initializing...")
                    .foregroundColor(.white).font(.largeTitle)
            }
            .padding()
        }
        .cornerRadius(12)
        .padding()
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
