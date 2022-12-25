//
//  ContentView.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 10/10/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var handGestureProcessor = HandGestureModel()
    var sharePlayViewModel: ObservedObject<SharePlayViewModel>
    
    init(handGestureProcessor: HandGestureModel = HandGestureModel()) {
        self.handGestureProcessor = handGestureProcessor
        self.sharePlayViewModel = ObservedObject(wrappedValue: SharePlayViewModel(morseCodeModel: handGestureProcessor.morse))
    }
    var body: some View {
        VStack {
            Button("Start SharePlay") {
                sharePlayViewModel.wrappedValue.startSharing()
            }
            Text("\(handGestureProcessor.timePinchedCount)")
            CameraFeedView(gestureProcessor: handGestureProcessor) // This is a custom view made to show the camera.
                .cornerRadius(8.0)
                .padding()
            Text(handGestureProcessor.morse.currString)
            Text(handGestureProcessor.morse.translatedString)
        }
        .task {
            for await session in SharePlayActivity.sessions() {
                sharePlayViewModel.wrappedValue.configureGroupSession(session)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
