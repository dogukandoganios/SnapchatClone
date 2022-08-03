//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var feedTableView = UITableView()
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
        
        feedTableView.frame = CGRect(x: width * 0.5 - width * 0.9 / 2, y: height * 0.5 - height * 0.9 / 2, width: width * 0.9, height: height * 0.9)
        feedTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        feedTableView.backgroundColor = UIColor.clear
        feedTableView.separatorColor = UIColor.clear
        view.addSubview(feedTableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let width = feedTableView.frame.size.width
        let height = feedTableView.frame.size.height
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath) as! CustomTableViewCell
        cell.backView.frame = CGRect(x: 0, y: 0, width: width * 1, height: height * 0.9)
        cell.userImage.frame = CGRect(x: width * 0.5 - width * 0.8 / 2, y: height * 0.5 - height * 0.7 / 2, width: width * 0.8, height: height * 0.7)
        cell.userImage.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        cell.userName.text = self.snapArray[indexPath.row].userName
        cell.userName.frame = CGRect(x: width * 0.5 - width * 0.5 / 2, y: height * 0.1 - height * 0.05 / 2, width: width * 0.5, height: height * 0.05)
        cell.userName.textAlignment = .center
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height
        return height * 0.85
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSnapVC"{
            
            let destinationVC = segue.destination as! SnapVC
            
            destinationVC.selectSnap = choosenSnap
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
        
    }
    
    func getSnapsFromFirebase(){
        
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documendtId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String{
                            
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                
                                if let date = document.get("date") as? Timestamp{
                                    
                                    if let dif = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        
                                        if dif  >= 24{
                                            
                                            self.fireStoreDatabase.collection("Snaps").document(documendtId).delete { error in
                                                
                                                self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                                            }
                                            
                                        }else{
                                            
                                            let snap = Snap(userName: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDif: 24 - dif)
                                            self.snapArray.append(snap)
                                            
                                        }
                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    self.feedTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func getUserInfo(){
        
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            
            if error != nil {
                
                self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents{
                        
                        if let username = document.get("username") as? String{
                            
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func alert(alertTitle : String, alertMessage : String){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
