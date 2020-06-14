//
//  ContentView.swift
//  TarotOfLight
//
//  Created by xz on 2020/6/13.
//  Copyright © 2020 xz. All rights reserved.
//

import SwiftUI
import UIKit
import SDWebImageSwiftUI

struct ContentView: View {
    let rTarget = Double.random(in: 0..<1)
    let gTarget = Double.random(in: 0..<1)
    let bTarget = Double.random(in: 0..<1)
    @State var rGuess: Double
    @State var gGuess: Double
    @State var bGuess: Double
    @State var showAlert: Bool = false
    @State var catAnimating: Bool = true
    
    func computeScore() -> Int {
        let rDiff = rGuess - rTarget
        let gDiff = gGuess - gTarget
        let bDiff = bGuess - bTarget
        let diff = sqrt(rDiff*rDiff + gDiff*gDiff + bDiff*bDiff)
        return Int((1.0 - diff) * 100.0 + 0.5)
    }
    
    var body: some View {
        VStack {
            HStack {
                // Targe color block
                VStack {
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget, opacity: 1.0))
                    Text("Match this color")
                }.padding()
                // Guess color block
                VStack {
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 1.0))
                    HStack {
                        Text("R: \(Int(rGuess*255.0))")
                        Text("G: \(Int(gGuess*255.0))")
                        Text("B: \(Int(bGuess*255.0))")
                    }
                }.padding()
            }.background(Color.black.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(10)
            
            
            Button(action: {
                self.showAlert = true
                self.catAnimating = false
            }) {
                VStack {
                    Text("Hit Me!").font(.title)
                    Text("And get your score").font(.subheadline)
                }.padding()
            }.alert(isPresented: $showAlert) {
                Alert(title: Text("Your Score"), message: Text("\(computeScore())"), dismissButton: Alert.Button.default(Text("I got it."), action: {
                    self.catAnimating = true
                }))
            }.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
            VStack {
                ColorSlider(value: $rGuess, text_color: .red)
                ColorSlider(value: $gGuess, text_color: .green)
                ColorSlider(value: $bGuess, text_color: .blue)
            }
            
//            CircleImage().frame(height:300).padding()
            
            WebImage(url: URL(fileURLWithPath: Bundle.main.path(forResource: "catty", ofType: "gif") ?? "catty.gif"), isAnimating: $catAnimating)
                .resizable()
                .playbackRate(1.0)
                .scaledToFill()
                .frame(width:200,height:200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                 
            PageSelector()
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rGuess: 0.5, gGuess: 0.5, bGuess: 0.5)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
    }
}

struct PageSelector: View {
    var body: some View {
        HStack {
            Text("Placeholder")
            Text("Placeholder")
            Text("Placeholder")
        }.padding().background(Color.black.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct ColorSlider: View {
    @Binding var value: Double
    var text_color: Color
    var body: some View {
        HStack {
            Text("0").foregroundColor(text_color)
            Slider(value: $value)
            Text("255").foregroundColor(text_color)
        }.padding()
    }
}
