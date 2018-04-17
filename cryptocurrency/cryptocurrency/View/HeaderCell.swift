//
//  HeaderCell.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/12/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    let serialLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "#"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let rateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.text = "24h"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let seperateTopView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray

        
        return view
    }()
    
    let seperateBottonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        self.backgroundColor = UIColor.black
        
        addSubview(seperateTopView)
        addSubview(serialLabel)
        addSubview(nameLabel)
        addSubview(rateLabel)
        addSubview(priceLabel)
        addSubview(seperateBottonView)
        
        //seperateTopView constraints
        seperateTopView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        seperateTopView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        seperateTopView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //seperateBottonView constraints
        seperateBottonView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        seperateBottonView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        seperateBottonView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // seriallabel constraints
        serialLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        serialLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        serialLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        serialLabel.heightAnchor.constraint(equalToConstant: self.frame.height - 2).isActive = true
        
        // nameLabel constraints
        nameLabel.leftAnchor.constraint(equalTo: serialLabel.rightAnchor, constant: 30).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: self.frame.height - 2).isActive = true
        
        // rateLabel constraints
        rateLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -12).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rateLabel.heightAnchor.constraint(equalToConstant: self.frame.height - 2).isActive = true

        // priceLabel constraints
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: self.frame.height - 2).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("inint has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
