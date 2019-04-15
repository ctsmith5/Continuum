//
//  PostController.swift
//  Continuum
//
//  Created by Colin Smith on 4/9/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {
    
    //Singleton
    static let shared = PostController()
    
    //Source of Truth for Posts
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //AddComment to post function
    func addComment(text: String, post: Post?, completion: @escaping (Comment?) -> Void){
        guard let post = post else {return}
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
        guard let record = CKRecord(post: post) else {return}
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription)\(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return }
            let comment = Comment(ckRecord: record)
            guard let unwrappedComment = comment else {return}
            completion(unwrappedComment)
        }
    }
    //create Post with function needs to take in an image and a caption
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void){
        let newPost = Post(caption: caption, photo: image)
        self.posts.append(newPost)
        guard let newRecord = CKRecord(post: newPost) else {return}
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let record = record else {return}
            let post = Post(ckRecord: record)
            guard let unwrappedPost = post else {completion(nil) ; return}
            completion(unwrappedPost)
        }
    }
    
    //Fetch the posts from iCloud
    func fetchAllPosts(completion: @escaping ([Post]?) -> Void ) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let records = records else {return}
            let returnedPosts: [Post] = records.compactMap{Post(ckRecord: $0)}
            self.posts = returnedPosts
            completion(returnedPosts)
        }
    }
    
    //Fetch Comments per Post
    func fetchComments(for post: Post, completion: @escaping ([Comment]?)-> Void){
        let postRefence = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.typeKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil) ; return}
            let returnedComments: [Comment] = records.compactMap{ Comment(ckRecord: $0)}
            post.comments.append(contentsOf: returnedComments)
            completion(returnedComments)
        }
        
        
        
    }
}
