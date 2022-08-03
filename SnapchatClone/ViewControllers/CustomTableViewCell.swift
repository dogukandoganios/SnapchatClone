//
//  CustomTableViewCell.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 3.08.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var userImage = UIImageView()
    var userName = UILabel()
    
    
    lazy var backView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        addSubview(backView)
        addSubview(userImage)
        addSubview(userName)
    }

}
