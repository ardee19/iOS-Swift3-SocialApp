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
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: CustomTextField!
    var imageSelected = false
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {
            (snapshot) in
            
            self.posts = [] // Reset post array for not to show duplicate posts
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? [String : AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            print("RD: TableView reloaded from update refresh")
        })
    }

    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func SignOutTapped(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ROY: Keychain Wrapper removed")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        guard let caption = captionField.text, caption != "" else {
            print("RD: GUARD_ERROR - Caption must have text")
            return
        }
        
        guard let image = imageAdd.image, imageSelected == true else {
            print("RD: GUARD_ERROR - Image must be present")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            // Uploading Images
            DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print("RD: Unable to upload image to Firebase storage - \(error)")
                } else {
                    print("RD: Successfully uploaded images to Firebase")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: [String : Any] = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        resetPostUI()
    }
    
    func resetPostUI() {
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: POST_CELL_ID) as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                print("RD: returning 1")
                return cell
            } else {
                cell.configureCell(post: post)
                print("RD: returning 2")
                return cell
            }
        } else {
            print("RD: returning 3")
            return PostCell()
        }

    }
}

extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("RD: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
