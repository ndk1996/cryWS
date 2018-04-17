//
//  CoinDetailController.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/4/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit
import SciChart

class CoinDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var sciChartSurface: SCIChartSurface?
    var dates = [Date]()
    var yValues = Array<Double>()
    let API_POST_FAVORITES = "https://cryws.herokuapp.com/api/accounts/favorites/"
    let API_DELETE_FAVORITES = "https://cryws.herokuapp.com/api/accounts/favorites/"
    
    var user: User?{
        didSet{
            var flag = false
            for favorite in (user?.favorites)!{
                if(favorite == coinChart?.symbol!){
                    print("favorites: \(favorite)")
                    flag = true
                    break
                }
            }
            if(flag == true){
                print("TRuE")
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(handleRemoveFromFavorites))
            }else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddToFavorites))
            }
        }
    }
    
    var token:String?{
        didSet{
            print("Token coindetail: \(String(describing: token))")
            
        }
    }
    
    @objc func handleAddToFavorites(){
        print("add to favorites")
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["favorites": [coinChart?.symbol]] //as! [String: String]
        
        //create the url with NSURL
        let url = NSURL(string: API_POST_FAVORITES)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token!, forHTTPHeaderField: "Authorization")
        
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
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                        if let success = json["success"] as? Int{
                            if success == 1 {
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(self.handleRemoveFromFavorites))

                                let dashBoardController = self.navigationController!.viewControllers.first as! DashBoardController
                                dashBoardController.fetchUserDataFromAPI(token: self.token!)
                            }else{
                                Alert.showAlert(inViewController: self, title: "Error", message: "Cant add coin to favorites")
                            }
                        }
                    }
                    
                } catch let error {
                    
                    print(error.localizedDescription)
               }
            }
        })
        task.resume()
    
    }
    
    @objc func handleRemoveFromFavorites(){
        print("Remove From Favorites")

        //create the url with NSURL
        let url = NSURL(string: API_DELETE_FAVORITES + (coinChart?.symbol)!)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "DELETE" //set http method as DELETE
        
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token!, forHTTPHeaderField: "Authorization")
        
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
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                        if let success = json["success"] as? Int{
                            if success == 1 {
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.handleRemoveFromFavorites))
                                
                                let dashBoardController = self.navigationController!.viewControllers.first as! DashBoardController
                                dashBoardController.fetchUserDataFromAPI(token: self.token!)
                                if dashBoardController.allFavorSegmentedControl.selectedSegmentIndex == 1{
                                    dashBoardController.allFavorSegmentedControl.selectedSegmentIndex = 0
                                    dashBoardController.reloadAllSegment()
                                }
                            }else{
                                Alert.showAlert(inViewController: self, title: "Error", message: "Cant remove coin from favorites")
                            }
                        }
                    }
                    
                } catch let error {
                    
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    

    var coinChart :CoinChart?{
        didSet{
            
            setupNavBarWithUser(coinChart: coinChart!)
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev7?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev6?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev5?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev4?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev3?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev2?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev1?.timeStamp)!)))
            self.dates.append(Date(timeIntervalSince1970: Double((self.coinChart?.max7days_values?.prev0?.timeStamp)!)))

            self.yValues.append(Double((self.coinChart?.max7days_values?.prev7?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev6?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev5?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev4?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev3?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev2?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev1?.price)!))
            self.yValues.append(Double((self.coinChart?.max7days_values?.prev0?.price)!))

        }
    }
    
    func setupNavBarWithUser(coinChart: CoinChart){

        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.titleView = titleView
        
        //titleView constrains
        titleView.centerYAnchor.constraint(equalTo: (navigationItem.titleView?.centerYAnchor)!).isActive = true
        titleView.centerXAnchor.constraint(equalTo: (navigationItem.titleView?.centerXAnchor)!).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleView.heightAnchor.constraint(equalTo: (navigationItem.titleView?.heightAnchor)!).isActive = true
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let coinImageView = UIImageView()
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.layer.cornerRadius = 16
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .scaleAspectFill
        
        if let symbol = coinChart.symbol{
            let urlString = "https://cryws.herokuapp.com/res/coins_high/128/icon/"+symbol+".png"
            coinImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        containerView.addSubview(coinImageView)
        
        //profileImageView constrains
        coinImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        coinImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = coinChart.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.white
        containerView.addSubview(nameLabel)
        
        let symbolLabel = UILabel()
        symbolLabel.text = coinChart.symbol
        symbolLabel.font = UIFont.boldSystemFont(ofSize: 16)
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.textColor = UIColor.white
        containerView.addSubview(symbolLabel)
        
        //symbolLabel constraints
        symbolLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 8).isActive = true
        symbolLabel.centerYAnchor.constraint(equalTo: coinImageView.centerYAnchor).isActive = true
        symbolLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        symbolLabel.heightAnchor.constraint(equalTo: coinImageView.heightAnchor).isActive = true
        
        //Name Label constraints
        nameLabel.leftAnchor.constraint(equalTo: coinImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: coinImageView.centerYAnchor).isActive = true
        //nameLabel.rightAnchor.constraint(equalTo: symbolLabel.leftAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: coinImageView.heightAnchor).isActive = true
        
        //containerView constraints
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
      
        setUpViewComponent()
    }
 
    private func setUpViewComponent(){
        //MAIN VIEW
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
  
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        //MARK: CHARTVIEW
        
        let chartView = SCSMountainChartView() 
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.dates = self.dates
        chartView.yValues = self.yValues
        chartView.completeConfiguration()
        
        containerView.addSubview(chartView)
        
        chartView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        chartView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        chartView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4).isActive = true
        
        
        //MARK: BOTTON VIEW
        let bottonView = UIView()
        bottonView.backgroundColor = UIColor.black
        bottonView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(bottonView)
        
        bottonView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottonView.topAnchor.constraint(equalTo: chartView.bottomAnchor).isActive = true
        bottonView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        bottonView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        
        
        //MARK: HEAD LABEL
        let headLabel = UILabel()
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        headLabel.tintColor = UIColor.lightGray
        headLabel.layer.borderWidth = 1
        headLabel.layer.borderColor = headLabel.tintColor.cgColor
        headLabel.layer.cornerRadius = 13
        headLabel.clipsToBounds = true
        headLabel.text = "Coin Information"
        headLabel.textColor = UIColor.orange
        headLabel.textAlignment = .center
        headLabel.font = UIFont.systemFont(ofSize: 22)
        
        
        bottonView.addSubview(headLabel)
        
        headLabel.centerXAnchor.constraint(equalTo: bottonView.centerXAnchor).isActive = true
        headLabel.topAnchor.constraint(equalTo: bottonView.topAnchor, constant: 8).isActive = true
        headLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 44 ).isActive = true
        
        // MARK: PRICE
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = "Price:"
        priceLabel.textColor = UIColor.lightGray
        priceLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.textAlignment = .left
        bottonView.addSubview(priceLabel)
        
        priceLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        priceLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let rateLabel = UILabel()
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        rateLabel.textAlignment = .right
        bottonView.addSubview(rateLabel)
        
        rateLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        rateLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        rateLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        rateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let priceCoin = UILabel()
        priceCoin.translatesAutoresizingMaskIntoConstraints = false
        priceCoin.text = "$" + (coinChart?.max7days_values?.prev0?.price?.toString())!
        priceCoin.textColor = UIColor.white
        priceCoin.font = UIFont.systemFont(ofSize: 20)
        priceCoin.textAlignment = .right
        bottonView.addSubview(priceCoin)
        
        priceCoin.rightAnchor.constraint(equalTo: rateLabel.leftAnchor).isActive = true
        priceCoin.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        priceCoin.widthAnchor.constraint(equalToConstant: 120).isActive = true
        priceCoin.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE PRICE
        let seperatePriceView = UIView()
        seperatePriceView.translatesAutoresizingMaskIntoConstraints = false
        seperatePriceView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperatePriceView)
        
        seperatePriceView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperatePriceView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        seperatePriceView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperatePriceView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // MARK: MARKETCAP
        let marketLabel = UILabel()
        marketLabel.translatesAutoresizingMaskIntoConstraints = false
        marketLabel.text = "Market Cap:"
        marketLabel.textColor = UIColor.lightGray
        marketLabel.font = UIFont.systemFont(ofSize: 20)
        marketLabel.textAlignment = .left
        bottonView.addSubview(marketLabel)
        
        marketLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        marketLabel.topAnchor.constraint(equalTo: seperatePriceView.bottomAnchor, constant: 8).isActive = true
        marketLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        marketLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let marketValueLabel = UILabel()
        marketValueLabel.translatesAutoresizingMaskIntoConstraints = false
        marketValueLabel.text = "$" + (coinChart?.max7days_values?.prev0?.marketcap?.withCommas())!
        marketValueLabel.textColor = UIColor.yellow
        marketValueLabel.font = UIFont.systemFont(ofSize: 20)
        marketValueLabel.textAlignment = .right
        bottonView.addSubview(marketValueLabel)
        
        marketValueLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        marketValueLabel.topAnchor.constraint(equalTo: seperatePriceView.bottomAnchor, constant: 8).isActive = true
        marketValueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        marketValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE MARKET
        let seperateMarketView = UIView()
        seperateMarketView.translatesAutoresizingMaskIntoConstraints = false
        seperateMarketView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperateMarketView)
        
        seperateMarketView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperateMarketView.topAnchor.constraint(equalTo: marketLabel.bottomAnchor).isActive = true
        seperateMarketView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperateMarketView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // MARK: VOLUME24h
        let volumeLabel = UILabel()
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false
        volumeLabel.text = "Volume 24h:"
        volumeLabel.textColor = UIColor.lightGray
        volumeLabel.font = UIFont.systemFont(ofSize: 20)
        volumeLabel.textAlignment = .left
        bottonView.addSubview(volumeLabel)
        
        volumeLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        volumeLabel.topAnchor.constraint(equalTo: seperateMarketView.bottomAnchor, constant: 8).isActive = true
        volumeLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        volumeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let volumeValueLabel = UILabel()
        volumeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        volumeValueLabel.text = "$" + (coinChart?.max7days_values?.prev0?.volume24)!
        volumeValueLabel.textColor = UIColor.brown
        volumeValueLabel.font = UIFont.systemFont(ofSize: 20)
        volumeValueLabel.textAlignment = .right
        bottonView.addSubview(volumeValueLabel)
        
        volumeValueLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        volumeValueLabel.topAnchor.constraint(equalTo: seperateMarketView.bottomAnchor, constant: 8).isActive = true
        volumeValueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        volumeValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE VOLUME
        let seperateVolumeView = UIView()
        seperateVolumeView.translatesAutoresizingMaskIntoConstraints = false
        seperateVolumeView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperateVolumeView)
        
        seperateVolumeView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperateVolumeView.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor).isActive = true
        seperateVolumeView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperateVolumeView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // MARK: SUPPLY
        let supplyLabel = UILabel()
        supplyLabel.translatesAutoresizingMaskIntoConstraints = false
        supplyLabel.text = "Available Supply:"
        supplyLabel.textColor = UIColor.lightGray
        supplyLabel.font = UIFont.systemFont(ofSize: 20)
        supplyLabel.textAlignment = .left
        bottonView.addSubview(supplyLabel)
        
        supplyLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        supplyLabel.topAnchor.constraint(equalTo: seperateVolumeView.bottomAnchor, constant: 8).isActive = true
        supplyLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        supplyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let supplyValueLabel = UILabel()
        supplyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        supplyValueLabel.text = (coinChart?.available_supply)!
        supplyValueLabel.textColor = UIColor.cyan
        supplyValueLabel.font = UIFont.systemFont(ofSize: 20)
        supplyValueLabel.textAlignment = .right
        bottonView.addSubview(supplyValueLabel)
        
        supplyValueLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        supplyValueLabel.topAnchor.constraint(equalTo: seperateVolumeView.bottomAnchor, constant: 8).isActive = true
        supplyValueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        supplyValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE SUPPY
        let seperateSupplyView = UIView()
        seperateSupplyView.translatesAutoresizingMaskIntoConstraints = false
        seperateSupplyView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperateSupplyView)
        
        seperateSupplyView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperateSupplyView.topAnchor.constraint(equalTo: supplyLabel.bottomAnchor).isActive = true
        seperateSupplyView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperateSupplyView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // MARK: CHANGE1H
        let change1hLabel = UILabel()
        change1hLabel.translatesAutoresizingMaskIntoConstraints = false
        change1hLabel.text = "Rate Change 1h:"
        change1hLabel.textColor = UIColor.lightGray
        change1hLabel.font = UIFont.systemFont(ofSize: 20)
        change1hLabel.textAlignment = .left
        bottonView.addSubview(change1hLabel)
        
        change1hLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        change1hLabel.topAnchor.constraint(equalTo: seperateSupplyView.bottomAnchor, constant: 8).isActive = true
        change1hLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        change1hLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let change1hValueLabel = UILabel()
        change1hValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let rate1h = coinChart?.max7days_values?.prev0?.change_1h{
            if rate1h.hasPrefix("-"){
                change1hValueLabel.textColor = UIColor.red
            }else{
                change1hValueLabel.textColor = UIColor.green
            }
            change1hValueLabel.text = rate1h + "%"
        }
        change1hValueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        change1hValueLabel.textAlignment = .right
        bottonView.addSubview(change1hValueLabel)
        
        change1hValueLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        change1hValueLabel.topAnchor.constraint(equalTo: seperateSupplyView.bottomAnchor, constant: 8).isActive = true
        change1hValueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        change1hValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE SUPPY
        let seperate1hView = UIView()
        seperate1hView.translatesAutoresizingMaskIntoConstraints = false
        seperate1hView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperate1hView)
        
        seperate1hView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperate1hView.topAnchor.constraint(equalTo: change1hLabel.bottomAnchor).isActive = true
        seperate1hView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperate1hView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // MARK: CHANGE24H
        let change24hLabel = UILabel()
        change24hLabel.translatesAutoresizingMaskIntoConstraints = false
        change24hLabel.text = "Rate Change 1d:"
        change24hLabel.textColor = UIColor.lightGray
        change24hLabel.font = UIFont.systemFont(ofSize: 20)
        change24hLabel.textAlignment = .left
        bottonView.addSubview(change24hLabel)
        
        change24hLabel.leftAnchor.constraint(equalTo: bottonView.leftAnchor, constant: 8).isActive = true
        change24hLabel.topAnchor.constraint(equalTo: seperate1hView.bottomAnchor, constant: 8).isActive = true
        change24hLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        change24hLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //
        let change24hValueLabel = UILabel()
        change24hValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let rate24h = coinChart?.max7days_values?.prev0?.change_24h{
            rateLabel.text = "(" + rate24h + "%)"
            if rate24h.hasPrefix("-"){
                rateLabel.textColor = UIColor.red
                change24hValueLabel.textColor = UIColor.red
            }else{
                rateLabel.textColor = UIColor.green
                change24hValueLabel.textColor = UIColor.green
            }
        }
        change24hValueLabel.text = (coinChart?.max7days_values?.prev0?.change_24h)! + "%"
        change24hValueLabel.font = UIFont.boldSystemFont(ofSize: 20)
        change24hValueLabel.textAlignment = .right
        bottonView.addSubview(change24hValueLabel)
        
        change24hValueLabel.rightAnchor.constraint(equalTo: bottonView.rightAnchor, constant: -8).isActive = true
        change24hValueLabel.topAnchor.constraint(equalTo: seperate1hView.bottomAnchor, constant: 8).isActive = true
        change24hValueLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        change24hValueLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //MARK: SEPERATE SUPPY
        let seperate24hView = UIView()
        seperate24hView.translatesAutoresizingMaskIntoConstraints = false
        seperate24hView.backgroundColor = UIColor.lightGray
        
        bottonView.addSubview(seperate24hView)
        
        seperate24hView.rightAnchor.constraint(equalTo: bottonView.rightAnchor).isActive = true
        seperate24hView.topAnchor.constraint(equalTo: change24hLabel.bottomAnchor).isActive = true
        seperate24hView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        seperate24hView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
