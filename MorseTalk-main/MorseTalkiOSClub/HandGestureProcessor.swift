//
//  HandGestureProcessor.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 10/11/22.
//

import Foundation
import CoreGraphics

class HandGestureModel: ObservableObject {
    // Distance
    // The current state of the hand
    // The time of contact
    typealias PointsPair = (thumbTip: CGPoint, indexTip: CGPoint)
    let pinchThreshold: CGFloat
    let countThreshold = 3
    @Published var morse : MorseCode = MorseCode();
    
    enum HandState {
        case pinched, apart, inProgress, unknown
    }
    
    @Published var timePinchedCount = 0.0
    var timePinchedTimer: Timer?
    var isPinchedCount = 0
    var isApartCount = 0
    var currentState: HandState = .unknown {
        willSet {
            if (currentState != .pinched && currentState != .unknown && newValue == .pinched) {
                timePinchedTimer = .scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.timePinchedCount += 1
                }
            }
        }
    }
    
    init(pinchThreshold: CGFloat = 40) {
        self.pinchThreshold = pinchThreshold
    }
    
    func reset() {
        currentState = .unknown
        timePinchedTimer?.invalidate()
        timePinchedCount = 0
        isApartCount = 0
        isPinchedCount = 0
    }
    
    func updatePoints(pointsPair: PointsPair) {
        let distance = pointsPair.indexTip.distance(from: pointsPair.thumbTip)
        if distance <= pinchThreshold {
            isPinchedCount += 1
            isApartCount = 0
//            if (currentState != .pinched) {
//                currentState = .pinched
//            }
            if (isPinchedCount < countThreshold) {
                currentState = .inProgress
            } else {
                currentState = .pinched
            }
//            currentState = (isPinchedCount > countThreshold && currentState != .pinched) ? .pinched : .inProgress
        } else if (distance > pinchThreshold) {
            isApartCount += 1
            if (timePinchedCount >= 3) {
                morse.addChar("-")
            } else if (timePinchedCount >= 1) {
                morse.addChar(".")
                
            }
            //            } else if ("charspace") {
            //                morse.addChar("&")
            //            } else if ("wordspace") {
            //                morse.addChar(" ")
            //            }
            isPinchedCount = 0
            // timePinchedTimer = 0
            timePinchedTimer?.invalidate()
            currentState = (isApartCount > countThreshold) ? .apart : .inProgress
            timePinchedCount = 0
        }
        
        
        if (currentState == .unknown) {
            timePinchedCount = 0
            timePinchedTimer?.invalidate()
        }
//        } else {
//            currentState = .unknown
//            timePinchedCount = 0
//            timePinchedTimer?.invalidate()
//        }
    }
}

extension CGPoint {
    
    func distance(from otherPoint: CGPoint) -> CGFloat {
        return hypot(self.x - otherPoint.x, self.y - otherPoint.y)
    }
    
}
