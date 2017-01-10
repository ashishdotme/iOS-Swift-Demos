//  EncounterAppChat
//
//  Created by Ashish Patel on 1/10/17.
//  Copyright © 2017 Nitor Infotech. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    
    //MARK: Methods

   class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        FIRDatabase.database().reference().child("Doctors").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as! [String: String]
            let name = data["doctorname"]!
            let email = data["specialityId"]!
            let id = data["doctorId"]
            let link = URL.init(string: "https://firebasestorage.googleapis.com/v0/b/demoproj-59ecf.appspot.com/o/usersProfilePics%2FkO0FibyNvSgMbuaMcYAecYngN8s2?alt=media&token=97396ae7-98bc-4739-960f-1c9a65602635")
            URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                if error == nil {
                    let profilePic = UIImage.init(data: data!)
                    let user = User.init(name: name, email: email, id: id!, profilePic: profilePic!)
                    completion(user)
                }
            }).resume()
        })
    }

    class func downloadAllAppointments(patientID: String, completion: @escaping (User) -> Swift.Void) {
        FIRDatabase.database().reference().child("Appointment").queryOrdered(byChild: "patient_id").queryEqual(toValue: patientID).observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value as! [String: Any]
            let appointmentDict = data as! [String: String]
                let id = appointmentDict["patient_id"]!
                let name = appointmentDict["doc_id"]!
                let email = appointmentDict["spl_id"]!
                let link = URL.init(string: "https://firebasestorage.googleapis.com/v0/b/demoproj-59ecf.appspot.com/o/usersProfilePics%2FkO0FibyNvSgMbuaMcYAecYngN8s2?alt=media&token=97396ae7-98bc-4739-960f-1c9a65602635")
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: name, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()

        })
    }
    

    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
}

