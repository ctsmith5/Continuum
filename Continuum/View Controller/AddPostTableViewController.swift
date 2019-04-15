//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Samuel L. Jackson on 4/9/19.
//  Copyright © 1996 Pulp Fiction Studios. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    //MARK: - ImagePickerDelegate Functions
    func imagePick(){
        let photoAlert = UIAlertController(title: "Select Image to Upload", message: "Choose a photo from Library or take a new one.", preferredStyle: .actionSheet)
        let chooseAction = UIAlertAction(title: "Choose from Library", style: .default) { (choose) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let takeAction = UIAlertAction(title: "Take a Photo", style: .default) { (take) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        photoAlert.addAction(chooseAction)
        photoAlert.addAction(takeAction)
        present(photoAlert, animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        postImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        selectImageButton.setTitle("", for: .normal
        )
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    @IBAction func selectImageButtonPressed(_ sender: UIButton) {
        imagePick()
    }
    
    @IBAction func addPostButtonPressed(_ sender: UIButton) {
        if (titleTextField.text != "") {
           guard let newCaption = titleTextField.text,
            let newPhoto = postImageView.image else { return }
            PostController.shared.createPostWith(image: newPhoto, caption: newCaption) { (post) in
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 0
                    print("should be poppin")
                    self.titleTextField.text = ""
                    self.postImageView.image = nil
                    self.selectImageButton.setTitle("Select Image", for: .normal)
                    
                }
            }
        }
    }
}
