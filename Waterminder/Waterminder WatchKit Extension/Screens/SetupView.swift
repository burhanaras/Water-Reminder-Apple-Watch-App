//
//  SetupView.swift
//  Waterminder WatchKit Extension
//
//  Created by Burhan Aras on 23.08.2020.
//  Copyright © 2020 Carlos Corrêa. All rights reserved.
//

import SwiftUI
import Combine

struct SetupView: View {
    @State var showWelcomeScreen = AppData.showIntro
    @State var target: Double
    @State var weight: Double
    @State var dailyWorkOut: Double
    
    var newTargetSelected: (Double) -> Void
    
    var body: some View {
        
        VStack{
            VStack {
                Spacer()
                Text("Hydration Calculator")
                    .font(.system(.headline, design: .rounded))
                Spacer()
                HStack(alignment: .bottom){
                    
                    Text("Body Weight").font(.system(size: 12, weight: .semibold, design: .rounded)).alignmentGuide(.leading) { d in d[.leading] }
                    Spacer()
                    Text(String(Int(weight)))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
                    Text("kg     ")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                    .focusable()
                    .digitalCrownRotation($weight, from: 10.0, through: 200.0, by: 1)
                    .onReceive(Just(weight)) { output in
                        self.target = self.weight * 44 + ( (self.dailyWorkOut / 15) * 120 )
                }
                
                Spacer()
                HStack (alignment: .bottom){
                    Text("Daily Workout").font(.system(size: 12, weight: .semibold, design: .rounded)).alignmentGuide(.leading) { d in d[.leading] }
                    Spacer()
                    Text(String(Int(dailyWorkOut)))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
                    Text("mins")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                    .focusable()
                    .digitalCrownRotation($dailyWorkOut, from: 0, through: 180, by: 1)
                    .onReceive(Just(dailyWorkOut)) { workOut in
                        self.target = self.weight * 44 + ( (self.dailyWorkOut / 15) * 120 )
                }
                
                Spacer()
                Button(action: {
                    AppData.dailyWorkOut = self.dailyWorkOut
                    AppData.weight = self.weight
                    AppData.target = self.target
                    self.newTargetSelected(self.target)
                }) {
                    
                    HStack{
                        Text("Save")
                        Text(target.toMilliliters())
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.init(red: 0, green: 0.8, blue: 1))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView(target: 4000, weight: 70, dailyWorkOut: 30){ target in
            print(target)
        }
    }
}
