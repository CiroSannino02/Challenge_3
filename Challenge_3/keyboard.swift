//
//  keyboard.swift
//  Challenge_3
//
//  Created by Ciro Sannino on 12/10/24.
//

import SwiftUI

struct CustomKeyboard: View {
    @Binding var inputText: String
    @Binding var cursorIndex: Int
    @Binding var currentCategory: Int
    @Binding var currentSymbolExplanation: String
    let isKeyboardVisible: Bool
    let symbolMeanings: [String: String]

    let categories = ["∃", "∈", "α"]
    let symbolsByCategory: [[String]] = [
        ["∀", "∃", ":", "≡", "(", ")", "x", "∄", "∞", "≠", "[", "]", "y", "+", "-", "≈", "{", "}", "z","*", "÷", "≜"],
        ["∈", "ℕ", "ℝ", "ℤ", "ℂ", "ℚ", "∉", "∪", "⊂", "⊃", "⇒", "⇐", "⋂", "⊆", "⊇", "⇔", "≤", "<", ">", "≥"],
        ["α", "β", "γ", "δ", "ε", "ζ", "λ", "μ", "ξ", "ρ", "τ", "π","0","1","2","3","4","5","6","7","8","9"]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack {
                    // Barra superiore
                    HStack(spacing: 10) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Button(action: {
                                currentCategory = index
                            }) {
                                Text(categories[index])
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(width: 60, height: 60)
                                    .background(currentCategory == index ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(currentCategory == index ? .white : .black)
                                    .cornerRadius(12)
                            }
                            .accessibilityLabel("Switch to \(categories[index]) category")
                            .accessibilityHint("Double-tap to view symbols in the \(categories[index]) category.")
                        }
                        
                        Spacer()
                        
                        // Pulsanti di navigazione e cancellazione
                        Button(action: {
                            if cursorIndex > 0 { cursorIndex -= 1 }
                        }) {
                            Image(systemName: "arrow.left").font(.title2).bold()
                        }
                        .accessibilityLabel("Move cursor left")
                        .accessibilityHint("Double-tap to move the cursor one position to the left.")
                        
                        Button(action: {
                            if cursorIndex < inputText.count { cursorIndex += 1 }
                        }) {
                            Image(systemName: "arrow.right").font(.title2).bold()
                        }
                        .accessibilityLabel("Move cursor right")
                        .accessibilityHint("Double-tap to move the cursor one position to the right.")
                        
                        Button(action: {
                            if cursorIndex > 0 {
                                let index = inputText.index(inputText.startIndex, offsetBy: cursorIndex - 1)
                                inputText.remove(at: index)
                                cursorIndex -= 1
                            }
                        }) {
                            Image(systemName: "delete.left").font(.title2).bold()
                        }
                        .accessibilityLabel("Delete character")
                        .accessibilityHint("Double-tap to delete the character before the cursor.")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .accessibilityLabel("Keyboard controls")
                    .accessibilityHint("Use these controls to switch categories, move the cursor, or delete characters.")
                    
                    // Griglia di simboli
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(symbolsByCategory[currentCategory], id: \.self) { symbol in
                            Button(action: { appendSymbol(symbol) }) {
                                Text(symbol)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 50, height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                            }
                            .accessibilityLabel("Symbol \(symbol)")
                            .accessibilityHint(symbolMeanings[symbol] ?? "No description available.")
                        }
                    }
                    .padding()
                }
                .frame(width: geometry.size.width, height: 350)
                .background(Color(.sRGB, red: 216/255, green: 216/255, blue: 216/255))
                .cornerRadius(30)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5))
                .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func appendSymbol(_ symbol: String) {
        let beforeCursor = String(inputText.prefix(cursorIndex))
        let afterCursor = String(inputText.suffix(inputText.count - cursorIndex))
        inputText = beforeCursor + symbol + afterCursor
        cursorIndex += symbol.count
    }
}

// Anteprima
struct CustomKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
