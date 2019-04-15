//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Colin Smith on 4/9/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let post = post else {return}
        
        postImageView.image = post.photo
        captionTextLabel.text = post.caption
        commentCountLabel.text = "Comments: \(post.comments.count)"
    }
}
