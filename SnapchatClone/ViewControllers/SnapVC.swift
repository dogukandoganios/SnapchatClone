//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit

class SnapVC: UIViewController {
    
    var timeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        timeLabel.text = "Time Left : "
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: timeLabel.font.fontName, size: 30)
        timeLabel.frame = CGRect(x: width * 0.5 - width * 0.8 / 2, y: height * 0.1 - height * 0.1 / 2, width: width * 0.8, height: height * 0.1)
        view.addSubview(timeLabel)
        
        
    }
    

}
