//
//  Comment.swift
//  Continuum
//
//  Created by Colin Smith on 4/9/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit


class Comment: SearchableRecord {
    
    var text: String
    let timestamp: Date
    let recordID: CKRecord.ID
    
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.text = text
        self.timestamp = timestamp
        self.post = post
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord){
        guard let post = ckRecord[CommentConstants.postKey] as? Post,
            let text = ckRecord[CommentConstants.textKey] as? String,
            let timestamp = ckRecord[CommentConstants.timestampKey] as? Date else {return nil}
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
    }
    
    func matches(searchTerm: String) -> Bool {
        if self.text.contains(searchTerm){
            return true
        }else{
            return false
        }
    }
}

extension CKRecord {
    convenience init?(comment: Comment) {
        self.init(recordType: CommentConstants.typeKey, recordID: comment.recordID)
        self.setValue(comment.post, forKey: CommentConstants.postKey)
        self.setValue(comment.text , forKey: CommentConstants.textKey)
        self.setValue(comment.timestamp , forKey: CommentConstants.timestampKey)
    }
}

struct CommentConstants {
    static let typeKey = "Comment"
    static let postKey = "Post"
    static let textKey = "text"
    static let timestampKey = "timestamp"
}


