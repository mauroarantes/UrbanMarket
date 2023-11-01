//
//  LikedScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 26/10/2023.
//

import SwiftUI

struct LikedScreen: View {
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("Favourites")
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
                            Text("No favourites")
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
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
    }
    
    @ViewBuilder
    func CardView(product: Product) -> some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: product.images.first ?? ""), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }, placeholder: {
                ProgressView()
            })
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.custom(customFont, size: 18).bold())
                    .lineLimit(1)
                Text("£\(product.price)")
                    .font(.custom(customFont, size: 17).bold())
                    .foregroundColor(.orange)
                Text("Category: \(product.category.capitalized)")
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
                sharedData.likedProducts.remove(at: index)
            }
        }
    }
}

struct LikedScreen_Previews: PreviewProvider {
    static var previews: some View {
        LikedScreen()
            .environmentObject(SharedDataViewModel())
    }
}
