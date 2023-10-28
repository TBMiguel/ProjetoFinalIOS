//
//  ProjetoFinaliOSApp.swift
//  ProjetoFinaliOS
//
//  Created by user241341 on 9/21/23.
//

import SwiftUI
import Firebase

@main
struct ProjetoFinaliOSApp: App {
    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
         
                
            ContentView()
        }
    }
}
