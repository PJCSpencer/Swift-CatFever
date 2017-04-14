//
//  sdmCatTableViewCell.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class CatTableViewCell: UITableViewCell
{
    // MARK: - Property(s)
    
    private(set) lazy var backgroundImageView: CustomImageView =
    { [unowned self] in
        
        let anObject = CustomImageView(frame: CGRect.zero)
        self.contentView.addSubview(anObject)
        
        anObject.clipsToBounds = true
        anObject.contentMode = .scaleAspectFill
        anObject.layer.cornerRadius = 6.0
        
        return anObject
    }()
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Laying out Subviews (UIView)
    
    override func layoutSubviews() {
        
        // Super.
        super.layoutSubviews()
        
        // Modify geometry.
        let inset: CGFloat = 4.0
        self.backgroundImageView.frame = self.contentView.bounds.insetBy(dx: inset, dy: inset)
    }
}


