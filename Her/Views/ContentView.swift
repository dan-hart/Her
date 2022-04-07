//
//  ContentView.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import SwiftUI

struct ContentView: View {
    @State var input: String = ""
    @State var output: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Input")
                .foregroundColor(.accentColor)
                .font(.system(.headline, design: .monospaced))
            TextEditor(text: $input)
                .font(.system(.body, design: .monospaced))
                .disableAutocorrection(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
            
            
            Spacer()
            TextEditor(text: $output)
        }
        .sheet(isPresented: .constant(false)) {
            NavigationView {
                SupportThisAppView(showCancelButton: true)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
