//
//  ViewController.swift
//  FirebaseAnalyticsDemo
//
//  Created by Ashish Patel on 1/5/17.
//  Copyright © 2017 ashish.me. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FIRAnalytics.logEvent(withName: "viewedScreen", parameters: [
            "screen_name": "ViewController" as NSObject
            ])

        FIRAnalytics.logEvent(withName: "openedWebsite", parameters: [
            "content_type": "Website" as NSObject,
            "item_id": "visited_official_website" as NSObject
            ])

        FIRAnalytics.logEvent(withName: "sentEmail", parameters: [
            "email": "nitor@gmail.com" as NSObject,
            "content_type": "sedn_email_category" as NSObject,
            "item_id": "sendEmailAction" as NSObject
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

