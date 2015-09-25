//
//  PBXProject.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/25.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXProject:PBXObject{
    private let mainGroupKey = "mainGroup"
    private let knownRegionsKey = "knownRegions"
    
    private var clearedLoc = false
    
    public required init() {
        super.init()
    }
    
    public var mainGroupID:String{
        return String(_data[mainGroupKey])
    }
    
    public var knownRegions:[String]{
        return _data[knownRegionsKey] as! [String]
    }
    
    public func addRegion(regin:String) -> (){
        guard self.clearedLoc else{
            _data[knownRegionsKey] = [String]()
            self.clearedLoc = true
            return
        }
        
        var regions = self.knownRegions
        regions.append(regin)
        _data[knownRegionsKey] = regions
    }
}
