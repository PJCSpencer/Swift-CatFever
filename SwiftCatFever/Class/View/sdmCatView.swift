//
//  sdmCatView.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class CatView: UIView
{
    // MARK: - Lazy Property(s)
    
    private(set) lazy var tableView: UITableView =
    { [unowned self] in
        
        let anObject = UITableView(frame: CGRect.zero)
        self.addSubview(anObject)
        
        anObject.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        anObject.separatorStyle = .none
        anObject.showsVerticalScrollIndicator = false
        anObject.rowHeight = 70.0
        
        return anObject
    }()
    
    
    // MARK: - Laying out Subviews (UIView)
    
    override func layoutSubviews() {
        
        // Super.
        super.layoutSubviews()
        
        // Modify geometry.
        self.tableView.frame = self.bounds
    }
}


