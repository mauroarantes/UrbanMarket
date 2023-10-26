//
//  Urban_MarketApp.swift
//  Urban Market
//
//  Created by Mauro Arantes on 19/10/2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Urban_MarketApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = LoginScreenViewModel(user: User(id: "", fullName: "", email: "", password: ""))

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.userSession != nil {
                    MainScreen()
                        .environmentObject(viewModel)
                } else {
                    OnBoardingScreen()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}
