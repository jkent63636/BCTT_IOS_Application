//
//  ViewModelPhone.swift
//  BCTT_IOS_And_Watch
//
//  Created by Joshua Kent on 7/6/21.
//

import Foundation
import WatchConnectivity

class ViewModelPhone: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
    @Published var heartRateFromWatch = 0
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            DispatchQueue.main.async {
                self.heartRateFromWatch = message["message"] as? Int ?? 0
            }
        }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
