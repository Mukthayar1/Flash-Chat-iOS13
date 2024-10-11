import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth
import Toaster

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore();
    
    var message : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier:Constants.cellIdentifier);
        loadMessage();
        //      tableView.delegate = self
    }
    
    func loadMessage(){
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("There was error \(e)")
            } else {
                self.message = [];
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data();
                        if let sender = data[Constants.FStore.senderField] as? String , let body = data[Constants.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: body);
                            self.message.append(newMessage);
                            DispatchQueue.main.async {
                                self.tableView.reloadData();
                                let indexPath = IndexPath(item: self.message.count - 1 , section: 0);
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if  let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField:messageSender,
                Constants.FStore.bodyField:messageBody,
                Constants.FStore.dateField:Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("eeee",e)
                } else {
                    print("Message sended")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func logoutUser(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentMessage = message[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = "\(currentMessage.body)";
        
        
        if currentMessage.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true;
            cell.rightImageView.isHidden = false;
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple);
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false;
            cell.rightImageView.isHidden = true;
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple);
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        

        return cell
    }
}

//extension ChatViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
