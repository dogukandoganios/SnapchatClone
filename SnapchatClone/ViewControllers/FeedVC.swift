//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 2.08.2022.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var feedTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedTableView.frame = CGRect(x: width * 0.5 - width * 0.9 / 2, y: height * 0.5 - height * 0.9 / 2, width: width * 0.9, height: height * 0.9)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        return cell
        
    }
    
}
