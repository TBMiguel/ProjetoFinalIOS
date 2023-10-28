//
//  ListaConsultasView.swift
//  ProjetoFinaliOS
//
//  Created by user241341 - Miguel Junior on 10/1/23.
//

import SwiftUI
import FirebaseAuth

struct ListaConsultasView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var mostrarPopUp = false
    @State private var userDeslogado = false
    
    var body: some View {
        if userDeslogado {
            ContentView()
        } else {
            listaConsultas
        }
    }
    
    var listaConsultas: some View {
        NavigationView {
            List(dataManager.consultas, id: \.id) { consulta in
                Text(consulta.data)
            }
            .navigationTitle("Suas Consultas")
            .navigationBarItems(
                leading: NavigationLink(
                    destination: ProfileView(),
                    label: {
                        Image(systemName: "gear")
                        Text("Perfil")
                    }
                )
                .accentColor(.indigo),
                trailing: Button(action: {
                    mostrarPopUp.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            )
            .sheet(isPresented: $mostrarPopUp, content: {
                AdicionarConsultaView()
            })
            .refreshable {
               dataManager.fetchConsultas(userId: Auth.auth().currentUser!.uid)
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user == nil {
                    userDeslogado.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ListaConsultasView_Previews: PreviewProvider {
    static var previews: some View {
        ListaConsultasView()
            .environmentObject(DataManager())
    }
}
