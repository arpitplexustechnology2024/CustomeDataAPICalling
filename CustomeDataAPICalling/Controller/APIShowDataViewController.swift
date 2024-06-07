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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    
    var query: String?
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        noInternetView.isHidden = true
        if let query = query {
            if isConnectedToInternet() {
                showLoaderAndFetchData(query: query)
                // showAlert(title: "Internet", message: "Internet Connected")
            } else {
                showNoInternetView()
            }
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        if isConnectedToInternet() {
            noInternetView.isHidden = true
            showLoaderAndFetchData(query: query!)
        } else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
        }
    }
    
    func showLoaderAndFetchData(query: String) {
        activityIndicator.startAnimating()
        activityIndicator.style = .large
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.searchGitHubUsers(query: query)
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    func showNoInternetView() {
        noInternetView.isHidden = false
        activityIndicator.stopAnimating()
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
