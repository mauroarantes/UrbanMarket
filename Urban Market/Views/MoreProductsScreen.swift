//
//  MoreProductsScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 23/10/2023.
//

import SwiftUI

struct MoreProductsScreen: View {
    
    @EnvironmentObject var viewModel: HomeScreenViewModel
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
//                    withAnimation {
//                        viewModel.searchActive = false
//                    }
//                    viewModel.searchText = ""
//                    sharedData.fromSearchScreen = false
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(Color.black.opacity(0.7))
                }
                Text(viewModel.productType.rawValue.capitalized)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(customFont, size: 28).bold())
            }
            .padding()
            
            // Filter Results
            
            if let products = viewModel.filteredProducts {
//                if products.isEmpty {
//                    VStack(spacing: 0) {
//                        Text("Item Not Found")
//                            .font(.custom(customFont, size: 24).bold())
//                            .padding(.vertical)
//                    }
//                    .padding()
//                } else {
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
//                }
            }
//            else {
//                ProgressView()
//                    .padding(.top, 30)
//                    .opacity(viewModel.searchText == "" ? 0 : 1)
//            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        VStack {
//            Text("More Products")
//                .font(.custom(customFont, size: 24).bold())
//                .foregroundColor(.black)
//                .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .padding()
//        .background(Color.gray.opacity(0.1).ignoresSafeArea())
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
                    .matchedGeometryEffect(id: "\(product.id)IMAGE", in: animation)
                }
            }
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
        .padding(.horizontal, 10)
        .padding(.bottom, 22)
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

struct MoreProductsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsScreen(animation: Namespace().wrappedValue)
            .environmentObject(HomeScreenViewModel())
            .environmentObject(SharedDataViewModel())
    }
}
