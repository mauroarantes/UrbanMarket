//
//  ProductDetailScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 26/10/2023.
//

import SwiftUI

struct ProductDetailScreen: View {
    var product: Product
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    @EnvironmentObject var homeData: HomeScreenViewModel
    
    var body: some View {
        VStack {
            // Title bar and image
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            sharedData.showDetailProduct = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    Spacer()
                    Button {
                        addToLiked()
                    } label: {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .foregroundColor(isLiked() ? .red : .black.opacity(0.7))
                    }
                }
                .padding()
                
                AsyncImage(url: URL(string: product.images.first ?? ""), content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .offset(y: -12)
                        .frame(maxHeight: .infinity)
                }, placeholder: {
                    ProgressView()
                })
                .matchedGeometryEffect(id: "\(product.id)\(sharedData.fromSearchScreen ? "SEARCH" : "IMAGE")", in: animation)
                
            }
            .frame(height: getRect().height/2.7)
            // Details
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(product.title)
                        .font(.custom(customFont, size: 20).bold())
                    Text(product.description)
                        .font(.custom(customFont, size: 18))
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Total")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.orange)
                        Spacer()
                        Text("£\(product.price)")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical, 20)
                    
                    // Add button
                    Button {
                        addToCart()
                    } label: {
                        Text("Add to basket")
                            .font(.custom(customFont, size: 20).bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                Color.orange
                                    .cornerRadius(15)
                                    .shadow(color: .black.opacity(0.06), radius: 5, x: 5, y: 5)
                            )
                    }
                }
                .padding([.horizontal, .bottom], 20)
                .padding(.top, 25)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.gray.opacity(0.1)
                    .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                    .ignoresSafeArea()
            )
        }
        .animation(.easeInOut, value: sharedData.likedProducts)
        .animation(.easeInOut, value: sharedData.cartProducts)
        .background(Color.white.ignoresSafeArea())
    }
    
    func isLiked() -> Bool {
        return sharedData.likedProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func isAddedToCart() -> Bool {
        return sharedData.cartProducts.contains { product in
            return self.product.id == product.id
        }
    }
    
    func addToLiked() {
        if let index = sharedData.likedProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            //Remove
            sharedData.likedProducts.remove(at: index)
        } else {
            //Add
            sharedData.likedProducts.append(product)
        }
    }
    
    func addToCart() {
        if let index = sharedData.cartProducts.firstIndex(where: { product in
            return self.product.id == product.id
        }) {
            //Remove
            sharedData.cartProducts.remove(at: index)
        } else {
            //Add
            sharedData.cartProducts.append(product)
        }
    }
}

struct ProductDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailScreen(product: Product(id: 0, title: "title", description: "desc", price: 2, discountPercentage: 4, rating: 6, stock: 8, brand: "brand", category: "cat", thumbnail: "thumb", images: ["images"]), animation: Namespace().wrappedValue)
            .environmentObject(SharedDataViewModel())
    }
}
