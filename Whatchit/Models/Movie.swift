//
//  Movie.swift
//  Whatchit
//
//  Created by Amal Elgalant on 7/3/19.
//  Copyright © 2019 Amal Elgalant. All rights reserved.
//

import Foundation

class Movie{
     var title: String = ""
     var date: String = ""
     var poster: String = ""
     var overview: String = ""

    
    init(movie dictionary: [String: Any]? ) {
        guard let dictionary = dictionary else { return }
        
        title = dictionary["title"] as! String
        overview = dictionary["overview"] as! String
        date = dictionary["release_date"] as! String
        
        if let image = dictionary["poster_path"] as? String{
            guard let url = URL(string: image)
                else {
                    print("Unable to create URL")
                    return
            }
            poster = url.absoluteString
            

        }
        //poster_path
        
    }
    init(){
        
    }
    
}
