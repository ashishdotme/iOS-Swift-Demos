//
//  PatientTableVC.swift
//  FirebaseAnalyticsDemo
//
//  Created by Ashish Patel on 1/6/17.
//  Copyright © 2017 ashish.me. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PatientTableVC: UIViewController {
    @IBOutlet weak var patientTable: UITableView!
    var ref: FIRDatabaseReference!
    var patientList: [PatientModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Doctors.doctorId)
        ref = FIRDatabase.database().reference()
//        ref.child("appointments").child(Doctors.doctorId!.toBase64()).observe(.value, with: { snapshot in
//            for child in snapshot.children {
//                let patient = (child as AnyObject) as? NSDictionary
//                let name = patient?["name"] as? String ?? ""
//                let age = patient?["age"] as? String ?? ""
//                let disease = patient?["disease"] as? String ?? ""
//                self.patientList.append(PatientModel(name: name, age: age, disease: disease))
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.patientTable.reloadData()
//                })
//            }
//        })
        ref.child("appointments").child(Doctors.doctorId!.toBase64()).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                print(child)
                let patientNames: FIRDataSnapshot = child as! FIRDataSnapshot
                let patient = patientNames.value as! NSDictionary
                //let patient = child as! Dictionary<String, AnyObject>
                let name = patient["name"] as? String ?? ""
                let age = patient["age"] as? String ?? ""
                let disease = patient["disease"] as? String ?? ""
                self.patientList.append(PatientModel(name: name, age: age, disease: disease))
                DispatchQueue.main.async(execute: { () -> Void in
                     self.patientTable.reloadData()
                })
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PatientTableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Instantiate a cell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        // Adding the right informations
        let patient = patientList[indexPath.row]
        cell.textLabel?.text = patient.name
        cell.detailTextLabel?.text = patient.disease
        
        // Returning the cell
        return cell
    }
    
}
