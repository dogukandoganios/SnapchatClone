//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit

class UploadVC: UIViewController {

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
        
        uploadButton.setTitle("Upload", for: UIControl.State.normal)
        uploadButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        uploadButton.frame = CGRect(x: width * 0.5 - width * 0.16 / 2, y: height * 0.5 - height * 0.05 / 2, width: width * 0.16, height: height * 0.05)
        uploadButton.addTarget(self, action: #selector(uploadClick), for: UIControl.Event.touchUpInside)
        view.addSubview(uploadButton)
        
    }

    @objc func uploadClick(){
        
    }

}
