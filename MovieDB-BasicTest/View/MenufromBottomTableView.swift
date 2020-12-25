//
//  CustomTableViewCell.swift
//  MovieDB-BasicTest
//
//  Created by Stendy Antonio on 23/12/20.
//

import UIKit

class MenufromBottomTableView: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width-80, height: 30))
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(label)
        // Configure the view for the selected state
    }
    
}
