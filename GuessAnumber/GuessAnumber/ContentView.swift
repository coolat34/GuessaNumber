//
//  ContentView.swift
//  GuessAnumber
//
//  Created by Chris Milne on 07/07/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var guess = ""
    @State private var answer = ""
    @State private var tryAnswer = ""
    @State private var attempts = 0
    @State private var imageViews = [[AnyView]]()  // Array of arrays to store attempts
    @State private var previousGuesses = [String]()  // Store each guess
    @State private var numberCalculated = false
    let maxAttempts = 5
    let guessLength = 5

    var redtext: AttributedString {
        var redres = AttributedString("**RED**")
        redres.foregroundColor = .red
        redres.font = .caption
        return redres
    }

    var greentext: AttributedString {
        var greenres = AttributedString("**GREEN**")
        greenres.foregroundColor = .green
        return greenres
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("     Welcome to Guess the Number.")
                    .font(.title2)
                Text("  You have 5 attempts to guess the 5 digit number.\n   A \(greentext) dot means the number is right & in the right place.\n  A \(redtext) dot means the number is right but in the wrong place.\n  A BLACK dot means the number is wrong.\n ___________________________\n ")
                
                    .font(Font.custom("Avenir", size: 14))
                Text("Each guess must be 5 numbers only.")
                    .font(Font.custom("Avenir", size: 18))
                    .padding(.bottom)

                Text("    Enter your guess")
                    .font(Font.custom("Avenir", size: 24))
                    .padding(.bottom, 10)

 
                    ForEach(0..<maxAttempts, id: \.self) { idx in     /// 6 Attempts
                        if idx == attempts {                          /// Increase by 1 for each attempt
                            TextField("Guess", text: $guess)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100, height: 10)
                                .padding()
                                .keyboardType(.numberPad)
                                .onSubmit {
                                    if isValidGuess() {    /// Check length and valid number input
                                       processGuess()     /// Build the dots
                                    }  ///IF
                                } ///On Submit

                          Button("Check") {

                              if isValidGuess() {
                                  processGuess()
                                } /// IF is
                          } /// BUTTON
                         .padding(.top, 10)
                        }   /// if idx ==
                        else if idx < attempts {
                            HStack {
                                ForEach(imageViews[idx].indices, id: \.self) { imgIdx in
                                    imageViews[idx][imgIdx]
                                } ///ForEach(imageViews
                                Text("\(previousGuesses[idx])")  // Display the corresponding guess
                                                                .padding(.leading, 10)
                            } /// HStack
                      
                                
                            } /// ELSE IF
                    
                        } /// ForEach(0
                if guess == answer {
                    Text("Well Done. You guessed correctly")
                } else if attempts == maxAttempts {
                        Text(guess == answer ? "Well Done" : "Bad luck. Answer \(answer)")
                }
                HStack {
                    
                    Button("Go Back.") {
                        dismiss()
                    } /// Button
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                    .frame(alignment: .center)
                    .padding(.top)
                    
                    Button("Another Guess.") {
                        resetGame()
                    } /// Button
                    .background(Color.black)
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                    .frame(alignment: .center)
                    .padding(.top)
                }
                    
                    
            } /// VStack

        } ///ScrollView

        .onAppear {
            generateAnswer()   /// Create a random number
      
        } /// .onAppear
    } ///Body

    func isValidGuess() -> Bool {
        return guess.count == guessLength && guess.allSatisfy(\.isNumber)
    }

    func processGuess() {
        if attempts >= maxAttempts {    /// Return if more than 6 attempts
            return
        }

        var newImageViews = [AnyView]()
        let answerArray = Array(answer)
        let charArray = Array(guess)

        for i in 0..<charArray.count {
            let image: AnyView
            if charArray[i] == answerArray[i] {
                image = AnyView(Image("greenDot"))
            } else if answerArray.contains(charArray[i]) {
                image = AnyView(Image("redDot"))
            } else {
                image = AnyView(Image("blackDot"))
            }
            newImageViews.append(image)
        }

        imageViews.append(newImageViews)
        previousGuesses.append(guess)  // Store the guess
        attempts += 1
        guess = ""
    }

    func generateAnswer() {
        answer = ""
        tryAnswer = ""
        while answer.count < guessLength {
            tryAnswer = String(Int.random(in: 1...9))
            while !answer.contains(tryAnswer) {
                answer += tryAnswer
            }
        }
    }
    func resetGame() {
            guess = ""
            answer = ""
            tryAnswer = ""
            attempts = 0
            imageViews = [[AnyView]]()
            previousGuesses = [String]()
            numberCalculated = false
            generateAnswer()
        }
}

