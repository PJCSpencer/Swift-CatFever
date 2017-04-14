//
//  sdmDataSourceSection.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class DataSourceSection: NSObject /* Sooo frustrating. */
{
    // MARK: - Constant(s)
    
    static let inheritedHeight: CGFloat = -1.0
    
    struct Placeholder
    {
        static let Untitled: String             = "com.spencers-dm.app.placeholder.untitled"
    }
    
    struct Key
    {
        static let BundleName: String           = "CFBundleName"
        static let UnkownIdentifier: String     = "com.spencers-dm.app.cell.reuse-identifier.unkown"
    }
    
    
    // MARK: - Factory Utility
    
    static func create(with classString: String) -> DataSourceSection?
    {
        let appName = Bundle.main.infoDictionary![DataSourceSection.Key.BundleName] as! String
        
        guard let anyObject: AnyObject.Type = NSClassFromString("\(appName).\(classString)") else
        {
            return nil
        }
        
        guard let classInstance = anyObject as? DataSourceSection.Type else
        {
            return nil
        }
        
        return classInstance.init()
    }
    
    
    // MARK: - Property(s)
    
    final var tag: Int = -1
    
    final var title: String = DataSourceSection.Placeholder.Untitled
    
    final var objects: [Any] = [Any]()
    
    final var reuseIdentifier: String
    {
        guard let theClass = self.cellClass.self else
        {
            return DataSourceSection.Key.UnkownIdentifier
        }
        
        return NSStringFromClass(theClass)
    }
    
    var cellClass: AnyClass?
    {
        return nil
    }
    
    var headerHeight: CGFloat { return 0.0 }
    
    var footerHeight: CGFloat { return 0.0 }
    
    
    // MARK: - Initializer(s)
    
    required override init()
    {
        /* Do nothing. */
    }
    
    convenience init(_ title: String? = nil, objects: [Any])
    {
        self.init()
        
        self.title = title ?? self.title
        self.objects.append(contentsOf: objects)
    }
    
    
    // MARK: - Process
    
    func modify<T>(_ cell: T, withObjectAt index: Int)
    {
        /* Do nothing, subclasses can override. */
    }
    
    func cellHeight(forObjectAt index: Int) -> CGFloat
    {
        return DataSourceSection.inheritedHeight
    }
}


