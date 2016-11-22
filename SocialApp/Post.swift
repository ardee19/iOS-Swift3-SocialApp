//
//  Post.swift
//  SocialApp
//
//  Created by Super Awesome on 11/21/16.
//  Copyright © 2016 Super Awesome. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: [String: AnyObject]) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String,
            let imageUrl = postData["imageUrl"] as? String,
            let likes = postData["likes"] as? Int {
            
            self._caption = caption
            self._imageUrl = imageUrl
            self._likes = likes
        }
    }
    
    
    
}
