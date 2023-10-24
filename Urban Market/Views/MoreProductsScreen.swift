//
//  MoreProductsScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 23/10/2023.
//

import SwiftUI

struct MoreProductsScreen: View {
    var body: some View {
        VStack {
            Text("More Products")
                .font(.custom(customFont, size: 24).bold())
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
    }
}

struct MoreProductsScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoreProductsScreen()
    }
}
