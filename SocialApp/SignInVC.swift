//
//  ViewController.swift
//  SocialApp
//
//  Created by Roy Dimayuga on 11/8/16.
//  Copyright © 2016 Super Awesome. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {
             (result, error) in
            
            if error != nil {
                print("ROY: Unable to Authenticate with facebook - \(error.debugDescription)")
            } else if result?.isCancelled == true {
                print("ROY: User Cancelled Facebook Authentication")
            } else {
                print("ROY Successfully Authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthenticate(credential)
            }
        }
    }
    
    func firebaseAuthenticate(_ credential:FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("ROY: Unable to authenticate with Firebase - \(error)")
            } else {
                print("ROY: Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func SignInButtonTapped(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) {
                (user, error) in
                
                if error == nil {
                    print("ROY: Email User authenticated with Firebase")
                } else {
                    print("ROY: Email User authentication failed - \(error)")
                    FIRAuth.auth()?.createUser(withEmail: email, password: password){ (user, error) in
                        
                        if error != nil {
                            print("ROY: Unable to create user with firebase - \(error)")
                        } else {
                            print("ROY: Successfully created user with firebase")
                        }
                    }
                }
                
            }
        }
    }
    
    

}

