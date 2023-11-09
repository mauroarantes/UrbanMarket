//
//  LikedScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 26/10/2023.
//

import SwiftUI

struct LikedScreen: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text(NSLocalizedString("Favourites", comment: "Favourites screen title"))
                            .font(.custom(customFont, size: 28).bold())
                        Spacer()
                        Button {
                            withAnimation {
                                showDeleteOption.toggle()
                            }
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.orange)
                        }
                        .opacity(sharedData.likedProducts.isEmpty ? 0 : 1)

                    }
                    
                    if sharedData.likedProducts.isEmpty {
                        Group {
                            Text(NSLocalizedString("No favourites", comment: "No favourites"))
                                .font(.custom(customFont, size: 25).bold())
                                .foregroundColor(.orange)
                        }
                        .padding()
                    } else {
                        VStack(spacing: 15) {
                            ForEach(sharedData.likedProducts) { product in
                                HStack(spacing: 0) {
                                    if showDeleteOption {
                                        Button {
                                            deleteProduct(product: product)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.red)
                                        }
                                        .padding(.trailing)

                                    }
                                    CardView(product: product)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) {
                                                sharedData.screen = .Liked
                                                sharedData.detailProduct = product
                                                sharedData.showDetailProduct = true
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .onDisappear {
                showDeleteOption = false
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
    }
    
    @ViewBuilder
    func CardView(product: Product) -> some View {
        HStack(spacing: 15) {
            ZStack {
                if sharedData.showDetailProduct {
                    AsyncImage(url: URL(string: product.images.first ?? ""), content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
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
                    .matchedGeometryEffect(id: "\(product.id)LIKED", in: animation)
                }
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                Text(String(format: NSLocalizedString("£%@", comment: "Item price"), "\(product.price)"))
                    .font(.custom(customFont, size: 17).bold())
                    .foregroundColor(.orange)
                Text(String(format: NSLocalizedString("Category: %@", comment: "Category label"), NSLocalizedString(product.category, comment: "Category button label").capitalized))
                    .font(.custom(customFont, size: 13))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1).cornerRadius(10))
    }
    
    func deleteProduct(product: Product) {
        if let index = sharedData.likedProducts.firstIndex(where: { currentProduct in
            return product.id == currentProduct.id
        }) {
            let _ = withAnimation {
                sharedData.deleteLikedProduct(id: sharedData.likedProducts[index].id)
                sharedData.likedProducts.remove(at: index)
            }
        }
    }
}
