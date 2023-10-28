//
//  ContentView.swift
//  ProjetoFinaliOS
//
//  Created by user241341 - Miguel Junior on 9/21/23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    // variaveis do projeto
    @State private var email = ""
    @State private var senha = ""
    @State private var isUserLoggedIn = false
    @State private var showAlert = false
    @StateObject var dataManager = DataManager()
    
    var body: some View {
        if isUserLoggedIn {
            ListaConsultasView()
                .environmentObject(dataManager)
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.white
            
            // Aqui fica o backgroud azul onde degress é o grau de angulação
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1200, height: 600)
                .rotationEffect(.degrees(39))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                    Text("Bem-vindo ao Easy Consult")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .offset(x: -50)
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding(.top, 80)
                    
                    Rectangle()
                        .frame(width: 350, height: 0.5)
                        .foregroundColor(.black)
                    
                    SecureField("Senha", text: $senha)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .placeholder(when: senha.isEmpty) {
                            Text("Senha")
                                .foregroundColor(.black)
                                .bold()
                        }
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.black)
                        
                    LoginButtonView
                    RegisterAreaView
            }
            .frame(width: 350)
            .onAppear {
                 Auth.auth().addStateDidChangeListener { auth, user in
                     if user != nil {
                         isUserLoggedIn.toggle()
                     }
                 }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    var LoginButtonView: some View {
        Button {
            login()
        } label: {
            Text("Login")
                .bold()
                .frame(width: 210, height: 50)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.linearGradient(colors: [.blue, .indigo,], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .foregroundColor(.white)
        }
        .padding(.top, 80)
        .offset(y: 50)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erro ao efetuar login!"),
                message: Text("Email ou senha inválidos.")
            )
        }
    }
    
    func login() {
        guard !email.isEmpty, !senha.isEmpty else {
            showAlert = true
            return
        }
        
        Task {
            do {
                let userData = try await AuthenticationManager.compartilhado.logarUsuario(email: email, password: senha)
                print(userData)
            } catch {
                print("Error:  \(error)")
                showAlert = true
                return
            }
        }
    }
    
    @ViewBuilder
    var RegisterAreaView: some View {
        Button {
            registrar()
        } label: {
            Text("Ainda não tem um login? Clique para registrar!")
                .bold()
                .foregroundColor(.black)
        }
        .padding(.top)
        .offset(y: 60)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Erro ao registrar-se!"),
                message: Text("Email ou senha inválidos.")
            )
        }
    }
    
    func registrar() {
        guard !email.isEmpty, !senha.isEmpty else {
            showAlert = true
            return
        }
        
        Task {
            do {
                try await AuthenticationManager.compartilhado.createUser(email: email, password: senha)
            } catch {
                print("Error:  \(error)")
                showAlert = true
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
        when podeMostrarLabel: Bool,
        aligment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: aligment) {
                placeholder().opacity(podeMostrarLabel ? 1 : 0)
                self
            }
        }
}
