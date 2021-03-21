//
//  StartPageView.swift
//  SaboteurGame
//
//  Created by Alex on 21/3/21.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
           Color(#colorLiteral(red: 0.976400435, green: 0.9137675166, blue: 0.03151589632, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            .ignoresSafeArea()
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()    
    }
}
