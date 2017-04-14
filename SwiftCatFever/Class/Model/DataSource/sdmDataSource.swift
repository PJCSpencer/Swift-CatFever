//
//  sdmDataSource.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class DataSource: NSObject
{
    // MARK: - Constant(s)
    
    struct Key
    {
        static let Sections: String             = "sections"
        static let Class: String                = "class"
        static let Objects: String              = "objects"
    }
    
    
    // MARK: - Property(s)
    
    final private var sections: [DataSourceSection] = [DataSourceSection]()
    
    
    // MARK: - Initialiser(s)
    
    convenience init(sections: [DataSourceSection])
    {
        self.init()
        
        self.sections.append(contentsOf: sections)
    }
    
    convenience init?(contentsOfJSON path: String) throws
    {
        guard let collection = try? DataSourceSerialization.sections(fileAt: path,
                                                                     itemsFor: DataSource.Key.Sections) else
        {
            return nil
        }
        
        self.init(sections: collection)
    }
    
    
    // MARK: - Accessing Sections
    
    func allSections() -> [DataSourceSection]
    {
        return self.sections
    }
    
    func section(at index: Int) -> DataSourceSection?
    {
        if index >= 0 && index < self.sections.count
        {
            return self.sections[index]
        }
        
        return nil
    }
}


