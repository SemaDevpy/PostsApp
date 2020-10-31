//
//  SecondViewController.swift
//  PostsApp
//
//  Created by Syimyk on 10/31/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController{
    
    var commentManager = CommentManager()
    
    var commntsList = [CommentModel]()
    
    var postID = 0
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        commentManager.delegate = self
        commentManager.fetchComments(by: postID)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK: - UITableViewDataSource
extension SecondViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commntsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.secondVC.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Theme: \(commntsList[indexPath.row].comName)\nby: \(commntsList[indexPath.row].comEmail))"
        cell.detailTextLabel?.text = "\(commntsList[indexPath.row].comBody)"
        return cell
    }
    
    
}
//MARK: - CommentManagerDelegate
extension SecondViewController : CommentManagerDelegate {
    func didUpdateComment(_ commentManager: CommentManager, comment: [CommentModel]) {
        commntsList = comment
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
