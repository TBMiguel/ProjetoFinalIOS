//
//  AuthenticationManager.swift
//  ProjetoFinaliOS
//
//  Created by user241341 on 10/16/23.
//

import Foundation
import FirebaseAuth

struct AuthDataModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let compartilhado = AuthenticationManager()
    
    private init () {}
    
    func getUsuarioAutenticado() throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataModel(user: user)
    }
    
    func logarUsuario(email: String, password: String) async throws -> AuthDataModel {
        let AuthData = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataModel(user: AuthData.user)

    }
    
    func createUser(email: String, password: String) async throws {
        let AuthData = try await Auth.auth().createUser(withEmail: email, password: password)
        let authObjectUser = AuthDataModel(user: AuthData.user)
        
        try await UserManager.compartilhado.criarNovoUsuario(auth: authObjectUser)
    }
    
    func logoutUser() throws {
       try Auth.auth().signOut()
    }
}
