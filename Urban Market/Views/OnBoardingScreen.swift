//
//  OnBoardingScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI

let customFont = "Raleway-Regular"

struct OnBoardingScreen: View {
    var body: some View {
        VStack {
            Text("Find your\nGadget")
                .font(.custom(customFont, size: 55))
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image("onBoarding")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Button {
                
            } label: {
                Text("Get started")
                    .font(.custom(customFont, size: 18))
                    .fontWeight(.semibold)
                    .padding(.vertical, 22)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 22)
            Spacer()
        }
        .padding()
        .padding(.top, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            Color.gray
        )
    }
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingScreen()
    }
}
