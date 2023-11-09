//
//  CartScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 30/10/2023.
//

import SwiftUI

struct CartScreen: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @State var showDeleteOption: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text(NSLocalizedString("Cart", comment: "Cart screen title"))
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
                                Text(NSLocalizedString("No items added", comment: "No items added"))
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
                                        CardView(animation: animation, product: $product)
                                            .environmentObject(sharedData)
                                            .onTapGesture {
                                                withAnimation(.easeInOut) {
                                                    sharedData.screen = .Cart
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
                
                if !sharedData.cartProducts.isEmpty {
                    Group {
                        HStack {
                            Text(NSLocalizedString("Total", comment: "Checkout total"))
                                .font(.custom(customFont, size: 14).bold())
                            Spacer()
                            Text(sharedData.getTotalPrice())
                                .font(.custom(customFont, size: 18).bold())
                                .foregroundColor(.orange)
                        }
                        
                        Button {
                            //
                        } label: {
                            Text(NSLocalizedString("Checkout", comment: "Checkout button label"))
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
            .onDisappear {
                showDeleteOption = false
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
                sharedData.deleteCartProduct(id: sharedData.cartProducts[index].id)
                sharedData.cartProducts.remove(at: index)
            }
        }
    }
}

struct CardView: View {
    
    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    
    @Binding var product: Product
    
    var body: some View {
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
                    .matchedGeometryEffect(id: "\(product.id)CART", in: animation)
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
                
                // Quantity buttons
                
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Quantity", comment: "Quantity"))
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
