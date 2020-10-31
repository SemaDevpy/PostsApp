//
//  PostManager.swift
//  PostsApp
//
//  Created by Syimyk on 10/30/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import Foundation

protocol PostManagerDelegate {
       func didUpdatePost(_ postManager : PostManager,post: [PostModel])
       func didFailWithError(error : Error)
   }

struct PostManager {

    let postURL = "https://jsonplaceholder.typicode.com/posts"
    
    var delegate : PostManagerDelegate?
    
    func fetchPosts(){
        let urlString = postURL
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        //1.create URL
        if let url = URL(string: urlString){
           //2.create URLSession
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let post = self.parseJSON(safeData){
                        self.delegate?.didUpdatePost(self, post: post)
                    }
                }
            }
            //4.start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ postData : Data) -> [PostModel]?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([PostData].self, from: postData)
            var posts =  [PostModel]()
            var id = 0
            var title = ""
            var body = ""
            var post : PostModel?
            for item in decodedData.prefix(30){
                id = item.id
                title = item.title
                body = item.body
                post = PostModel(postId: id, postTitle: title, postBody: body)
                posts.append(post!)
            }
            return posts
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
        
    
}
