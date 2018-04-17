//
//  ViewController.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

class DashBoardController: UITableViewController,UISearchBarDelegate {
    
    var coinCharts = [CoinChart]()
    var searchCoinCharts = [CoinChart]()
    let API_GET_CHART7DAYS = "https://cryws.herokuapp.com/api/coins/chart7days"
    let API_GET_FAVORITES = "https://cryws.herokuapp.com/api/accounts/favorites/" // return user data from token
    
    let cellId = "CellID"
    let cellHeader = "CellHeader"
  
    var token:String?{
        didSet{
            print("Token dashboard: \(String(describing: token))")
            fetchUserDataFromAPI(token: token!)
        }
    }

    var user: User?{
        didSet{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        }
    }
    
    func fetchUserDataFromAPI(token: String){
        
        let urlFavorites = NSURL(string: API_GET_FAVORITES)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: urlFavorites! as URL)
        request.httpMethod = "GET" //set http method as GET
        
        //HTTP Headers
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let dataStr = String(data: data, encoding: .utf8)
                    print(dataStr!)
                    self.user = try JSONDecoder().decode(User.self, from: data)

                    self.tableView.reloadData()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
   
    var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(CoinCell.self, forCellReuseIdentifier: cellId)
        self.tableView.register(HeaderCell.self, forCellReuseIdentifier: cellHeader)
        
        self.tableView.backgroundColor = UIColor.black
        self.tableView.backgroundView?.backgroundColor = UIColor.black
        self.searchBar.delegate = self
        
        if allFavorSegmentedControl.selectedSegmentIndex == 0{
            refresher.addTarget(self, action: #selector(populateAll), for: .valueChanged)
            tableView.addSubview(refresher)
        }
  
        loadDataFromAPI()
        setupNavigationBar()
        
    }
    @objc func populateAll(){
        loadDataFromAPI()
        refresher.endRefreshing()
    }
    
    @objc func populateFavor(){
        fetchUserDataFromAPI(token: token!)
        refresher.endRefreshing()
    }
    
    let allFavorSegmentedControl : UISegmentedControl = {
       let segmentedControl = UISegmentedControl(items: ["All","Favorites"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = UIBarStyle.blackTranslucent
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search by name"
        searchBar.keyboardAppearance = .dark
        
        return searchBar
    }()
    
    func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon"), style: .plain, target: self, action: #selector(handleSearch))
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        allFavorSegmentedControl.addTarget(self, action: #selector(handleSegmentedValueChange), for: .valueChanged)
        navigationItem.titleView = allFavorSegmentedControl
    }
    
    
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if allFavorSegmentedControl.selectedSegmentIndex == 0{
            guard !searchText.isEmpty else{
                coinCharts = searchCoinCharts
                tableView.reloadData()
                return
            }
            coinCharts = searchCoinCharts.filter({ (coinChart) -> Bool in
                coinChart.name.lowercased().contains(searchText.lowercased())
            })
            
        }else if  allFavorSegmentedControl.selectedSegmentIndex == 1{
            var coinFavorites = [CoinChart]()
            for favorite in (self.user?.favorites)!{
                for coinChart in self.searchCoinCharts{
                    if favorite == coinChart.symbol{
                        coinFavorites.append(coinChart)
                    }
                }
            }
            guard !searchText.isEmpty else{
                self.coinCharts = coinFavorites
                tableView.reloadData()
                return
            }
            coinCharts = coinFavorites.filter({ (coinChart) -> Bool in
                coinChart.name.lowercased().contains(searchText.lowercased())
            })
 
        }
        tableView.reloadData()
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupNavigationBar()
        if allFavorSegmentedControl.selectedSegmentIndex == 0 {
            self.coinCharts = self.searchCoinCharts
        }else if allFavorSegmentedControl.selectedSegmentIndex == 1{
            var coinFavorites = [CoinChart]()
            for favorite in (self.user?.favorites)!{
                for coinChart in self.searchCoinCharts{
                    if favorite == coinChart.symbol{
                        coinFavorites.append(coinChart)
                    }
                }
            }
            self.coinCharts = coinFavorites
        }
        
        tableView.reloadData()
    }
    
    @objc func handleSegmentedValueChange(){
        if allFavorSegmentedControl.selectedSegmentIndex == 0{
            print("all coin segment")
            coinCharts = searchCoinCharts
            refresher.addTarget(self, action: #selector(populateAll), for: .valueChanged)
            tableView.addSubview(refresher)
        }else{
            print("favorites coin segment")
            
            if(user == nil){
                Alert.showAlert(inViewController: self, title: "Notification", message: "You must login first")
                allFavorSegmentedControl.selectedSegmentIndex = 0
            }else{
                refresher.removeFromSuperview()
                fetchUserDataFromAPI(token: token!)
                var coinFavorites = [CoinChart]()
                for favorite in (self.user?.favorites)!{
                    for coinChart in self.searchCoinCharts{
                        if favorite == coinChart.symbol{
                            coinFavorites.append(coinChart)
                        }
                    }
                }
                self.coinCharts = coinFavorites
            }
        }

        tableView.reloadData()
    }
    
    func reloadAllSegment(){
        coinCharts = searchCoinCharts
        self.tableView.reloadData()
    }
    
    @objc func handleLogout(){
        print("Log out")
        let loginController = LoginController()
        loginController.dashboardController = self
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleSearch(){
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
   
        navigationItem.titleView = nil
        navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: searchBar)
        searchBar.becomeFirstResponder();
        searchBar.text = ""
    }
    
    func loadDataFromAPI(){
        
        guard let coinUrl = URL(string: API_GET_CHART7DAYS)
            else{
                return
        }
        
        URLSession.shared.dataTask(with: coinUrl) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data
                    else{
                        print("Cant get data")
                        return
                }
                
                do{
                    self.searchCoinCharts = try JSONDecoder().decode([CoinChart].self, from: data)
                    for i in 0...(self.searchCoinCharts.count - 1) {
                        self.searchCoinCharts[i].index = i+1
                    }
                    self.coinCharts = self.searchCoinCharts
                    self.tableView.reloadData()
                    
                }catch let jsonErr {
                    print("Loi roi: \(jsonErr)")
                }
            }
            
        }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinCharts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CoinCell
        let coinChart = coinCharts[indexPath.row]
        
        cell.coinChart = coinChart
        cell.serialLabel.text = String(coinChart.index!)
        cell.backgroundColor = UIColor.black
        return cell
    }   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCoinDetailController(index: indexPath.row)
        
    }
    
    private func showCoinDetailController(index: Int){

        let coinDetailController = CoinDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        coinDetailController.coinChart = coinCharts[index]
        coinDetailController.token = token
        if self.user != nil {
            coinDetailController.user = user
        }
        navigationController?.pushViewController(coinDetailController, animated: true)
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
  
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: cellHeader) as! HeaderCell
        
        headerCell.serialLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortBySerial)))
        headerCell.nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortByName)))
        headerCell.priceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortByPrice)))
        headerCell.rateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSortByRate)))
        
        headerView.addSubview(headerCell)
        
        headerView.backgroundColor = UIColor.red
        return headerView
    }
    var countSortBySerial = 1
    var countSortByName = 0
    var countSortByRate = 0
    var countSortByPrice = 0
    
    @objc private func handleSortByName(){
        countSortBySerial = 0
        countSortByRate = 0
        countSortByPrice = 0
        if countSortByName % 2 == 0{
            coinCharts.sort(by: {$1.name > $0.name})
        }else{
            coinCharts.reverse()
        }
        countSortByName += 1
        tableView.reloadData()
    }
    
    @objc private func handleSortBySerial(){
        countSortByName = 0
        countSortByRate = 0
        countSortByPrice = 0
        if countSortBySerial % 2 == 0{
            coinCharts.sort(by: {$1.index! > $0.index!})
        }else{
            coinCharts.reverse()
        }
        countSortBySerial += 1
        tableView.reloadData()
    }
    
    @objc private func handleSortByRate(){
        countSortBySerial = 0
        countSortByName = 0
        countSortByPrice = 0
        if countSortByRate % 2 == 0{
            sortByRate()
        }else{
            coinCharts.reverse()
        }
        countSortByRate += 1
        tableView.reloadData()
        
    }
    
    @objc private func handleSortByPrice(){
        countSortBySerial = 0
        countSortByName = 0
        countSortByRate = 0
        if countSortByPrice % 2 == 0{
            sortByPrice()
        }else{
            coinCharts.reverse()
        }
        countSortByPrice += 1
        tableView.reloadData()

    }
    private func sortByRate(){
        coinCharts.sort { (coin1, coin2) -> Bool in
            var flag = false
            if let rate1 = coin1.max7days_values?.prev0?.change_24h!
            {
                if let rate2 = coin2.max7days_values?.prev0?.change_24h!
                {
                    if(rate1.floatValue > rate2.floatValue){
                        flag = true
                    }
                    else{
                        flag = false
                    }
                }
            }
            return flag
        }
    }
    
    private func sortByPrice(){
        coinCharts.sort { (coin1, coin2) -> Bool in
            var flag = false
            if let price1 = coin1.max7days_values?.prev0?.price!
            {
                if let price2 = coin2.max7days_values?.prev0?.price!
                {
                    if(price1 > price2){
                        flag = true
                    }
                    else{
                        flag = false
                    }
                }
            }
            return flag
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    

}
