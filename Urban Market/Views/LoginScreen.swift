//
//  LoginScreen.swift
//  Urban Market
//
//  Created by Mauro Arantes on 24/10/2023.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject var viewModel: LoginScreenViewModel
    
    var body: some View {
        VStack {
            Text("Welcome to the\nUrban Market")
                .font(.custom(customFont, size: 44).bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: getRect().height/5)
                .padding()
                .background(
                    ZStack {
                        LinearGradient(colors: [.gray, .gray.opacity(0.8), .orange], startPoint: .top, endPoint: .bottom)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(.trailing)
                            .offset(y: -25)
                            .ignoresSafeArea()
                        
                        Circle()
                            .strokeBorder(.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 30, height: 30)
                            .blur(radius: 2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(.bottom, getRect().height/100)
                            .padding()
                        
                        Circle()
                            .strokeBorder(.white.opacity(0.3), lineWidth: 3)
                            .frame(width: 23, height: 23)
                            .blur(radius: 2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.leading, 30)
                        
                    }
                )
            
            ScrollView(.vertical, showsIndicators: false) {
                // Login form
                VStack(spacing: 15) {
                    Text(viewModel.registerUser ? "Register" : "Login")
                        .font(.custom(customFont, size: 22).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Custom text field
                    if viewModel.registerUser {
                        CustomTextField(icon: "person.fill", title: "Full Name", hint: "John Doe", value: $viewModel.currentUser.fullName, showPassword: .constant(false))
                            .padding(.top, 30)
                    }
                    CustomTextField(icon: "envelope", title: "Email", hint: "youremail@service.com", value: $viewModel.currentUser.email, showPassword: .constant(false), capitalization: UITextAutocapitalizationType.none)
                        .padding(.top, 30)
                    CustomTextField(icon: "lock", title: "Password", hint: "12345678", value: $viewModel.currentUser.password, showPassword: $viewModel.showPassword)
                        .padding(.top, 10)
                    
                    if viewModel.registerUser {
                        CustomTextField(icon: "lock", title: "Reenter Password", hint: "12345678", value: $viewModel.reEnterPassword, showPassword: $viewModel.showReEnterPassword)
                            .padding(.top, 30)
                    }
                    
                    // Forgot password button
                    
                    Button {
                        viewModel.forgotPassword()
                    } label: {
                        Text("Forgot password?")
                            .font(.custom(customFont, size: 14).bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Login button
                    
                    Button {
                        if viewModel.registerUser {
                            Task {
                                try await viewModel.register(fullName: viewModel.currentUser.fullName, email: viewModel.currentUser.email, password: viewModel.currentUser.password)
                            }
                        } else {
                            Task {
                                try await viewModel.login(email: viewModel.currentUser.email, password: viewModel.currentUser.password)
                            }
                        }
                    } label: {
                        Text(viewModel.registerUser ? "Register" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .font(.custom(customFont, size: 17).bold())
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.07), radius: 5, x: 5, y: 5)
                    }
                    .disabled(!formValid)
                    .opacity(formValid ? 1 : 0.5)
                    .padding(.top, 25)
                    .padding(.horizontal)
                    
                    // Register User button
                    
                    Button {
                        withAnimation {
                            viewModel.registerUser.toggle()
                        }
                    } label: {
                        Text(viewModel.registerUser ? "Back to login" : "Create account")
                            .font(.custom(customFont, size: 14).bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 8)
                    
                }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25)).ignoresSafeArea())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange)
    }
    
    @ViewBuilder
    func CustomTextField(icon: String, title: String, hint: String, value: Binding<String>, showPassword: Binding<Bool>, capitalization: UITextAutocapitalizationType? = .words) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text(title)
                    .font(.custom(customFont, size: 14))
            } icon: {
                Image(systemName: icon)
            }
            .foregroundColor(.black.opacity(0.8))
            
            if title.contains("Password"), !showPassword.wrappedValue {
                SecureField(hint, text: value)
                    .padding(.top, 2)
                    .frame(height: 10)
            } else {
                TextField(hint, text: value)
                    .padding(.top, 2)
                    .frame(height: 10)
                    .autocapitalization(capitalization ?? .words)
            }
            
            Divider()
                .background(.black.opacity(0.4))
        }
        .overlay(
            Group {
                if title.contains("Password") {
                    Button {
                        showPassword.wrappedValue.toggle()
                    } label: {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom(customFont, size: 13).bold())
                            .foregroundColor(.orange)
                            .offset(y: 8)
                    }
                }
            }
            , alignment: .trailing
        )
    }
}

extension LoginScreen: AuthenticationFormProtocol {
    var formValid: Bool {
        return !viewModel.currentUser.email.isEmpty
        && viewModel.currentUser.email.contains("@")
        && !viewModel.currentUser.password.isEmpty
        && viewModel.currentUser.password.count > 5
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
