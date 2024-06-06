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
    
    var animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        viewModel.showMoreProducts = false
                    }
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
            
//            if let products = viewModel.filteredProducts {
                ScrollView(.vertical, showsIndicators: false) {
                    StaggeredGrid(columns: 2, spacing: 20, list: viewModel.filteredProducts) { product in
                        // Card View
                        ProductCardView(product: product)
                    }
                    .padding()
                }
//            }
        }
        .background(Color.white.ignoresSafeArea())
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
                    .matchedGeometryEffect(id: "\(product.id)MORE", in: animation)
                }
            }
            .cornerRadius(25)
            .frame(width: getRect().width/2.5, height: getRect().width/2.5)
            Text(product.title)
                .font(.custom(customFont, size: 18))
                .padding(.top)
            Text(product.brand ?? "No brand")
                .font(.custom(customFont, size: 14))
                .foregroundColor(.gray)
            Text(String(format: NSLocalizedString("£%@", comment: "Item price"), "\(product.price)")).bold()
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
                sharedData.screen = .More
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
}

struct MoreProductsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsScreen(animation: Namespace().wrappedValue)
            .environmentObject(HomeScreenViewModel(apiService: APIService()))
            .environmentObject(SharedDataViewModel())
    }
}
