//
//  ContentView.swift
//  BCTT_IOS_And_Watch WatchKit Extension
//
//  Created by Joshua Kent on 6/30/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    var model = ViewModelWatch()
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State private var heartRateStateVar = 0
    
    var body: some View {
        VStack{
            HStack{
                Text("❤️")
                    .font(.system(size: 20))
                
                Text("\(heartRateStateVar)")
                    .fontWeight(.regular)
                    .font(.system(size: 65))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
            }
        }
        .padding()
        .onAppear(perform: start)
    }

    
    func start() {
        //authorize access to heart rate
        autorizeHealthKit()
        
        //starts query to get heart rate
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
        
            
        // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        
        //print(samples) samples is an empty list
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            //Times and prints HR
            let currentDateTime = Date()
            print("\(currentDateTime): \(lastHeartRate)")
            
            self.heartRateStateVar = Int(lastHeartRate)
            
            //sends message from watch to iPhone
            self.model.session.sendMessage(["message" : self.heartRateStateVar], replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
