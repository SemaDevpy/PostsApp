//
//  ViewController.swift
//  PostsApp
//
//  Created by Syimyk on 10/30/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var postManager = PostManager()
    
    var postsList = [PostModel]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        postManager.delegate = self
        table.dataSource = self
        postManager.fetchPosts()
    }
    
    
}

//MARK: - UITableViewDataSource
extension FirstViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.detailTextLabel?.text = postsList[indexPath.row].postBody
        cell.textLabel?.text = postsList[indexPath.row].postTitle
        return cell
    }
    
    
}

//MARK: - PostManagerDelegate

extension FirstViewController : PostManagerDelegate{
    func didUpdatePost(_ postManager: PostManager, post: [PostModel]) {
        postsList = post
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
//MARK: - UITableViewDelegate
extension FirstViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondViewController
        if let indexPath = table.indexPathForSelectedRow{
            destinationVC.postID = postsList[indexPath.row].postId
        }
      }
    
}
