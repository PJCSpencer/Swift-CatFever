//
//  sdmModelAccess.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 09/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation


enum ModelAccessError: Error
{
    case failed
    case response
    case code
}

struct URLSessionReceipt
{
    let identifier: Int
    let timestamp: Double
    let path: String
}

extension URLSessionReceipt: Hashable
{
    var hashValue: Int
    {
        return self.identifier
    }
    
    static func == (lhs: URLSessionReceipt, rhs: URLSessionReceipt) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}

class ModelAccess: NSObject
{
    // MARK: - Constant(s)
    
    private static let timeoutInterval: TimeInterval = 10.0
    
    private static let diskPath: String = "com.spencers-dm.swiftcatfever.url-cache"
    
    struct Key
    {
        static let url: String = "url"
    }
    
    
    // MARK: - Lazy Property(s)
    
    final private(set) lazy var sessionConfiguration: URLSessionConfiguration =
    { [unowned self] in
        
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.timeoutIntervalForRequest = ModelAccess.timeoutInterval
        anObject.allowsCellularAccess = false
        anObject.urlCache = URLCache(memoryCapacity: ModelAccess.capacity(megabytes: 20),
                                     diskCapacity: ModelAccess.capacity(megabytes: 100),
                                     diskPath: ModelAccess.diskPath )
        
        return anObject
    }()
    
    final private(set) lazy var session: URLSession =
    { [unowned self] in
        
        let anObject: URLSession = URLSession(configuration: self.sessionConfiguration,
                                              delegate: nil,
                                              delegateQueue: nil)
        
        return anObject
    }()
    
    
    // MARK: - Private Property(s)
    
    final private var tasks: [URLSessionReceipt:URLSessionTask] = [:]
    
    
    // MARK: - Initialization
    
    private override init() {}
    
    
    // MARK: - Shared Instance
    
    static let shared = ModelAccess()
    
    
    // MARK: - Requesting Data
    
    func requestData(request: URLRequest,
                     callback: @escaping (Data?, ModelAccessError?) -> Void) -> URLSessionReceipt
    {
        let task: URLSessionDataTask = self.session.dataTask(with: request)
        { [unowned self] (data, response, error) in
            
            guard error == nil else
            {
                if let path = (error as NSError?)?.userInfo[NSURLErrorFailingURLStringErrorKey] as? String
                {
                    self.remove(url: URL(string: path)!)
                }
                
                callback(nil, ModelAccessError.failed)
                return
            }
            
            if let response = response as? HTTPURLResponse
            {
                print("\(self)::\(#function), \(response)")
                
                self.remove(url: response.url!)
                
                if response.statusCode == 200
                {
                    callback(data, nil)
                    return
                }
            }
            
            callback(nil, ModelAccessError.code)
        }
        
        task.resume()
        
        let receipt: URLSessionReceipt = URLSessionReceipt(identifier: task.hashValue,
                                                           timestamp: Date.timeIntervalSinceReferenceDate,
                                                           path: request.url!.absoluteString)
        self.tasks[receipt] = task
        
        return receipt
    }
    
    
    // MARK: - Class Utility

    static func capacity(megabytes: Int) -> Int
    {
        return megabytes * 1024 * 1024
    }
    
    static func imageRequest(with url: URL) -> URLRequest
    {
        var request: URLRequest = URLRequest(url: url)
        request.setValue("Accept", forHTTPHeaderField: "image/*")
        
        return request
    }
    
    
    // MARK: - Management
    
    func active(_ request: URLRequest, receipt: URLSessionReceipt) -> Bool
    {
        guard let task = self.tasks[receipt],
            let absoluteString = request.url?.absoluteString else
        {
            return false
        }
        
        return task.originalRequest?.url?.absoluteString == absoluteString
    }
    
    private func remove(url: URL)
    {
        if let receipt = self.tasks.keys.filter({ $0.path == url.absoluteString }).first
        {
            self.remove(receipt: receipt)
            print("\(self)::\(#function), remaining:\(self.tasks.count)")
        }
    }
    
    func remove(receipt: URLSessionReceipt)
    {
        self.cancel(receipt: receipt)
        self.tasks[receipt] = nil
    }
    
    func cancel(receipt: URLSessionReceipt)
    {
        guard let task = self.tasks[receipt] else
        {
            return
        }
        
        task.cancel()
    }
}


