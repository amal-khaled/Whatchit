//
//  ViewController.swift
//  Whatchit
//
//  Created by Amal Elgalant on 7/3/19.
//  Copyright © 2019 Amal Elgalant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moviesTable: UITableView!{
        didSet {
            
            moviesTable.estimatedRowHeight = 600
            moviesTable.rowHeight = UITableView.automaticDimension
            
        }
    }
    
    var moviesData = [Movie]()
    var page = 1
    var isTheLastPage = false
    let refreshControl = UIRefreshControl()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let moviesss = Movie()
        MovieController.movieController.getMovies(viewController: self, page: "1")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        moviesTable.reloadData()
    }
    
    @objc func refresh(){
        
        page = 1
        MovieController.movieController.getMovies(viewController: self, page: String (page))
        
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return AppDelegate.myMovies.count
        }
        else {
            return moviesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //movieCell
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        var movie = Movie()
        if indexPath.section == 0{
           movie = AppDelegate.myMovies[indexPath.row]
        }
        else if indexPath.section == 1{
            movie = moviesData[indexPath.row]
        }
        cell.date.text = movie.date
        cell.overView.text = movie.overview
        cell.title.text = movie.title
        if indexPath.section == 0{
            cell.poster.image = AppDelegate.myMoviesImages[indexPath.row]
        }
        else if indexPath.section == 1 {
          cell.poster.image = #imageLiteral(resourceName: "no-poster-available")
            let url = URL(string: movie.poster)
            if url != nil {
                do {
                    let data = try Data(contentsOf: url!, options: [])
                    cell.poster.image = UIImage(data: data)
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
            }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My Movies"
        }
        else{
            return "All Movies"
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement =  moviesData.count - 1
        
        if indexPath.row == lastElement {
            if #available(iOS 10.0, *) {
                tableView.refreshControl = refreshControl
            } else {
                tableView.addSubview(refreshControl)
            }
            
            if !isTheLastPage{
                page += 1
                MovieController.movieController.getMovies(viewController: self, page: String (page))
            }
            else{
                self.refreshControl.endRefreshing()
                
                
            }
        }
       
    }
    
    
}
