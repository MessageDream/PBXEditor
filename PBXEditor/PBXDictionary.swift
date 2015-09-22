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
    init(dictionary:[Key:Value]){
        self.init()
        dictionary.forEach{
            self[$0.0] = $0.1
        }
    }
    public mutating func append(dictionary:[Key:Value]) -> () {
        dictionary.forEach{
            self[$0.0] = $0.1
        }
    }
}

public extension Dictionary where Key:Comparable,Value:PBXObject{
 
}