//
//  WelcomeScreen.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 7/20/21.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @State var userName = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Buffalo Concussion Treadmill Test")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                TextField("Name", text: $userName)
                    .padding(.vertical, 50)
                    .padding(.horizontal, 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                NavigationLink(
                    destination: ActivityScreen(name: self.$userName),
                    label: {
                        Text("Start Test")
                            .font(.title2)
                    })
            }
        }
        
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
