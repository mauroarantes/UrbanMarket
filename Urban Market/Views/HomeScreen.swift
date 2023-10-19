//
//  ContentView.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI
import CoreData

struct HomeScreen: View {

    @StateObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                VStack {
                    Text(product.title)
                        .font(.headline)
                    Text(product.description)
                        .foregroundColor(.gray)
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
