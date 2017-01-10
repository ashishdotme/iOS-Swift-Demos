//  EncounterAppChat
//
//  Created by Ashish Patel on 1/10/17.
//  Copyright © 2017 Nitor Infotech. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class Message {
    
    //MARK: Properties
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    private var toID: String?
    private var fromID: String?
    
    //MARK: Methods
    class func downloadAllMessages(forUserID: String, completion: @escaping (Message) -> Swift.Void) {
        let patientId: String? = "P01"
        if let currentUserID = patientId {
            FIRDatabase.database().reference().child("Conversations").child("users").child(currentUserID).child("Conversations").child(forUserID).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    FIRDatabase.database().reference().child("Conversations").child("messages").child(location).observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let messageType = receivedMessage["type"] as! String
                            let type = MessageType.text
                            let content = receivedMessage["content"] as! String
                            let fromID = receivedMessage["fromID"] as! String
                            let timestamp = receivedMessage["timestamp"] as! Int
                            if fromID == currentUserID {
                                let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true)
                                completion(message)
                            } else {
                                let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                                completion(message)
                            }
                        }
                    })
                }
            })
        }
    }

   
    func downloadLastMessage(forLocation: String, completion: @escaping (Void) -> Swift.Void) {
        let patientId: String? = "P01"
        if let currentUserID = patientId {
            FIRDatabase.database().reference().child("Conversations").child("messages").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        let receivedMessage = (snap as! FIRDataSnapshot).value as! [String: Any]
                        self.content = receivedMessage["content"]!
                        self.timestamp = receivedMessage["timestamp"] as! Int
                        let messageType = receivedMessage["type"] as! String
                        let fromID = receivedMessage["fromID"] as! String
                        self.isRead = receivedMessage["isRead"] as! Bool
                        var type = MessageType.text
                        switch messageType {
                        case "text":
                            type = .text
                        default: break
                        }
                        self.type = type
                        if currentUserID == fromID {
                            self.owner = .receiver
                        } else {
                            self.owner = .sender
                        }
                        completion()
                    }
                }
            })
        }
    }

    class func send(message: Message, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
        let patientId: String? = "P01"
        print(toID)
        if let currentUserID = patientId {
            switch message.type {
            case .text:
                let values = ["type": "text", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
                Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                    completion(status)
                })
            }
        }
    }
    
    class func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> Swift.Void) {
        let patientId: String? = "P01"
        if let currentUserID = patientId {
            FIRDatabase.database().reference().child("Conversations").child("users").child(currentUserID).child("Conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: String]
                    let location = data["location"]!
                    FIRDatabase.database().reference().child("Conversations").child("messages").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                        if error == nil {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    FIRDatabase.database().reference().child("Conversations").child("messages").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                        let data = ["location": reference.parent!.key]
                        FIRDatabase.database().reference().child("Conversations").child("users").child(currentUserID).child("Conversations").child(toID).updateChildValues(data)
                        FIRDatabase.database().reference().child("Conversations").child("users").child(toID).child("Conversations").child(currentUserID).updateChildValues(data)
                        completion(true)
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
