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
                _data[settingsKey] = settings
            }
            return true
        }
        
        settings = _data[settingsKey] as! [String:Any]
        if !settings.keys.contains(attributesKey){
            if weak {
                attributes = []
                attributes.append(weakValue)
                settings[attributesKey] = attributes
                _data[settingsKey] = settings
                return true
            }
            return false
        }
        
        attributes = settings[attributesKey] as! [String]
        
        if weak {
            attributes.append(weakValue)
        }else{
            attributes.removeAtIndex(attributes.indexOf(weakValue)!)
        }
        
        settings[attributesKey] = attributes
        self.add(settingsKey, obj: settings)
        
        return true
        
    }
    
    public func addCodeSignOnCopy() -> Bool {
        if !self.containsKey(settingsKey){
            _data[settingsKey] = [String:Any]()
        }
        
        var settings = _data[settingsKey] as! [String:Any]
        if !settings.keys.contains(attributesKey){
            var attributes = [String]()
            attributes.append("CodeSignOnCopy")
            attributes.append("RemoveHeadersOnCopy")
            settings[attributesKey] = attributes
        }else{
            var attributes = settings[attributesKey] as! [String]
            attributes.append("CodeSignOnCopy")
            attributes.append("RemoveHeadersOnCopy")
            settings[attributesKey] = attributes
        }
        return true
    }
    
    public func addCompilerFlag(flag:String) -> Bool{
        if !self.containsKey(settingsKey){
            _data[settingsKey] = [String:Any]()
        }
        var  settings = _data[settingsKey] as! [String:Any]
        guard settings.keys.contains(compilerFlagsKey) else{
            settings[compilerFlagsKey] = flag
            _data[settingsKey] = settings
            return true
        }
       var flags = (settings[compilerFlagsKey] as! String).componentsSeparatedByString(" ")
        if  flags.contains(flag){
            return false
        }
        
        flags.append(flag)
        
        settings[compilerFlagsKey] = flags.joinWithSeparator(" ")
        
        _data[settingsKey] = settings
        
        return true
        
    }
}
