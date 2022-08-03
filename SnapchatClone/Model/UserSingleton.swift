//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Doğukan Doğan on 3.08.2022.
//

import Foundation

class UserSingleton{
    
    static let sharedUserInfo = UserSingleton()
    
    var email = String()
    var username = String()
    
    private init(){
        
    }
    
}
