//
//  sdmTableViewDataSource.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class TableViewDataSource: DataSource, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Property(s)
    
    var tableView: UITableView?
    {
        didSet
        {
            // Bind.
            tableView?.dataSource = self
            tableView?.delegate = self
            
            // Register cell(s).
            for object in self.allSections()
            {
                if let cellClass = object.cellClass.self
                {
                    tableView?.register(cellClass,
                                       forCellReuseIdentifier: object.reuseIdentifier)
                }
            }
        }
    }
    
    
    // MARK: - UITableViewDataSource Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.allSections().count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        guard let section = self.section(at: section) else
        {
            return 0
        }
        
        return section.objects.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = self.allSections()[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.reuseIdentifier,
                                                 for: indexPath)
        
        section.modify(cell, withObjectAt: indexPath.row)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate Protocol
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let section = self.section(at: indexPath.section) else
        {
            return tableView.rowHeight
        }
        
        let height: CGFloat = section.cellHeight(forObjectAt: indexPath.row)
        
        return height <= DataSourceSection.inheritedHeight ? tableView.rowHeight : height
    }
}


