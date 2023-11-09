//
//  ContentView.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI
import CoreData

struct HomeScreen: View {

    var animation: Namespace.ID
    
    @EnvironmentObject var sharedData: SharedDataViewModel
    @StateObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                print("Pulled to refresh")
                viewModel.filteredProducts = []
                viewModel.getProducts()
            }
            VStack(spacing: 15) {
                // Search bar
                ZStack {
                    if viewModel.searchActive {
                        SearchBar()
                    } else {
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                    }
                }
                .frame(width: getRect().width / 1.6)
                .padding(.horizontal, 25)
                .padding(.top, -8)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        viewModel.searchActive = true
                    }
                }
                
                Text(NSLocalizedString("Order online\ncollect in store", comment: "Home screen title"))
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
                
                //Products Page
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 25) {
                        ForEach(viewModel.filteredProducts.prefix(4)) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 30)
                
                //See more button
                
                Button {
                    viewModel.showMoreProducts.toggle()
                } label: {
                    Label {
                        Image(systemName: "arrow.right")
                    } icon: {
                        Text(NSLocalizedString("See more", comment: "See more button label"))
                    }
                    .font(.custom(customFont, size: 15).bold())
                    .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                .padding(.top, 10)
            }
            .padding(.vertical)
        }
        .coordinateSpace(name: "pullToRefresh")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onChange(of: viewModel.productType) { _ in
            viewModel.filterProductsByType()
        }
        // Search View
        .overlay(
            ZStack {
                if viewModel.searchActive {
                    SearchScreen(animation: animation)
                        .environmentObject(viewModel)
                } else if viewModel.showMoreProducts {
                    MoreProductsScreen(animation: animation)
                        .environmentObject(viewModel)
                        .environmentObject(sharedData)
                }
            }
        )
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)
            TextField(NSLocalizedString("Search", comment: "Search bar placeholder"), text: .constant(""))
                .disabled(true)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(
            Capsule()
                .strokeBorder(.gray, lineWidth: 0.8)
        )
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
                    .matchedGeometryEffect(id: "\(product.id)HOME", in: animation)
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
                sharedData.screen = .Home
                sharedData.detailProduct = product
                sharedData.showDetailProduct = true
            }
        }
    }
    
    @ViewBuilder
    func ProductTypeView(type: String) -> some View {
        Button {
            withAnimation {
                viewModel.productType = ProductType(rawValue: type) ?? .smartphones
            }
        } label: {
            Text(NSLocalizedString(type, comment: "Category button label").capitalized)
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

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}
