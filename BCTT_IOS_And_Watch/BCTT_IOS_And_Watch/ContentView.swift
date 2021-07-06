//
//  ContentView.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 6/30/21.
//

import SwiftUI

struct ContentView: View {
    
    var model = ViewModelPhone()
    
    @State var reachable = "No"
    @State var heartRateToDisplay = "No Heart Rate Available"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Reachable \(reachable)")
            
            Button(action: {
                //need to make this continously happen
                //heartRateToDisplay = String(self.model.heartRateFromWatch)
                
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
        
        Text("Heart Rate: \(heartRateToDisplay)").onReceive(timer, perform: { _ in
            heartRateToDisplay = String(self.model.heartRateFromWatch)
        })
        
        
    }
    
    //DispatchQueue.main.async {
        //heartRateToDisplay = String(self.model.heartRateFromWatch)
    //}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
