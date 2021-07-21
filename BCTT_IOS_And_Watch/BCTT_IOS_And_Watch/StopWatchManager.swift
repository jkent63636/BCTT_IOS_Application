//
//  StopWatchManager.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 7/20/21.
//

import SwiftUI

enum stopWatchMode {
    case running
    case stopped
}

class StopWatchManager: ObservableObject {
    
    @Published var mode: stopWatchMode = .stopped
    @Published var secondsElapsed = 0.0
    @Published var timeToDisplay = "00:00"  //this is not designed to go into hours since the test should not be longer than 20 minutes
    
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed + 0.1
            var mins = "\(Int(self.secondsElapsed / 60))"
            
            if mins.count == 1 {
                mins = "0\(mins)"
            }
            
            var secs = "\(Int(self.secondsElapsed.truncatingRemainder(dividingBy: 60)))"
            
            if secs.count == 1 {
                secs = "0\(secs)"
            }
            
            self.timeToDisplay = "\(mins):\(secs)"
        }
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        timeToDisplay = "00:00"
        mode = .stopped
    }
    
}
