//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Samuel L. Jackson on 4/9/19.
//  Copyright © 1996 PulpFiction Studios. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord] = []
    var isSearching: Bool = false
    
    var dataSource: [SearchableRecord] {
        if isSearching == true{
            return resultsArray
        }else{
            return PostController.shared.posts
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        PostController.shared.fetchAllPosts { (posts) in
            guard let posts = posts else {return}
            PostController.shared.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        guard let post = dataSource[indexPath.row] as? Post else {return UITableViewCell()}
        cell.post = post
        return cell
    }
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        resignFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView"{
            if let destinationVC = segue.destination as? PostDetailTableViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row {
                let selection = PostController.shared.posts[selectedRow]
                destinationVC.post = selection
            }
        }
    }
}

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = dataSource.filter({ (post) -> Bool in
            self.isSearching = true
            return post.matches(searchTerm: searchText)
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { self.isSearching = true }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { self.isSearching = false ; tableView.reloadData() }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
        self.isSearching = false
    }
}
