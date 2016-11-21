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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func SignOutTapped(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ROY: Keychain Wrapper removed")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return (tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell)!
    }
}
