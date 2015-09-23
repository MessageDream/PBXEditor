//
//  PBXBuildPhase.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXBuildPhase:PBXObject{
    
    internal let fileKey = "files"
    
    public var files:[String]{
        if !self.containsKey(fileKey){
            self.add(fileKey, obj:[String]())
        }
        return  self.data[fileKey] as! [String]
    }
    
    public required init() {
        super.init()
    }
    
//    public func addBuildFile(
    
}