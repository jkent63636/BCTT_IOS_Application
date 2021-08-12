//
//  ContentView.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 6/30/21.
//

//TO DO:
//1. Get sessionID in newsession call
//2. Get HR and time data to show on website


import SwiftUI

struct ActivityScreen: View {
    
    var model = ViewModelPhone()
    
    //timer to update hear rate
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var reachable = "No"
    @State var heartRateToDisplay = "0"
    @State var sessionID = "-1"
    
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
                        
                        //calls function that does endSession API call
                        self.endSession()
                        
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
                    //heartRateToDisplay = String(self.model.heartRateFromWatch)
                    
                    if stopWatchManager.secondsElapsed % 5 == 0 && stopWatchManager.secondsElapsed != 0 {
                        //create a timp stamp
                        let time = [Int(Date().timeIntervalSince1970)]

                        //-1 means there is an error
                        let hrToSend = [Int(heartRateToDisplay) ?? -1]
                        
                        //for testing
                        //let hrToSend = [Int.random(in: 70..<90)]
                        //heartRateToDisplay = "\(hrToSend[0])"
                        
                        self.pushData(heartRate: hrToSend, timeStamp: time)
                    }
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
    
    //implement /api/newsession HERE
    //sends patient name to make a new session, recieves a session ID
    func startNewSession() {
        print("User name: \(name)")
        
        //prepare data in JSON format
        let json: [String: Any] = ["name": name]
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // actual API call
        let url = URL(string: "http://localhost:3000/api/newsession")!
        var request = URLRequest(url: url)
        //request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Session ID: \(dataString)")
                sessionID = dataString
            }
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//            if responseJSON == nil { print("Its nill")}
//
//            if let responseJSON = responseJSON as? [String: Any] { //changed [String: Any] to String
//                print("rj: \(responseJSON)")
//                for key in responseJSON.keys {
//                   print("\(key)")
//                }
//
//            }
        }.resume()
    }
    
    //implement /api/pushdata HERE
    //sends heart rate and time stamp, recieves nothing
    func pushData(heartRate: [Int], timeStamp: [Int]) {
        print("Pushing data . . . HR: \(heartRate), time: \(timeStamp)")
        
        //prepare data in JSON format
        let json: [String: Any] = ["data": heartRate, "timestamp": timeStamp, "sessionid": sessionID]
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // actual API call
        let url = URL(string: "http://localhost:3000/api/pushdata")!
        var request = URLRequest(url: url)
        //request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Nothing that is returned, so just check for errors
            if let error = error {
            print("There was an error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    //implement /api/endsession HERE
    //sends session id, recieves nothing
    func endSession() {
        
        //prepare data in JSON format
        let json: [String: Any] = ["sessionid": sessionID]
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // actual API call
        let url = URL(string: "http://localhost:3000/api/endsession")!
        var request = URLRequest(url: url)
        //request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Nothing that is returned, so just check for errors
            if let error = error {
            print("There was an error: \(error.localizedDescription)")
            }
        }.resume()
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
