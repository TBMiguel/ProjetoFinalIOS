//
//  SwiftUIView.swift
//  ProjetoFinaliOS
//
//  Created by user241341 on 10/1/23.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var consultas: [Consulta] = []
    
    init() {
        self.fetchConsultas(userId: Auth.auth().currentUser?.uid)
    }
    
    func fetchConsultas(userId: String?) {
        consultas.removeAll()
        Firestore.firestore().collection("consultas").whereField("user_id", isEqualTo: userId ?? "").getDocuments() { (querySnapshot, err) in
            guard err == nil else {
                print(err!.localizedDescription)
                return
            }
            
            for documento in querySnapshot!.documents {
                let data = documento.data()
                
                let consulta = Consulta(
                    id: documento.documentID,
                    userId: data["user_id"] as? String ?? "",
                    data: data["data"] as? String ?? ""
                )
                
                self.consultas.append(consulta)
            }
        }
    }
    
    func adicionarConsulta(dataNovaConsulta: String, userId: String) async throws {
        let consulta: [String:Any] = [
            "user_id": userId,
            "data": dataNovaConsulta,
            "date_created": Timestamp()
        ]
        
        try await Firestore.firestore().collection("consultas").document().setData(consulta, merge: false)
    }
}
