//
//  AuthenticationView.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import Foundation
import SwiftUI
import SFSafeSymbols

struct AuthenticationView: View {
    @EnvironmentObject var herHelper: HerHelper
    
    @State var key: String = ""
    
    var body: some View {
        VStack {
            Text("API Key")
                .font(.system(.body, design: .monospaced))
            SecureField(text: $key,
                        prompt: Text("uZnVflqpqr2U1M9x984h3985a48dn74n").font(.system(.body, design: .monospaced))) {
                Text("Key")
                    .font(.system(.body, design: .monospaced))
            }
            .onSubmit {
                go()
            }

            Button {
                go()
            } label: {
                HStack {
                    Image(systemSymbol: .lock)
                    Text("Validate")
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
    }
    
    func go() {
        herHelper.callTask {
            try await herHelper.startSession(with: key)
        }
    }
}
