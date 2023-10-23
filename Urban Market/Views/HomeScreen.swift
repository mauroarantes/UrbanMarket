//
//  ContentView.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI
import CoreData

struct HomeScreen: View {

    @Namespace var animation
    @StateObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search", text: .constant(""))
                        .disabled(true)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(.gray, lineWidth: 0.8)
                )
                .frame(width: getRect().width / 1.6)
                .padding(.horizontal, 25)
                
                Text("Order online\ncollect in store")
                    .font(.custom(customFont, size: 28).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                // Products tab
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(ProductType.allCases, id: \.self) { productType in
                            ProductTypeView(type: productType.rawValue)
                                .font(.custom(customFont, size: 15))
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 28)
            }
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    func ProductTypeView(type: String) -> some View {
        Button {
            withAnimation {
                viewModel.productType = ProductType(rawValue: type) ?? .fragances
            }
        } label: {
            Text(type.capitalized)
                .foregroundColor(viewModel.productType.rawValue == type ? .orange : .gray)
                .padding(.bottom, 10)
                .overlay(
                    ZStack {
                        if viewModel.productType.rawValue == type {
                            Capsule()
                                .fill(.orange)
                                .matchedGeometryEffect(id: "PRODUCTTAB", in: animation)
                                .frame(height: 2)
                        } else {
                            Capsule()
                                .fill(.clear)
                                .frame(height: 2)
                        }
                    }
                        .padding(.horizontal, -5)
                    , alignment: .bottom)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}

extension Array {
    func group<T: Hashable>(by key: (_ element: Element) -> T) -> [[Element]] {
        var categories: [T: [Element]] = [:]
        for element in self {
            let key = key(element)
            categories[key, default: []].append(element)
        }
      return categories.values.map { $0 }
    }
}
