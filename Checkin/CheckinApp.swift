//
//  CheckinApp.swift
//  Checkin
//
//  Created by j-sys on 2022/06/17.
//

import UIKit
import SwiftUI
import GoogleSignIn

@main
struct CheckinApp: App {
    @StateObject var userAuth: GoogleSigninModel =  GoogleSigninModel()
//    @StateObject var monitorNetwork: MonitoringNetworkStateModel =  MonitoringNetworkStateModel()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            SelectLangView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(EnvironmentData())//正常に最初の画面に画面遷移するための処理
                .environmentObject(MonitoringNetworkStateModel())//ネットワークを監視する
                .environmentObject(ChatWorkModel())
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(userAuth)
            .navigationViewStyle(.stack)
            }
                      
        
    }
}


