//
//  CoinCell.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//


import UIKit

class CoinCell: UITableViewCell{
    
    let API_LOGO_ICON = "https://cryws.herokuapp.com/res/coins_high/128/icon/"
    
    var coinChart: CoinChart? {
        didSet{
            setupCoinContainer()
            
        }
    }
    
    private func setupCoinContainer(){
        if let symbol = coinChart?.symbol{
            let urlString = API_LOGO_ICON + symbol + ".png"
            coinImageView.loadImageUsingCacheWithUrlString(urlString: urlString)
        }
        if let name = coinChart?.name{
            coinNameLabel.text = name
        }
        if let price = coinChart?.max7days_values?.prev0?.price{
            priceLabel.text = "$" + price.toString()
        }else{
            print("\(String(describing: coinNameLabel.text)) cant get price")
        }
        if let rate24h = coinChart?.max7days_values?.prev0?.change_24h{
            rateLabel.text = rate24h + "%"
            if rate24h.hasPrefix("-"){
                rateLabel.textColor = UIColor.red
                priceLabel.textColor = UIColor.red
                priceLabel.tintColor = UIColor.red
                priceLabel.layer.borderColor = priceLabel.tintColor.cgColor
            }else{
                rateLabel.textColor = UIColor.green
                priceLabel.textColor = UIColor.green
                priceLabel.tintColor = UIColor.green
                priceLabel.layer.borderColor = priceLabel.tintColor.cgColor
            }
        }else{
            print("\(String(describing: coinNameLabel.text)) cant get rate")
        }
    }
    

    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
//        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
    }
    
    let coinImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let coinNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        
        return label
    }()
    
    let serialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray
        
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(coinImageView)
        addSubview(coinNameLabel)
        addSubview(serialLabel)
        addSubview(rateLabel)
        addSubview(priceLabel)
        addSubview(seperatorView)
        
        // add constrains x,y,w,h
        coinImageView.leftAnchor.constraint(equalTo: serialLabel.rightAnchor, constant: 8).isActive = true
        coinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coinImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        // coinNameLabel constraints
        coinNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coinNameLabel.leftAnchor.constraint(equalTo: coinImageView.rightAnchor, constant: 8).isActive = true
        coinNameLabel.widthAnchor.constraint(equalToConstant: 136).isActive = true
        coinNameLabel.heightAnchor.constraint(equalTo: (self.textLabel?.heightAnchor)!).isActive = true
    
        //serialLabel constraints
        serialLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        serialLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        serialLabel.widthAnchor.constraint(equalToConstant: 28).isActive = true
        serialLabel.heightAnchor.constraint(equalTo: (self.textLabel?.heightAnchor)!).isActive = true
        
        //rateLabel constraints
        rateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rateLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -16).isActive = true
        rateLabel.widthAnchor.constraint(equalToConstant: 56).isActive = true
        rateLabel.heightAnchor.constraint(equalTo: (self.textLabel?.heightAnchor)!).isActive = true
        
        //priceLabel constraints
        priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 78).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        seperatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        seperatorView.leftAnchor.constraint(equalTo: serialLabel.rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        seperatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("inint has not been implemented")
    }
}

