//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Colin Smith on 4/9/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextLabel: UILabel!
    
    
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

    }
    
    func updateViews(){
        guard let post = post else {return}
        postImageView.image = post.photo
        captionTextLabel.text = post.caption
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = "\(String(describing: post?.comments[indexPath.row]))"
        
        return cell
    }
    func deliverCommentAlert(){
        let commentTextField = UITextField()
        let addCommentAlert = UIAlertController(title: "Write a comment about this Post.", message: nil, preferredStyle: .alert)
        addCommentAlert.addTextField { (textField) in
            textField.placeholder = "Enter new post..."
            textField.keyboardType = .default
            
        }
        guard let textr = commentTextField.text else {return}
        let discardAction = UIAlertAction(title: "Discard", style: .cancel) { (_) in
            self.resignFirstResponder()
        }
        let postCommentAction = UIAlertAction(title: "Post", style: .default) { (_) in
                PostController.shared.addComment(text: textr, post: self.post, completion: { (newComment) in
                    print("Fill this code in later")
                })
        }
        addCommentAlert.addAction(discardAction)
        addCommentAlert.addAction(postCommentAction)
        present(addCommentAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    @IBAction func followButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        deliverCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   

}
