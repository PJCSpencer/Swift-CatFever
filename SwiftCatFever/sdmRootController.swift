//
//  ViewController.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 09/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class RootController: UIViewController
{
    // MARK: - Property(s)
    
    var dataSource: TableViewDataSource?
    {
        didSet
        {
            if let castedView = self.view as? CatView
            {
                dataSource?.tableView = castedView.tableView
                dataSource?.tableView?.reloadData()
            }
        }
    }
    
    
    // MARK: - Managing the View (UIViewController)
    
    override func viewDidLoad()
    {
        // Super.
        super.viewDidLoad()
        
        API.getCats(count: 100) { [unowned self] (results) in
            
            DispatchQueue.main.async { 
                
                let section: CatDataSourceSection = CatDataSourceSection(objects: results)
                let dataSource: TableViewDataSource = TableViewDataSource(sections: [section])
                
                self.dataSource = dataSource
            }
        }
    }
}


