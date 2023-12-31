//
//  ProfileScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 25/10/2023.
//

import SwiftUI

struct ProfileScreen: View {
    
    @EnvironmentObject var viewModel: LoginScreenViewModel
    @State var showSignOutAlert: Bool = false
    @State var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text(NSLocalizedString("My Profile", comment: "Profile screen title"))
                        .font(.custom(customFont, size: 28).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .foregroundColor(.orange)
                            .offset(y: -30)
                            .padding(.bottom, -30)
                        
                        Text(viewModel.currentUser.fullName)
                            .font(.custom(customFont, size: 16))
                        
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            Text(viewModel.currentUser.email)
                                .font(.custom(customFont, size: 15))
                        }
                    }
                    .padding([.horizontal, .bottom])
                    .background(Color.gray.opacity(0.1).cornerRadius(15))
                    .padding()
                    .padding(.top, 40)
                    
                    // Custom Navigation Links
                    
                    CustomNavigationLink(title: NSLocalizedString("Edit Profile", comment: "Edit profile button label")) {
                        Text("")
                            .navigationTitle(NSLocalizedString("Edit Profile", comment: "Edit profile button label"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.ignoresSafeArea())
                    }
                    
                    CustomNavigationLink(title: NSLocalizedString("Order History", comment: "Order History button label")) {
                        Text("")
                            .navigationTitle(NSLocalizedString("Order History", comment: "Order History button label"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.ignoresSafeArea())
                    }
                    
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Text(NSLocalizedString("Sign Out", comment: "Sign Out button label"))
                            .font(.custom(customFont, size: 17).bold())
                    }
                    .alert(NSLocalizedString("Please confirm sign out", comment: "Profile sign out/ delete confirmation"), isPresented: $showSignOutAlert, actions: {
                        Button("OK", role: .cancel) {
                            viewModel.signOut()
                        }
                        Button(NSLocalizedString("Cancel", comment: "Cancel button label"), role: .none) {}
                    })
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.1).cornerRadius(12))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Text(NSLocalizedString("Delete Account", comment: "Delete Account button label"))
                            .font(.custom(customFont, size: 17).bold())
                            .foregroundColor(.red)
                    }
                    .alert(NSLocalizedString("Please confirm profile deletion", comment: "Profile sign out/ delete confirmation"), isPresented: $showDeleteAlert, actions: {
                        Button("OK", role: .cancel) {
                            viewModel.delete()
                        }
                        Button(NSLocalizedString("Cancel", comment: "Cancel button label"), role: .none) {}
                    })
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.1).cornerRadius(12))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 20)
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String, @ViewBuilder content: @escaping () -> Detail) -> some View {
        NavigationLink {
            content()
        } label: {
            HStack {
                Text(title)
                    .font(.custom(customFont, size: 17).bold())
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(12))
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
