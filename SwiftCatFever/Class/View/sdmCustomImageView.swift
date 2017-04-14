//
//  sdmCustomImageView.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 11/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import UIKit


class CustomImageView: UIImageView
{
    // MARK: - Property Observer(s)
    
    var receipt: URLSessionReceipt?
    {
        didSet
        {
            guard let oldReceipt = oldValue else
            {
                return
            }
            
            ModelAccess.shared.remove(receipt: oldReceipt)
        }
    }
    
    
    // MARK: - Laying out Subviews (UIView)
    
    func setImage(with request: URLRequest, placeholder: UIImage?)
    {
        if let cached: CachedURLResponse = ModelAccess.shared.sessionConfiguration.urlCache?.cachedResponse(for: request)
        {
            /* NB:Not neccessary to call DispatchQueue here but 
             it improves a slight micro stutter. */
            DispatchQueue.main.async {
                
                self.receipt = nil
                self.image = UIImage(data: cached.data)
            }
            return
        }
        
        self.image = placeholder
        
        if let receipt = self.receipt
        {
            if ModelAccess.shared.active(request, receipt: receipt)
            {
                return
            }
            
            self.receipt = nil
        }
        
        // Yippee, a new image.
        self.receipt = ModelAccess.shared.requestData(request: request)
        { [unowned self] (data, error) in
            
            guard error == nil,
                let data = data else
            {
                DispatchQueue.main.async {
                    
                    self.receipt = nil
                }
                return
            }
            
            DispatchQueue.main.async {
                
                self.receipt = nil
                self.image = UIImage(data: data)
            }
        }
    }
}


