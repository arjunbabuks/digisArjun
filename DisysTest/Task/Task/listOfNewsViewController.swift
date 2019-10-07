//
//  listOfNewsViewController.swift
//  Task
//
//  Created by Arjun babu k.s on 10/7/19.
//  Copyright © 2019 Arjun babu k.s. All rights reserved.
//

import UIKit

class listOfNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: IBOutlets and Declraction
    @IBOutlet weak var listOfNewsTableview: UITableView!
    var payloadArr : [Payload]?
    var imgView : UIImageView?
    
    // MARK : TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payloadArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : listOfNewsTableViewCell = (self.listOfNewsTableview.dequeueReusableCell(withIdentifier: "cell") as? listOfNewsTableViewCell)!
        let value : Payload = (payloadArr?[indexPath.row])!
        cell.title.text = value.title
        cell.des.text = value.payloadDescription
        cell.date.text = value.date.rawValue
        downloadImage(from: (NSURL(string: value.image) as URL?)!)
        cell.imageView?.image = self.imgView?.image
        cell.layoutIfNeeded()
        return cell
    }
    
    //MARK : Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        triggerListOfNewsApi()
    }
    
    // MARK : Methods
    
    func triggerListOfNewsApi() {
        let url = URL(string: "https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api/public/v1/news?local=en")!
        
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
        
        var request = URLRequest(url: url)
        request.setValue("mobile_dev", forHTTPHeaderField: "consumer-key")
        request.setValue("20891a1b4504ddc33d42501f9c8d2215fbe85008", forHTTPHeaderField: "consumer-secret")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return}
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let result = try JSONDecoder().decode(ListOfNewsResponse.self, from: data)
                print(result.success)
                if result.success {
                    // navigate to list of news view
                    self.payloadArr = result.payload
                    DispatchQueue.main.async {
                        self.listOfNewsTableview.reloadData()
                    }
                } else {
                    print(error)
                }
            } catch {
            }
        }
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgView?.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

