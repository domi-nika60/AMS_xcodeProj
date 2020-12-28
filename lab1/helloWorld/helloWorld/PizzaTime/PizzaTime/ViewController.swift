//
//  ViewController.swift
//  PizzaTime
//
//  Created by Furgala, Dominika on 4/12/2020.
//  Copyright © 2020 Furgala, Dominika. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import PullToRefreshKit

class ViewController: UIViewController {
    
    var imageURL: String = ""
    @IBOutlet var imageView : UIImageView!
    @IBOutlet weak var PizzaImage: UIImageView!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var PizzaTable: UITableView!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl2 = UIRefreshControl()
//        refreshControl2.tintColor = .white
        refreshControl2.addTarget(self, action: #selector(requestData), for: .valueChanged)

        
        return refreshControl2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PizzaTable.refreshControl = refresher
        
        Alamofire.request("https://foodish-api.herokuapp.com/api/images/pizza").responseJSON { (responseData) in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                self.imageURL = json["image"].stringValue
                print("My url: ", self.imageURL, self.imageURL.description)

            }
            print("Begin of code")
            let url = URL(string: self.imageURL)!
            self.downloadImage(from: url)
        }
}
    
    @objc
    func requestData() {
        print("requesting")
        Alamofire.request("https://foodish-api.herokuapp.com/api/images/pizza").responseJSON { (responseData) in
            if((responseData.result.value) != nil) {
                let json = JSON(responseData.result.value!)
                self.imageURL = json["image"].stringValue
                print("My url: ", self.imageURL, self.imageURL.description)
                
            }
            print("Begin of code")
            let url = URL(string: self.imageURL)!
            self.downloadImage(from: url)
        }
        
            let deadline = DispatchTime.now() + .microseconds(1500)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            self.refresher.endRefreshing()
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in self?.PizzaImage.image = UIImage(data: data)
            }
        }
    }

}

