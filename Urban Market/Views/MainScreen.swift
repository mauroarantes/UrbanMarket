//
//  MainScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI

struct MainScreen: View {
    @Namespace var animation
    
    @StateObject var sharedData = SharedDataViewModel()
    @EnvironmentObject var viewModel: LoginScreenViewModel
    @State var currentTab: Tab = .Home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeScreen(animation: animation)
                    .environmentObject(sharedData)
                    .tag(Tab.Home)
                LikedScreen()
                    .environmentObject(sharedData)
                    .tag(Tab.Liked)
                ProfileScreen()
                    .tag(Tab.Profile)
                    .environmentObject(viewModel)
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
                                .background(
                                    Color.orange
                                        .opacity(0.1)
                                        .cornerRadius(5)
                                        .blur(radius: 5)
                                        .padding(-7)
                                        .opacity(currentTab == tab ? 1 : 0)
                                )
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Liked:
                            Image(systemName: "heart.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .background(
                                    Color.orange
                                        .opacity(0.1)
                                        .cornerRadius(5)
                                        .blur(radius: 5)
                                        .padding(-7)
                                        .opacity(currentTab == tab ? 1 : 0)
                                )
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Profile:
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .background(
                                    Color.orange
                                        .opacity(0.1)
                                        .cornerRadius(5)
                                        .blur(radius: 5)
                                        .padding(-7)
                                        .opacity(currentTab == tab ? 1 : 0)
                                )
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        case .Cart:
                            Image(systemName: "cart.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(currentTab == tab ? .orange : .gray)
                                .background(
                                    Color.orange
                                        .opacity(0.1)
                                        .cornerRadius(5)
                                        .blur(radius: 5)
                                        .padding(-7)
                                        .opacity(currentTab == tab ? 1 : 0)
                                )
                                .frame(width: 44, height: 44)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
        }
        .overlay(
            ZStack {
                if let product = sharedData.detailProduct, sharedData.showDetailProduct {
                    ProductDetailScreen(product: product, animation: animation)
                        .environmentObject(sharedData)
                }
            }
        )
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
