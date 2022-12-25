//
//  SharePlayActivity.swift
//  MorseTalkiOSClub
//
//  Created by Rahul Narayanan on 11/29/22.
//

import SwiftUI
import GroupActivities

struct SharePlayActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var meta = GroupActivityMetadata()

        meta.title = NSLocalizedString("MorseTalk SharePlay", comment: "")
        meta.type = .generic
        
        return meta
    }
}

class SharePlayViewModel: ObservableObject {
    
    @Published var morseCodeModel: MorseCode
    
    init(morseCodeModel: MorseCode) {
        self.morseCodeModel = morseCodeModel
    }
    
    var tasks = Set<Task<Void, Never>>()
    var messenger: GroupSessionMessenger?
    
    func configureGroupSession(_ session: GroupSession<SharePlayActivity>) {
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger
        
        let task = Task {
            for await (translatedString, _) in messenger.messages(of: String.self) {
                didReceive(translatedString)
            }
        }
        tasks.insert(task)
        
        session.join()
    }
    
    func send(_ newString: String) {
        Task {
            do {
                try await messenger?.send(newString)
            } catch {
                print("Could not send message")
            }
        }
    }
    
    func didReceive(_ newString: String) {
        // set this device's model's translatedString to newString
        morseCodeModel.translatedString = newString
    }
    
    // Intents
    func startSharing() {
        Task {
            do {
                _ = try await SharePlayActivity().activate()
            } catch {
                print("Failed to activate SharePlay: \(error)")
            }
        }
    }
    
}
