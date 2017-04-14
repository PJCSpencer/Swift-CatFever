//
//  sdmDataSourceSerialization.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation

enum DataSourceSerializationError: Error
{
    case empty
    case missing(String)
    case read(String)
    case serialize(String)
}


class DataSourceSerialization
{
    // MARK: - DataSource Utility
    
    class func sections(fileAt path: String,
                        itemsFor key: String) throws -> [DataSourceSection]
    {
        var buffer: [DataSourceSection] = [DataSourceSection]()
        
        guard let collection = try? DataSourceSerialization.collect(fileAt: path, itemsFor: key) else
        {
            return buffer
        }
        
        for object in collection
        {
            guard let className = object[DataSource.Key.Class] as? String else
            {
                throw DataSourceSerializationError.missing("Missing a required key value: \(DataSource.Key.Class)")
            }
            
            if let instance = DataSourceSection.create(with: className)
            {
                if let objects = object[DataSource.Key.Objects] as? [Any]
                {
                    instance.objects = objects
                }
                
                buffer.append(instance)
            }
        }
        
        return buffer
    }
    
    
    // MARK: - JSON Utility
    
    class func collect(fileAt path: String,
                       itemsFor key: String) throws -> [AnyObject]
    {
        do
        {
            let file = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: file.data(using: String.Encoding.utf8)!,
                                                            options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                
                if let collection = json[key] as? [AnyObject]
                {
                    return collection
                }
            }
            catch _
            {
                throw DataSourceSerializationError.serialize("Failed to serialise json: \(file)")
            }
        }
        catch
        {
            throw DataSourceSerializationError.read("Failed to instanciate string: \(path)")
        }
        
        return []
    }
}


