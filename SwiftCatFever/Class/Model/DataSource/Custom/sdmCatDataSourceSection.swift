//
//  sdmImageDataSourceSection.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class CatDataSourceSection: DataSourceSection
{
    // MARK: - Property Override(s)
    
    override var cellClass: AnyClass?
    {
        return CatTableViewCell.self
    }
    
    
    // MARK: - Method Override(s)
    
    override func modify<T>(_ cell: T, withObjectAt index: Int)
    {
        if let castedCell = cell as? CatTableViewCell
        {
            guard let data = self.objects[index] as? Cat,
                let url: URL = URL(string: data.url) else
            {
                return
            }
            
            castedCell.backgroundImageView.setImage(with: ModelAccess.imageRequest(with: url),
                                                    placeholder: UIImage(named: "Placeholder"))
        }
    }
}


