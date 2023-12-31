//
//  OnBoardingScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI

let customFont = "Raleway-Regular"

struct OnBoardingScreen: View {
    
    @EnvironmentObject var viewModel: LoginScreenViewModel
    @State var showLoginScreen = false
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("Find your\nGadget", comment: "On Boarding labels"))
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
                withAnimation {
                    showLoginScreen = true
                }
            } label: {
                Text(NSLocalizedString("Get started", comment: "On Boarding labels"))
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
        .overlay(
            Group {
                if showLoginScreen {
                    LoginScreen()
                        .environmentObject(viewModel)
                        .transition(.move(edge: .bottom))
                }
            }
        )
    }
}

struct OnBoardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingScreen()
    }
}
