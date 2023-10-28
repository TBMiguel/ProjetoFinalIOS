//
//  UserManager.swift
//  ProjetoFinaliOS
//
//  Classe para gerenciar consultas de usuarios no firestore
//
//  Created by user241341 on 10/21/23.
//

import Foundation
import FirebaseFirestore

struct DatabaseUser {
    let userId: String
    let nome: String?
    let sobrenome: String?
    let isGuestUser: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
}

final class UserManager {
    // instancia unica de usuário singleton
    static let compartilhado = UserManager()
    private init () {}
    
    private let colecaoDeUsuarios = Firestore.firestore().collection("users")
    
    private func pegaDocumento(userId: String) -> DocumentReference {
        colecaoDeUsuarios.document(userId)
    }
    
    // Função para criar usuário do firestore pegando as informações do FirebaseAuthentication
    func criarNovoUsuario(auth: AuthDataModel) async throws {
        var userData: [String:Any] = [
            "user_id": auth.uid,
            "is_guest_user": false,
            "date_created": Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoURL = auth.photoUrl {
            userData["photo_url"] = photoURL
        }
        
        userData["nome"] = ""
        userData["sobrenome"] = ""
        
        try await pegaDocumento(userId: auth.uid).setData(userData, merge: false)
    }
    
    func pegarUsuario(userId: String) async throws -> DatabaseUser {
        let snapshot = try await pegaDocumento(userId: userId).getDocument()
        
        guard let dados = snapshot.data(), let userId = dados["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isGuestUser = dados["is_guest_user"] as? Bool
        let email = dados["email"] as? String
        let photoURL = dados["photo_url"] as? String
        let dateCreated = dados["date_created"] as? Date
        let nome = dados["nome"] as? String
        let sobrenome = dados["sobrenome"] as? String
        
        return DatabaseUser(userId: userId, nome: nome, sobrenome: sobrenome, isGuestUser: isGuestUser, email: email, photoURL: photoURL, dateCreated: dateCreated)
    }
    
    func atualizaUsuario(nome: String, sobrenome: String, email: String, userId: String) async throws {
        try await pegaDocumento(userId: userId).updateData([
            "nome": nome,
            "sobrenome": sobrenome,
            "email": email
        ])
    }
    
}
