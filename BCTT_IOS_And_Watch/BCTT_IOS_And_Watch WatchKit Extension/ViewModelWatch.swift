//
//  ViewModelWatch.swift
//  BCTT_IOS_And_Watch WatchKit Extension
//
//  Created by Joshua Kent on 7/6/21.
//

import Foundation
import WatchConnectivity

class ViewModelWatch: NSObject, WCSessionDelegate {

    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
