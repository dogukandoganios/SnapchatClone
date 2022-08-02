//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit

class SettingsVC: UIViewController {

    var logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        logOutButton.setTitle("Log Out", for: UIControl.State.normal)
        logOutButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        logOutButton.frame = CGRect(x: width * 0.5 - width * 0.16 / 2, y: height * 0.5 - height * 0.1 / 2, width: width * 0.16, height: height * 0.1)
        logOutButton.addTarget(self, action: #selector(logOutClick), for: UIControl.Event.touchUpInside)
        view.addSubview(logOutButton)
        
    }
    
    @objc func logOutClick(){
        
    }

}
