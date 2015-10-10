//
//  PBXBuildFile.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXBuildFile:PBXObject{
    private let fileRef_key = "fileRef"
    private let settings_key = "settings"
    private let attributes_key = "ATTRIBUTES"
    private let weak_value = "Weak"
    private let compilerFlags_key = "COMPILER_FLAGS"
    
    public var fileRef:String{
        return String(_data[fileRef_key])
    }
    
    public required init() {
        super.init()
    }
    
    public convenience init(fileRef:PBXFileReference,weak:Bool = false){
        self.init()
        self.add(fileRef_key, obj: fileRef.guid)
    }
    
    public func setWeakLink(weak:Bool = false) -> () {
        self.setSettings { (attributes) -> () in
            if weak && !attributes.contains(weak_value){
                attributes.append(weak_value)
            }else{
                if let wv = attributes.indexOf(weak_value){
                    attributes.removeAtIndex(wv)
                }
            }
        }
    }
    
    public func addCodeSignOnCopy() -> () {
        self.setSettings { (attributes) -> () in
            if !attributes.contains("CodeSignOnCopy"){
                attributes.append("CodeSignOnCopy")
            }
            if !attributes.contains("RemoveHeadersOnCopy"){
                attributes.append("RemoveHeadersOnCopy")
            }
        }
    }
    
    public func addCompilerFlag(flag:String) -> () {
        var settings:[String:Any] = [:]
        if let dic = _data[settings_key] as? [String:Any]{
            settings = dic
        }
        var flags:String = ""
        if let flagsStr = settings[attributes_key] as? String{
            flags = flagsStr
        }
        
        let flagsComponent = flags.componentsSeparatedByString(" ")
        if !flagsComponent.contains(flag){
            flags = flags + " " + flag
        }
        
        settings[compilerFlags_key] = flags
        _data[settings_key] = settings
    }
    
    private func setSettings(@noescape operation: inout [String] -> ()) -> (){
        var settings:[String:Any] = [:]
        if let dic = _data[settings_key] as? [String:Any]{
            settings = dic
        }
        var attributes:[String] = []
        if let list = settings[attributes_key] as? [String]{
            attributes = list
        }
        operation(&attributes)
        settings[attributes_key] = attributes
        _data[settings_key] = settings
    }
}
