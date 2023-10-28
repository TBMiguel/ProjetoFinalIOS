//
//  ProfileView.swift
//  ProjetoFinaliOS
//
//  Created by user241341 on 10/21/23.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ProfileModel: ObservableObject {
    @Published private(set) var user: DatabaseUser? = nil
    
    func carregaUsuarioAtual() async throws {
        let authData = try AuthenticationManager.compartilhado.getUsuarioAutenticado()
        self.user = try await UserManager.compartilhado.pegarUsuario(userId: authData.uid)
    }
}

struct ProfileView: View {
    
    @StateObject private var model = ProfileModel()
    @State private var showAlert = false
    @State private var showAlertUpdate = false
    @State private var nome: String = ""
    @State private var sobrenome: String = ""
    @State private var email: String = ""
    @State private var userId: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
           Profile
    }
    
    var Profile: some View {
        NavigationView {
            VStack {
               // ProfileImage(name: "gear")
                 //   .padding()
                
                Form {
                    Section(header: Text("Informações pessoais")) {
                        if let user = model.user {
                            Text("ID: \(user.userId.description)")
                                .disabled(true)
                            
                            if let isAnonymous = user.isGuestUser {
                                Text("Usuário convidado: \(isAnonymous.description.capitalized)")
                                    .disabled(true)
                            }
                        }
                        
                        TextField("Nome", text: $nome)
                        TextField("Sobrenome", text: $sobrenome)
                        TextField("Email", text: $email)
                    }
                }
                LogOutButton
            }
        }
        .navigationTitle("Perfil")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                Button {
                    email = ""
                    sobrenome = ""
                    nome = ""
                } label: {
                    Label("Limpar", systemImage: "pencil.slash")
                    Text("Limpar")
                }
                
                Button {
                    Task {
                        do {
                            try await UserManager.compartilhado.atualizaUsuario(nome: nome, sobrenome: sobrenome, email: email, userId: model.user!.userId)
                        } catch {
                            print("Error:  \(error)")
                            showAlertUpdate = true
                        }
                    }
                } label: {
                    Label("Salvar", systemImage: "square.and.arrow.down")
                    Text("Salvar")
                }
                .alert(isPresented: $showAlertUpdate) {
                    Alert(
                        title: Text("Erro ao atualizar informações!"),
                        message: Text("verifique os campos informados.")
                    )
                }
            }
            
        }
        .task {
            try? await model.carregaUsuarioAtual()
            if (model.user != nil) {
                if (model.user!.email != nil) {
                    email = model.user!.email!
                }
                if (model.user!.nome != nil) {
                    nome = model.user!.nome!
                }
                if (model.user!.sobrenome != nil) {
                    sobrenome = model.user!.sobrenome!
                }
                
            }
        }
        .refreshable {
            try? await model.carregaUsuarioAtual()
            if (model.user != nil) {
                if (model.user!.email != nil) {
                    email = model.user!.email!
                }
                if (model.user!.nome != nil) {
                    nome = model.user!.nome!
                }
                if (model.user!.sobrenome != nil) {
                    sobrenome = model.user!.sobrenome!
                }
                
            }
        }
        .background(Color(.white))
        
    }
    
    @ViewBuilder
    var LogOutButton: some View {
        Button {
            Task {
                do {
                    try logout()
                    //dismiss()
                } catch {
                    showAlert = true
                }
            }
        } label: {
            Text("Sair")
                .bold()
                .frame(width: 210, height: 50)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.linearGradient(colors: [.blue, .indigo,], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .foregroundColor(Color.white)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erro ao sair!"),
                message: Text("Erro ao sair da aplicação!")
            )
        }
    }
    
    func logout() throws {
        try AuthenticationManager.compartilhado.logoutUser()
    }
}

// ProfileImage: View {
  //  var name: String
    
    //var body: some View {
      //  Image(name)
        //    .resizable()
          //  .frame(width: 100, height: 100)
            //.clipShape(Circle())
    //}
//}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
