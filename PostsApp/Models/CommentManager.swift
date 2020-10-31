//
//  CommentManager.swift
//  PostsApp
//
//  Created by Syimyk on 10/31/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import Foundation


protocol CommentManagerDelegate {
    func didUpdateComment(_ commentManager : CommentManager,comment: [CommentModel])
    func didFailWithError(error : Error)
}

struct CommentManager {
    
    let commentURL = "https://jsonplaceholder.typicode.com/comments?postId="
    
    var delegate : CommentManagerDelegate?
    
    func fetchComments(by id : Int){
        let urlString = "\(commentURL)\(id)"
        performRequest(with : urlString)
    }
    
    
    func performRequest(with urlString : String){
        //1.create url
        if let url = URL(string: urlString){
            //2.create a urlSesseion
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let comment = self.parseJSON(safeData){
                        self.delegate?.didUpdateComment(self, comment: comment)
                    }
                }
            }
            //4.start the task
            task.resume()
        }
        
    }
    
    
    
    func parseJSON(_ commentData : Data) -> [CommentModel]?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([CommentData].self, from: commentData)
            var comments =  [CommentModel]()
            var name = ""
            var email = ""
            var body = ""
            var com : CommentModel?
            for item in decodedData.prefix(30){
                name = item.name
                email = item.email
                body = item.body
                com = CommentModel(comName: name, comEmail: email, comBody: body)
                comments.append(com!)
            }
            return comments
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
