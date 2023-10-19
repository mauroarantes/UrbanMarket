//
//  MainScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI

struct MainScreen: View {
    
    @State var currentTab: Tab = .Home
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeScreen()
                    .tag(Tab.Home)
                Text("Liked")
                    .tag(Tab.Liked)
                Text("Profile")
                    .tag(Tab.Profile)
                Text("Cart")
                    .tag(Tab.Cart)
            }
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        currentTab = tab
                    } label: {
                        switch tab {
                        case .Home:
                            Image(systemName: "house.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Liked:
                            Image(systemName: "heart.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Profile:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Cart:
                            Image(systemName: "cart.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

enum Tab: String, CaseIterable {
    case Home = "Home"
    case Liked = "Liked"
    case Profile = "Profile"
    case Cart = "Cart"
}
