//
//  APIShowDataViewController.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import UIKit
import Alamofire
import SDWebImage

class APIShowDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var query: String?
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        if let query = query {
            searchGitHubUsers(query: query)
        }
    }
    
    func searchGitHubUsers(query: String) {
        let url = "https://api.github.com/search/users"
        let parameters: [String: Any] = [
            "q": query
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let searchResponse):
                self.items = searchResponse.items
                self.tableView.reloadData()
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
    }
}

// MARK: - TableView Dalegate & Datasource
extension APIShowDataViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let item = items[indexPath.row]
        cell.avtarImageView.sd_setImage(with: URL(string: item.avatarURL), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 173
    }
}
