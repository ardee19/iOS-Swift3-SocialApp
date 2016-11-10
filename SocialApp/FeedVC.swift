//
//  FeedVC.swift
//  SocialApp
//
//  Created by Roy Dimayuga on 11/9/16.
//  Copyright © 2016 Super Awesome. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SignOutTapped(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ROY: Keychain Wrapper removed")
        try! FIRAuth.auth()?.signOut()
        
    }
}
