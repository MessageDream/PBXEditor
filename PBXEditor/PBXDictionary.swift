//
//  PBXDictionary.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/22.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public protocol StringType {
}

extension String:StringType {
    
}


public extension Dictionary where Key:StringType,Value:PBXObject{
    init(dictionary:[Key:Any]){
        self.init()
        dictionary.forEach{
            if let dic = $0.1 as? [String:Any]{
                if let isa = dic["isa"] as? String  where isa == String(Value){
                    if let guid = $0.0 as? String{
                        self[$0.0] =  Value(guid:guid, dictonary:dic)
                    }
                }
            }
        }
    }
}

public extension Dictionary{
    public mutating func append(dictionary:Dictionary) -> () {
        dictionary.forEach{
            self[$0.0] = $0.1
        }
        
    }
}
    