//
//  SearchScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 24/10/2023.
//

import SwiftUI

struct SearchScreen: View {
    
    @EnvironmentObject var viewModel: HomeScreenViewModel
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @FocusState var startTF: Bool
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        viewModel.searchActive = false
                    }
                    viewModel.searchText = ""
                    sharedData.fromSearchScreen = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)
                    TextField("Search", text: $viewModel.searchText)
                        .focused($startTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(
                    Capsule()
                        .strokeBorder(.orange, lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing, 20)
            }
            .padding([.horizontal, .top])
            
            // Filter Results
            
            if let products = viewModel.searchedProducts {
                if products.isEmpty {
                    VStack(spacing: 0) {
                        Text("Item Not Found")
                            .font(.custom(customFont, size: 24).bold())
                            .padding(.vertical)
                    }
                    .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Text("Found \(products.count) results")
                                .font(.custom(customFont, size: 24).bold())
                                .padding(.vertical)
                            StaggeredGrid(columns: 2, spacing: 20, list: products) { product in
                                // Card View
                                ProductCardView(product: product)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView()
                    .padding(.top, 30)
                    .opacity(viewModel.searchText == "" ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startTF = true
            }
        }
    }
    
    @ViewBuilder
    func ProductCardView(product: Product) -> some View {
        VStack(spacing: 10) {
            ZStack {
                if sharedData.showDetailProduct {
                    AsyncImage(url: URL(string: product.images.first ?? ""), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0)
                    }, placeholder: {
                        ProgressView()
                    })
                } else {
                    AsyncImage(url: URL(string: product.images.first ?? ""), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }, placeholder: {
                        ProgressView()
                    })
                    .matchedGeometryEffect(id: "\(product.id)SEARCH", in: animation)
                }
            }
            .cornerRadius(25)
            .frame(width: getRect().width/2.5, height: getRect().width/2.5)
            Text(product.title)
                .font(.custom(customFont, size: 18))
                .padding(.top)
            Text(product.brand)
                .font(.custom(customFont, size: 14))
                .foregroundColor(.gray)
            Text("£\(product.price)").bold()
                .font(.custom(customFont, size: 16))
                .padding(.top)
                .foregroundColor(.orange)
        }
        .padding([.horizontal, .top], 10)
        .padding(.bottom, 20)
        .background(Color.gray.opacity(0.1)
                .cornerRadius(25))
        .onTapGesture {
            withAnimation(.easeInOut) {
                sharedData.fromSearchScreen = true
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
