
//
//  sdmXMLParse.swift
//  SwiftCatFever
//
//  Created by Peter JC Spencer on 10/04/2017.
//  Copyright © 2017 Peter JC Spencer. All rights reserved.
//

import Foundation

enum XMLParseError: Error
{
    case failed
}


class XMLParse: NSObject, XMLParserDelegate
{
    // MARK: - Constant(s)
    
    struct Placeholder
    {
        static let generic: String = "http://placekitten.com/100/70?image=0"
    }
    
    struct Key
    {
        static let url: String = "url"
        static let image: String = "image"
    }
    
    
    // MARK: - Property(S)
    
    private var xmlElement: [String:String]!
    private var xmlValue: String!
    private var xmlResults: [[String:String]]!
    
    private var parser: XMLParser!
    
    
    // MARK: - 
    
    func elements(xml data: Data) throws -> [[String:Any]]
    {
        self.xmlResults = []
        
        self.parser = XMLParser(data: data)
        self.parser.delegate = self
        
        if !self.parser.parse()
        {
            throw XMLParseError.failed
        }
        
        return self.xmlResults
    }
    
    
    // MARK: - XMLParserDelegate Protocol
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        if elementName == XMLParse.Key.image
        {
            self.xmlElement = [XMLParse.Key.url : XMLParse.Placeholder.generic]
        }
        
        if self.xmlElement != nil
        {
            self.xmlValue = self.xmlElement[elementName]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if self.xmlValue != nil
        {
            self.xmlValue = string
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?)
    {
        if self.xmlValue != nil
        {
            self.xmlElement[elementName] = self.xmlValue
        }
        
        if elementName == XMLParse.Key.image
        {
            self.xmlResults.append(self.xmlElement)
        }
    }
}


