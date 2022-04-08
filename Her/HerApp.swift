//
//  HerApp.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import SwiftUI

@main
struct HerApp: App {
    @StateObject var herHelper = HerHelper()
    @State var isUIEnabled = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(isUIEnabled: $isUIEnabled)
                .environmentObject(herHelper)
                .alert(isPresented: $herHelper.isShowingAlert) {
                    herHelper.alert ?? Alert(title: Text(""))
                }
                .onAppear {
                    herHelper.isUIEnabled = $isUIEnabled
                    herHelper.callTask {
                        self.isUIEnabled = false
                        try await herHelper.startSession(with: herHelper.key)
                        self.isUIEnabled = true
                    }
                }
        }
    }
}
