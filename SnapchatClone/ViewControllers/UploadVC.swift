//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectImage = UIImageView()
    var uploadButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        selectImage.image = UIImage(named: "selectImage")
        selectImage.frame = CGRect(x: width * 0.5 - width * 0.8 / 2, y: height * 0.3 - height * 0.3 / 2, width: width * 0.8, height: height * 0.3)
        view.addSubview(selectImage)
        selectImage.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosPicture))
        selectImage.addGestureRecognizer(gestureRecognizer)
        
        uploadButton.setTitle("Upload", for: UIControl.State.normal)
        uploadButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        uploadButton.frame = CGRect(x: width * 0.5 - width * 0.16 / 2, y: height * 0.5 - height * 0.05 / 2, width: width * 0.16, height: height * 0.05)
        uploadButton.addTarget(self, action: #selector(uploadClick), for: UIControl.Event.touchUpInside)
        view.addSubview(uploadButton)
        
    }
    
    @objc func choosPicture(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }

    @objc func uploadClick(){
        
        let storage = Storage.storage()
        let storegeRef = storage.reference()
        
        let mediaFolder = storegeRef.child("media")
        
        if let data = selectImage.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { metadata, error in
                
                if error != nil {
                    
                    self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                    
                }else{
                    
                    imageRef.downloadURL { url, error in
                        
                        if error != nil {
                            
                            self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                            
                        }else{
                            
                            let imageUrl = url?.absoluteString
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snaphot, error in
                                
                                if error != nil{
                                    
                                    self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                                    
                                }else{
                                    
                                    if snaphot?.isEmpty == false && snaphot != nil{
                                        
                                        for document in snaphot!.documents{
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                
                                                imageUrlArray.append(imageUrl!)
                                                let additionalDic = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDic, merge: true) { error in
                                                    
                                                    if error != nil {
                                                        
                                                        self.alert(alertTitle: "Error", alertMessage: error?.localizedDescription ?? "Error!")
                                                        
                                                    }else{
                                                    
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.selectImage.image = UIImage(named: "selectImage")
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                    }else{
                                        
                                        let snapDic = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDic) { error in
                                            
                                            if error != nil{
                                                
                                                self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                                                
                                            }else{
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                self.selectImage.image = UIImage(named: "selectImage")
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                            
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
