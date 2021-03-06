//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chris Peloso on 12/31/21.
//

import SwiftUI

struct FlagImage: View{
    var image: String
    
    var body: some View{
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var highScore = 0
    
    @State private var buttonSelected = -1
    
    var body: some View {
        ZStack{
           RadialGradient(stops: [
            .init(color: Color(red:0.1, green:0.2, blue:0.45), location: 0.3),
            .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)
           ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    
                    //  shows the "Tap the flag of: Country" portion
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    //  displays 3 different flags.
                    ForEach(0..<3){number in
                        
                        Button{
                            withAnimation{
                                buttonSelected = number
                                
                            }
                            flagTapped(number)
                        }label: {
                            FlagImage(image: countries[number])
                        }
                        .rotation3DEffect(.degrees(buttonSelected == number ? 360 : 0), axis: (x: 0, y: 1, z:0))
                        .opacity(buttonSelected != number && buttonSelected != -1 ? 0.25 : 1)
                        .blur(radius: buttonSelected != number && buttonSelected != -1 ? 3 : 0)
                        
                        
                        
                        
                        
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text("High Score: \(highScore)")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        } message:{
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int){
        
        if number == correctAnswer{
            score += 1
            if(score == 8){
                scoreTitle = "Congratulations!"
                scoreMessage = "You got 8 correct!"
                highScore = score
                score = 0
            }
            else{
                scoreTitle = "Correct"
                if score > highScore{
                    highScore = score
                }
                scoreMessage = "Your score is: \(score)"
            }
        }
        else{
            scoreTitle = "Wrong"
            score = 0
            let country = countries[number]
            scoreMessage = "That's the flag of \(country)"
            
        }
        
        showingScore = true
    }
    
    func askQuestion(){
        
        //  reset some animation variables
        buttonSelected = -1
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
