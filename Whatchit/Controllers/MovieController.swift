//
//  MovieController.swift
//  Whatchit
//
//  Created by Amal Elgalant on 7/5/19.
//  Copyright © 2019 Amal Elgalant. All rights reserved.
//

import Foundation

class MovieController {
    
    static let movieController = MovieController()
    
    
    func getMovies(viewController: ViewController, page: String){
       print(page)

        guard let url = URL(string: Constants.GET_MOVIES + page) else { return }

print(url)
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {

                    if let totalPages = jsonObj!.value(forKey: "total_pages") as? Int {
                        if page == String(totalPages){
                            viewController.isTheLastPage = true
                        }
                    }
                  
                    if let results = jsonObj!.value(forKey: "results") as? NSArray {
                        if page == "1"{
                            viewController.moviesData.removeAll()
                        }
                        
                        
                        
                        for i in 0..<results.count {
                            let movieDic = results[i] as! NSDictionary
                           
                            
                            viewController.moviesData.append(Movie(movie: movieDic as! [String : Any]))
                            
                        }
                        DispatchQueue.main.async { 
                            viewController.moviesTable.reloadData()
                        viewController.refreshControl.endRefreshing()

                        }
                    }
                }

                
            } else  {
                print("Failed")
            }
        }
        task.resume()
        
//        let dataTask = URLSession.shared.dataTask(with: yourURL) { (data, response, error) in
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                print("json --- \(json)")
//            }catch let err {
//                print("err---\(err.localizedDescription)")
//            }
//        }
//        dataTask.resume()
    }
    
    
    
    
}
