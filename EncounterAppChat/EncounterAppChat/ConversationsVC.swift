//  EncounterAppChat
//
//  Created by Ashish Patel on 1/10/17.
//  Copyright © 2017 Nitor Infotech. All rights reserved.
//


import UIKit
import Firebase
import AudioToolbox

class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ConversationsVC.showContacts))
        return button
    }()
    var items = [Conversation]()
    var selectedUser: User?
    
    //MARK: Methods

    
    //Downloads conversations
    func fetchData() {
        Conversation.showConversations { (conversations) in
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        break
                    }
                }
            }
        }
    }


    //Shows contacts extra view
    func showContacts() {
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }

    
    //Shows Chat viewcontroller with given user
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }

    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            cell.nameLabel.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.messageLabel.text = message
            default:
                cell.messageLabel.text = "Media"
            }
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
       
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.customization()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = self.leftButton
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}





