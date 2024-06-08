//
//  APIShowDataViewController.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 06/06/24.
//

import UIKit
import Alamofire
import SDWebImage

class APIShowDataViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var noInternetView: NoInternetView!
    var noDataView: NoDataView!
    var query: String?
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
         tableView.isHidden = true
        
        
        setupNoInternetView()
        setupNoDataView()
        
                if let query = query {
                    if isConnectedToInternet() {
                        showLoaderAndFetchData(query: query)
                    } else {
                        showNoInternetView()
                    }
                }
            }
    
    
    func setupNoInternetView() {
        noInternetView = NoInternetView()
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noInternetView)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noInternetView.isHidden = true
    }
    
    func setupNoDataView() {
        noDataView = NoDataView()
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        noDataView.isHidden = true
    }
    
        @objc func retryButtonTapped() {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
                    if self.items.isEmpty {
                        self.showNoDataView()
                    } else {
                        self.noDataView.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
            }
        }
    
    func showNoDataView() {
        noDataView.isHidden = false
        tableView.isHidden = true
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
