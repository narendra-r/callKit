//
//  PushHandler.swift
//  SmartCall
//
//  Created by Narendra Kumar R on 7/3/18.
//  Copyright © 2018 Narendra Kumar R. All rights reserved.
//

import Foundation
import PushKit

extension AppDelegate: PKPushRegistryDelegate {
    
    func setPushResistory() {
        pushRegistor = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistor?.delegate = self
        pushRegistor?.desiredPushTypes = [.voIP]
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print("push kit token \(credentials.token.base16EncodedString(uppercase: true))")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        guard type == .voIP, let payloadJson = payload.dictionaryPayload as? [String: Any] else { return }
        print("Pushkit notification received..")
        print(payloadJson)

        if let uuidString = payload.dictionaryPayload["UUID"] as? String,
            let handle = payload.dictionaryPayload["handle"] as? String,
            let hasVideo = payload.dictionaryPayload["hasVideo"] as? Bool,
            let uuid = UUID(uuidString: uuidString){
            displayIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo)
        }
    }
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((Error?) -> Void)? = nil) {
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }
    
}
