//
//  LoginScreenViewModel.swift
//  Urban Market
//
//  Created by Mauro Arantes on 24/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreData

protocol AuthenticationFormProtocol {
    var formValid: Bool { get }
}

@MainActor
class LoginScreenViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User
    @Published var showPassword: Bool = false
    @Published var reEnterPassword: String = ""
    @Published var showReEnterPassword: Bool = false
    @Published var registerUser: Bool = false
    
    init(user: User) {
        self.currentUser = user
        self.userSession = Auth.auth().currentUser
        CoreDataManager.shared.getProfiles()
        Task {
            await fetchUser()
        }
    }
    
    func addProfile() {
        let newProfile = ProfileEntity(context: CoreDataManager.shared.context)
        newProfile.id = currentUser.id
        CoreDataManager.shared.save()
    }
    
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func register(fullName: String, email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email, password: password)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        guard let user = try? snapshot.data(as: User.self) else { return }
        self.currentUser = user
        self.registerUser = false
        CoreDataManager.shared.addProfile(id: currentUser.id)
    }
    
    func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = User(id: "", fullName: "", email: "", password: "")
        } catch {
            print("DEBUG: Failed to sign out user with error: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Auth.auth().currentUser?.delete()
        Firestore.firestore().collection("users").document(uid).delete()
        self.userSession = nil
        CoreDataManager.shared.deleteProfile(id: currentUser.id)
        self.currentUser = User(id: "", fullName: "", email: "", password: "")
    }
}
