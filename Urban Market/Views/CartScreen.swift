//
//  CartScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 30/10/2023.
//

import SwiftUI

struct CartScreen: View {
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Cart")
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
                            .opacity(sharedData.cartProducts.isEmpty ? 0 : 1)

                        }
                        
                        if sharedData.cartProducts.isEmpty {
                            Group {
                                Text("No items added")
                                    .font(.custom(customFont, size: 25).bold())
                                    .foregroundColor(.orange)
                            }
                            .padding()
                        } else {
                            VStack(spacing: 15) {
                                ForEach($sharedData.cartProducts) { $product in
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
                                        CardView(product: $product)
                                    }
                                }
                            }
                            .padding(.top, 25)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                
                if !sharedData.cartProducts.isEmpty {
                    Group {
                        HStack {
                            Text("Total")
                                .font(.custom(customFont, size: 14).bold())
                            Spacer()
                            Text(sharedData.getTotalPrice())
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.orange)
                        }
                        
                        Button {
                            //
                        } label: {
                            Text("Checkout")
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 18)
                                .frame(maxWidth: .infinity)
                                .background(.orange)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal, 25)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        }
    }
    
    func deleteProduct(product: Product) {
        if let index = sharedData.cartProducts.firstIndex(where: { currentProduct in
            return product.id == currentProduct.id
        }) {
            let _ = withAnimation {
                sharedData.cartProducts.remove(at: index)
            }
        }
    }
}

struct CardView: View {
    
    @Binding var product: Product
    
    var body: some View {
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
                
                // Quantity buttons
                
                HStack(spacing: 10) {
                    Text("Quantity")
                        .font(.custom(customFont, size: 14))
                        .foregroundColor(.gray)
                    Button {
                        product.quantity = (product.quantity > 0 ? product.quantity - 1 : 0)
                    } label: {
                        Image(systemName: "minus")
                            .font(.caption)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(4)
                    }
                    
                    Text("\(product.quantity)")
                        .font(.custom(customFont, size: 14))
                        .foregroundColor(.black)
                    
                    Button {
                        product.quantity += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(4)
                    }

                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1).cornerRadius(10))
    }
}

struct CartScreen_Previews: PreviewProvider {
    static var previews: some View {
        CartScreen()
            .environmentObject(SharedDataViewModel())
    }
}