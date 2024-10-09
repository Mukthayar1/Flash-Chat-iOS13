import UIKit
import FirebaseAuth
import Toaster

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var message : [Message] = [
        Message(sender:"abc@gmail.com",body:"there ?"),
        Message(sender:"abc@gmail.com",body:"Please reply ?"),
        Message(sender:"muk@gmail.com",body:"Yes ?"),
        Message(sender:"abc@gmail.com",body:"No ?"),
        Message(sender:"abc@gmail.com",body:"Why ?"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier:Constants.cellIdentifier)
//        tableView.delegate = self
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = "\(message[indexPath.row].body)";
        return cell
    }
}

//extension ChatViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
