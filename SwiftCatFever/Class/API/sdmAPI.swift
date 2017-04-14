//
//  sdmAPI.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 11/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class API
{
    // MARK: - Constant(s)
    
    static var apiPath: String = "http://thecatapi.com"
    
    static var imagesPath: String = "/api/images/get"
    
    static var catParams: String = "?format=xml&size=med&type=jpg"
    
    
    // MARK: - Process
    
    static func getCats(count: Int,
                        callback: @escaping ([Cat]) -> Void)
    {
        let params: String = API.catParams + "&results_per_page=\(count)"
        
        guard let url = URL(string: "\(API.apiPath)\(API.imagesPath)\(params)") else
        {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        _ = ModelAccess.shared.requestData(request: URLRequest(url: url)) { (data, error) in
            
            DispatchQueue.main.async {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            guard error == nil,
                let data = data else
            {
                callback([])
                return
            }
            
            let xmlParse: XMLParse = XMLParse()
            guard let objects = try? xmlParse.elements(xml: data) else
            {
                callback([])
                return
            }
            
            var results: [Cat] = [Cat]()
            for item in objects // TODO:Discover optimsed solution ...
            {
                if let str = item[ModelAccess.Key.url] as? String
                {
                    results.append(Cat(url: str))
                }
            }
            
            callback(results)
        }
    }
}


