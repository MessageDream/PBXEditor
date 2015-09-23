//
//  PBXBuildFile.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXBuildFile:PBXObject{
    private let fileRefKey = "fileRef"
    private let settingsKey = "settings"
    private let attributesKey = "ATTRIBUTES"
    private let weakValue = "Weak"
    private let compilerFlagsKey = "COMPILER_FLAGS"
    
    public var fileRef:String{
        return String(_data[fileRefKey])
    }
    
    public required init() {
        super.init()
    }
    
    public convenience init(fileRef:PBXFileReference,weak:Bool = false){
        self.init()
        
        self.add(fileRefKey, obj: fileRef.guid)
    }
    
    public func setWeakLink(weak:Bool = false) -> Bool {
        var settings:[String:Any]!
        var attributes:[String]!
        if !self.containsKey(settingsKey){
            if weak {
                attributes = []
                attributes.append(weakValue)
                
                settings = [:]
                settings[attributesKey] = attributes
            }
                return true
        }
        
        return true
    }
}
