//
//  PBXProject.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/25.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXProject:PBXObject{
    private let main_group_key = "mainGroup"
    private let known_regions_key = "knownRegions"
    
    private var clearedLoc = false
    
    public required init() {
        super.init()
    }
    
    public var mainGroupID:String{
        return String(_data[main_group_key])
    }
    
    public var knownRegions:[String]{
        return _data[known_regions_key] as! [String]
    }
    
    public func addRegion(regin:String) -> (){
        guard self.clearedLoc else{
            _data[known_regions_key] = [String]()
            self.clearedLoc = true
            return
        }
        
        var regions = self.knownRegions
        regions.append(regin)
        _data[known_regions_key] = regions
    }
}
