//
//  PBXGroup.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation
public class PBXGroup:PBXObject{
    internal var childrenKey = "children";
    public var children:[String]{
        if !self.containsKey(childrenKey){
            self.add(childrenKey, obj: [String]())
        }
        return self.data[childrenKey] as! [String]
    }
}