//
//  ViewController.swift
//  SmartCall
//
//  Created by Narendra Kumar R on 7/3/18.
//  Copyright © 2018 Narendra Kumar R. All rights reserved.
//

import UIKit
import CallKit
class ViewController: UIViewController {
    
    @IBOutlet weak var callButton: UIButton!
    
    var currentCallUUID: UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        callButton.setTitle("End call", for: .selected)
        registerCallsChange()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCallsChange(){
        NotificationCenter.default.addObserver(self, selector: #selector(didUpadteCall), name: SpeakerboxCallManager.CallsChangedNotification, object: nil)
    }
    
    @objc private func didUpadteCall(){
        if let currntCall = AppDelegate.shared.callManager.calls.first {
            self.currentCallUUID = currntCall.uuid
            callButton.isSelected = true
        } else {
            callButton.isSelected = false
        }
    }

    @IBAction func callAction(_ sender: UIButton) {
        if sender.isSelected == true {
            endOutCall()
        } else {
            updateNewOutCall()
        }
        sender.isSelected = !sender.isSelected
    }
    
    private func updateNewOutCall(){
        let uuid = UUID()
        self.currentCallUUID = uuid
        let handle = CXHandle(type: .phoneNumber, value: "Brother")
        
        let startCallAction = CXStartCallAction.init(call: uuid, handle: handle)
        
        let transaction = CXTransaction(action: startCallAction)
        AppDelegate.shared.callManager.callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    
    private func endOutCall(){
        guard let uuid = currentCallUUID else{
            return
        }
        let endCallAction = CXEndCallAction.init(call: uuid)
        let transcation = CXTransaction.init(action: endCallAction)

        AppDelegate.shared.callManager.callController.request(transcation) { (error) in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
    

    
}

