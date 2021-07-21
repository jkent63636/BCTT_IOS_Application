//
//  ContentView.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 6/30/21.
//

import SwiftUI

struct ActivityScreen: View {
    
    var model = ViewModelPhone()
    
    //timer to update hear rate
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var reachable = "No"
    @State var heartRateToDisplay = "0"
    
    //stop watch
    @ObservedObject var stopWatchManager = StopWatchManager()
    
    //name from welcome screen
    @Binding var name: String
    
    var body: some View {
        
        VStack {
            Text("Welcome \(name)")
                .font(.system(size: 50))
            
            Spacer()
            
            VStack {
                Text(stopWatchManager.timeToDisplay)
                    .font(.system(size: 80))
                    .fontWeight(.medium)
                
                if stopWatchManager.mode == .stopped {
                    Button(action: {
                        self.stopWatchManager.start()
                    }) {
                        TimerButton(label: "Start Test", buttonColor: .blue)
                    }
                    .padding()
                }
                if stopWatchManager.mode == .running {
                    Button(action: {
                        self.stopWatchManager.stop()
                        
                        //implement /api/endsession HERE
                        
                        
                        
                        
                    }) {
                        TimerButton(label: "End Test", buttonColor: .red)
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            HStack {
                Text("❤️")
                    .font(.system(size: 55))
                
                Text("\(heartRateToDisplay)").onReceive(timer, perform: { _ in
                    heartRateToDisplay = String(self.model.heartRateFromWatch)
                    
                    //implement /api/pushdata HERE
                    
                    
                    
                    
                    
                })
                .font(.system(size: 100))

                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text("Connected to watch:  \(reachable)")
                
                Button(action: {
                    if self.model.session.isReachable { //fix this
                        self.reachable = "Yes"
                    } else {
                        self.reachable = "No"
                    }
                }) {
                    Text("Update")
                }
            }
            .padding()
            
        }
        .padding()
        
        .onAppear(perform: startNewSession)
    }
    
    func startNewSession() {
        print("User name: \(name)")
        //implement /api/newsession HERE
    }
}


struct TimerButton: View {
    let label: String
    let buttonColor: Color
    
    var body: some View {
        Text(label)
            .foregroundColor(.white)
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background(buttonColor)
            .cornerRadius(10)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityScreen()
//    }
//}
