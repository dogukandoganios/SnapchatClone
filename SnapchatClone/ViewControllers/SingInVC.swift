//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit
import Firebase

class SingInVC: UIViewController {

    var titleLabel = UILabel()
    var emailTextField = UITextField()
    var usernameTextField = UITextField()
    var passwordTextField = UITextField()
    var singInButton = UIButton()
    var singUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        titleLabel.text = "Snapchat Clone"
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 30)
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: width * 0.5 - width * 0.8 / 2, y: height * 0.15 - height * 0.1 / 2, width: width * 0.8, height: height * 0.1)
        view.addSubview(titleLabel)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail Adress", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.withAlphaComponent(0.5)])
        emailTextField.textAlignment = .center
        emailTextField.layer.borderWidth = 1
        emailTextField.frame = CGRect(x: width * 0.5 - width * 0.65 / 2, y: height * 0.25 - height * 0.05 / 2, width: width * 0.65, height: height * 0.05)
        view.addSubview(emailTextField)
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.withAlphaComponent(0.5)])
        usernameTextField.textAlignment = .center
        usernameTextField.layer.borderWidth = 1
        usernameTextField.frame = CGRect(x: width * 0.5 - width * 0.65 / 2, y: height * 0.32 - height * 0.05 / 2, width: width * 0.65, height: height * 0.05)
        view.addSubview(usernameTextField)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray.withAlphaComponent(0.5)])
        passwordTextField.textAlignment = .center
        passwordTextField.layer.borderWidth = 1
        passwordTextField.frame = CGRect(x: width * 0.5 - width * 0.65 / 2, y: height * 0.42 - height * 0.05, width: width * 0.65, height: height * 0.05)
        view.addSubview(passwordTextField)
        
        singInButton.setTitle("Sing In", for: UIControl.State.normal)
        singInButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        singInButton.frame = CGRect(x: width * 0.25 - width * 0.16 / 2, y: height * 0.5 - height * 0.05 / 2, width: width * 0.16, height: height * 0.05)
        singInButton.addTarget(self, action: #selector(singInClick), for: UIControl.Event.touchUpInside)
        view.addSubview(singInButton)
        
        singUpButton.setTitle("Sing Up", for: UIControl.State.normal)
        singUpButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        singUpButton.frame = CGRect(x: width * 0.75 - width * 0.16 / 2, y: height * 0.5 - height * 0.05 / 2, width: width * 0.16, height: height * 0.05)
        singUpButton.addTarget(self, action: #selector(singUpClick), for: UIControl.Event.touchUpInside)
        view.addSubview(singUpButton)
    }

    @objc func singInClick(){
        
    }
    
    @objc func singUpClick(){
        
        if emailTextField.text != "" && usernameTextField.text != "" && passwordTextField.text != ""{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { auth, error in
                
                if error != nil {
                    
                    self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error!")
                    
                }else{
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailTextField.text!, "username" : self.usernameTextField.text!] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        
                        
                        if error != nil {
                            
                            self.alert(alertTitle: "Error!", alertMessage: error?.localizedDescription ?? "Error")
                            
                        }else{
                            
                        }
                        
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
        }else{
            
            alert(alertTitle: "Error!", alertMessage: "Email, Username or Password not nil!")
            
        }
        
    }
    
    func alert(alertTitle : String, alertMessage : String){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }

}

