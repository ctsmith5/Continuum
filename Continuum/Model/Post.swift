//
//  Post.swift
//  Continuum
//
//  Created by Colin Smith on 4/9/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    
    var photoData: Data?
    var recordID: CKRecord.ID
    var timestamp: Date
    var caption: String
    var comments: [Comment]
    var commentCount: Int
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            }
            catch let error { print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }

    
    
    init(timestamp: Date = Date(), caption: String, comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), photo: UIImage, commentCount: Int = 0){
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.commentCount = commentCount
        self.recordID = recordID
        self.photo = photo
    }
   
    init?(ckRecord: CKRecord){
        do{
        guard let caption = ckRecord[PostConstants.captionKey] as? String,
            let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
            let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset,
            let commentsCount = ckRecord[PostConstants.countKey] as? Int else {return nil}
        
            let photoData = try Data(contentsOf: photoAsset.fileURL)
            
        self.photoData = photoData
        self.caption = caption
        self.timestamp = timestamp
        self.commentCount = commentsCount
        self.comments = []
        self.recordID = ckRecord.recordID
        }catch{
            print("Nothing is ok")
        return nil
    }
}
}

extension CKRecord {
    convenience init?(post: Post) {
        self.init(recordType: PostConstants.typeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.timestamp, forKey: PostConstants.timestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoKey)
    }
}

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timestampKey = "timestamp"
    static let commentsKey = "comments"
    static let countKey = "commentCount"
    static let photoKey = "photo"
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if self.caption.contains(searchTerm) {
            return true
        }else{
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    }
    
}
