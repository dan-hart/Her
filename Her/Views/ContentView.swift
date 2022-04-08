//
//  ContentView.swift
//  Her
//
//  Created by Dan Hart on 4/7/22.
//

import SwiftUI
import SFSafeSymbols
import BottomSheet
import OpenAI

struct ContentView: View {
    @EnvironmentObject var herHelper: HerHelper
    
    @AppStorage("responseAsSheet") var showResponseAsSheet: Bool = false
    @AppStorage("input") var input: String = ""
    @State var output: String = "Waiting for human to enter a Prompt"
    
    @State var isShowingSupportThisAppView = false
    @State var isShowingBottomSheet = false
    @State var isShowingResponseAsSheet = false
    
    @Binding var isUIEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if !showResponseAsSheet {
                HerTextView(label: "Response", color: Constants.Colors.secondary, text: $output, isUIEnabled: $isUIEnabled)
                Spacer()
            }
            HerTextView(label: "Prompt", color: .accentColor, text: $input, isUIEnabled: $isUIEnabled)
            CommandView(isShowingBottomSheet: $isShowingBottomSheet, isShowingResponseSheet: $isShowingResponseAsSheet, isUIEnabled: $isUIEnabled, input: $input, output: $output)
                .padding()
        }
        .redacted(reason: isUIEnabled ? [] : .placeholder)
        .padding()
        .bottomSheet(isPresented: $isShowingBottomSheet, height: UIScreen.main.bounds.height * 0.75) {
            NavigationView {
                BottomView(isUIEnabled: $isUIEnabled)
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }
        .sheet(isPresented: $isShowingSupportThisAppView) {
            NavigationView {
                SupportThisAppView(showCancelButton: true)
            }
        }
        .sheet(isPresented: $isShowingResponseAsSheet) {
            VStack {
                HerTextView(label: "Response", color: Constants.Colors.secondary, text: $output, isUIEnabled: $isUIEnabled)
                Button {
                    isShowingResponseAsSheet = false
                } label: {
                    Text("Done")
                        .foregroundColor(Constants.Colors.secondary)
                }
                .padding()
            }
            .padding()
            
        }
    }
}

struct BottomView: View {
    @EnvironmentObject var herHelper: HerHelper
    @Binding var isUIEnabled: Bool
    
    @AppStorage("responseAsSheet") var isShowingResponseAsSheet = false
    
    var body: some View {
        Form {
            if !herHelper.isAuthenticated {
                AuthenticationView()
            } else {
                Section {
                    Picker("Presets", selection: $herHelper.selectedPreset) {
                        ForEach(Constants.Presets.all, id: \.name) { preset in
                            Text("\(preset.name)")
                                .tag(preset.name)
                        }
                    }
                    .labelsHidden()
                } header: {
                    Text("Presets")
                }
                
                Section {
                    Toggle(isOn: $isShowingResponseAsSheet) {
                        Text("Is Showing Response in Sheet")
                    }
                    .tint(.accentColor)
                }
                
                Section {
                    Picker("Modes", selection: $herHelper.selectedMode) {
                        ForEach($herHelper.selectableModes, id: \.self) { mode in
                            Text("\(mode.wrappedValue.rawValue)")
                                .tag(mode.wrappedValue.rawValue)
                        }
                    }
                    .labelsHidden()
                } header: {
                    Text("Mode")
                }
                
                Section {
                    Slider(value: $herHelper.maxTokens, in: 1...2000)
                        .padding()
                } header: {
                    Text("Maximum Response Word Count: \(Int(herHelper.maxTokens))")
                }
                
                Section {
                    Picker("Engines", selection: $herHelper.selectedEngine) {
                        ForEach(herHelper.engines, id: \.id) { engine in
                            Text("\(engine.id.description)")
                                .tag(engine.id.description)
                        }
                    }
                    .labelsHidden()
                    
                } header: {
                    Text("Engine")
                }
                // End Bottom View Else
            }
        }
        .onChange(of: herHelper.selectedPreset, perform: { presetName in
            guard let preset = Constants.Presets.get(byName: presetName) else { return }
            herHelper.selectedEngine = preset.engine
            herHelper.temperature = preset.temperature
            herHelper.maxTokens = preset.maxTokens
            herHelper.topP = preset.topP
            herHelper.frequencyPenalty = preset.frequencyPenalty
            herHelper.presencePenalty = preset.presencePenalty
        })
        .padding()
        
        .navigationTitle("Settings")
    }
}

struct CommandView: View {
    @EnvironmentObject var herHelper: HerHelper
    @Binding var isShowingBottomSheet: Bool
    @Binding var isShowingResponseSheet: Bool
    @Binding var isUIEnabled: Bool
    
    @Binding var input: String
    @Binding var output: String
    
    var body: some View {
        HStack {
            Button {
                process()
            } label: {
                HStack {
                    Image(systemSymbol: ._42CircleFill)
                    Text("Process Input")
                        .font(.system(.body, design: .monospaced))
                }
            }
            Spacer()
            Button {
                isShowingBottomSheet = true
            } label: {
                Image(systemSymbol: .gearshapeFill)
            }
            
        }
    }
    
    func process() {
        herHelper.callTask {
            self.isUIEnabled = false
            self.output = "Thinking..."
            do {
                output = try await herHelper.operate(using: Mode(rawValue: herHelper.selectedMode) ?? .complete, from: input) ?? "No Response"
                isShowingResponseSheet = true
            } catch(let error) {
                output = "I’m sorry Dave, I’m afraid I can’t do that.\n\n\(error.localizedDescription)"
            }
            self.isUIEnabled = true
        }
    }
}

struct HerTextView: View {
    var label: String
    var color: Color
    
    @Binding var text: String
    @Binding var isUIEnabled: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(color)
                .font(.system(.headline, design: .monospaced))
            Spacer()
            Button {
                ClipboardHelper.set(text: text)
            } label: {
                HStack {
                    Image(systemSymbol: SFSymbol.docOnDoc)
                        .foregroundColor(color)
                }
            }
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
        ContentView(isUIEnabled: .constant(true))
            .preferredColorScheme(.dark)
    }
}
