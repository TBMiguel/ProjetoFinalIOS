//
//  AdicionarConsultaView.swift
//  ProjetoFinaliOS
//
//  Created by user241341 on 10/1/23.
//

import SwiftUI

struct AdicionarConsultaView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var dataNovaConsulta = Date()
    @State private var showAlerta = false
    @State private var showError = false
    
    var body: some View {
        VStack {
            DatePicker(
                "Data Consulta",
                selection: $dataNovaConsulta,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            
            Button(action: {
                print(dataNovaConsulta)
                Task {
                    do {
                        try await dataManager.adicionarConsulta(
                            dataNovaConsulta:  dataNovaConsulta.ISO8601Format(),
                            userId: AuthenticationManager.compartilhado.getUsuarioAutenticado().uid
                        )
                    } catch {
                        print("Erro: \(error)")
                    }
                }
                showAlerta = true
            }, label: {
                Text("Agendar")
            })
            .alert(isPresented: $showAlerta) {
                Alert(
                    title: Text("Sucesso!"),
                    message: Text("Consulta agendada com sucesso")
                )
            }
        }
        .padding()
    }
}

struct AdicionarConsultaView_Previews: PreviewProvider {
    static var previews: some View {
        AdicionarConsultaView()
    }
}
