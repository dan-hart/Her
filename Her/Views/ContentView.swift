//
//  ContentView.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import SwiftUI
import SFSafeSymbols

struct ContentView: View {
    @State var input: String = ""
    @State var output: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HerTextView(label: "Input", color: .accentColor, text: $input)
            Spacer()
            HerTextView(label: "Output", color: Constants.Colors.secondary, text: $output)
            // --
            CommandView()
                .padding()
            // --
        }
        .sheet(isPresented: .constant(false)) {
            NavigationView {
                SupportThisAppView(showCancelButton: true)
            }
        }
        .padding()
    }
}

struct CommandView: View {
    var body: some View {
        HStack {
            Button {
                // Process
            } label: {
                HStack {
                    Image(systemSymbol: ._42CircleFill)
                    Text("Process Input")
                        .font(.system(.body, design: .monospaced))
                }
            }
            Spacer()
            Button {
                // Settings
            } label: {
                Image(systemSymbol: .gearshapeFill)
            }
            
        }
    }
}

struct HerTextView: View {
    var label: String
    var color: Color
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(color)
                .font(.system(.headline, design: .monospaced))
            Spacer()
            Button {
                text = ""
            } label: {
                Image(systemSymbol: .xmarkCircleFill)
                    .foregroundColor(color)
            }
        }
        TextEditor(text: $text)
            .font(.system(.body, design: .monospaced))
            .disableAutocorrection(true)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
