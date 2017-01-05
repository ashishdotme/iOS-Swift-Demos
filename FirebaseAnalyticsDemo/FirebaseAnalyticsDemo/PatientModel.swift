//
//  PatientModel.swift
//  FirebaseAnalyticsDemo
//
//  Created by Ashish Patel on 1/6/17.
//  Copyright © 2017 ashish.me. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PatientModel: NSObject {
    
    var name : String
    var age: String
    var disease : String
    
    init(name: String, age: String, disease: String) {
        self.name = name
        self.age = age
        self.disease = disease
    }
    
//    init(snapshot: FIRDataSnapshot) {
//        name = snapshot.value!["pName"] as! String
//        age = snapshot.value!["pNumber"] as! String
//        disease = snapshot.value!["pEmail"] as! String
//        ref = snapshot.ref
//    }

}
