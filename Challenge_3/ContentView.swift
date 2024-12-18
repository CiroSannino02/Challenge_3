//
//  ContentView.swift
//  Challenge_3
//
//  Created by Ciro Sannino on 12/9/24.
//
import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isKeyboardVisible: Bool = false // Stato per mostrare/nascondere la tastiera
    @State private var inputText: String = "" // Stato per aggiornare il testo con i simboli cliccati
    @State private var cursorIndex: Int = 0 // Stato per la posizione del cursore
    @State private var currentCategory: Int = 0
    @State private var currentSymbolExplanation: String = "" // Spiegazione del simbolo selezionato
    @State private var speechSynthesizer = AVSpeechSynthesizer() // Instanza di AVSpeechSynthesizer

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Titolo
                Text("Translate")
                    .foregroundStyle(.black)
                    .font(.system(.body, weight: .bold))
                    .accessibilityLabel("Translate title")

                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color(.sRGB, red: 151/255, green: 151/255, blue: 151/255), lineWidth: 0)
                        .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color(.sRGB, red: 216/255, green: 216/255, blue: 216/255)))
                        .frame(width: geometry.size.width * 0.9, height: 340)
                        .clipped()
                        .accessibilityHidden(true) // Ignora decorazioni visive

                    VStack(alignment: .leading, spacing: 20) {
                        // Sezione Math
                        Text("Math:")
                            .foregroundStyle(.black)
                            .font(.system(.body, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityLabel("Math input section")

                        // Input Math
                        ZStack(alignment: .leading) {
                            if inputText.isEmpty {
                                Text("Enter the mathematical sentence")
                                    .foregroundStyle(Color(.sRGB, red: 202/255, green: 199/255, blue: 199/255))
                                    .font(.system(.body, weight: .semibold))
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            isKeyboardVisible.toggle()
                                        }
                                    }
                                    .accessibilityLabel("Math input placeholder")
                                    .accessibilityHint("Double-tap to start typing.")
                            }

                            // Input con cursore
                            HStack(spacing: 0) {
                                Text(inputText.prefix(cursorIndex))
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .regular))
                                Text("|")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 8)
                                    .offset(y:-2)
                                    .accessibilityHidden(true) // Nascondi cursore
                                Text(inputText.suffix(inputText.count - cursorIndex))
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .regular))
                            }
                            .accessibilityLabel("Math input text")
                            .accessibilityHint("Text being entered.")
                        }

                        Spacer().frame(height: 20)

                        Divider()
                            .frame(width: geometry.size.width * 0.8, height: 10)
                            .foregroundStyle(Color(.sRGB, red: 151/255, green: 151/255, blue: 151/255))

                        // Sezione English
                        HStack {
                            Text("English:")
                                .font(.system(.body, weight: .semibold))
                                .foregroundStyle(.black)
                                .accessibilityLabel("English output section")

                            Spacer()

                            // Pulsante Microfono
                            Button(action: {
                                playTranslation()
                            }) {
                                Image(systemName: "speaker.3.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            .accessibilityLabel("Play translation")
                            .accessibilityHint("Double-tap to hear the translated text.")
                        }

                        // Testo Tradotto
                        ScrollView {
                            Text(currentSymbolExplanation)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityLabel(currentSymbolExplanation)
                                .accessibilityHint("This is the translated text.")
                        }
                        .frame(height: 120)
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: inputText) { _ in
                        updateExplanation()
                    }
                }

                // Tastiera personalizzata
                if isKeyboardVisible {
                    CustomKeyboard(
                        inputText: $inputText,
                        cursorIndex: $cursorIndex,
                        currentCategory: $currentCategory,
                        currentSymbolExplanation: $currentSymbolExplanation,
                        isKeyboardVisible: isKeyboardVisible,
                        symbolMeanings: symbolMeanings
                    )
                    .frame(width: geometry.size.width * 0.9)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 0.5))
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
        }
    }

    private func updateExplanation() {
        currentSymbolExplanation = inputText.compactMap { symbol in
            symbolMeanings[String(symbol)]
        }.joined(separator: " ")
    }

    // Funzione per riprodurre la traduzione
    private func playTranslation() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: currentSymbolExplanation)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
}
    
    
    // Anteprima
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

