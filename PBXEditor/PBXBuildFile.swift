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
    private let codeSign_on_copy_key = "CodeSignOnCopy"
    private let remove_headers_on_copy = "RemoveHeadersOnCopy"
    
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
        self.setAttributesSettings { (attributes) -> () in
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
        self.setAttributesSettings { (attributes) -> () in
            if !attributes.contains(codeSign_on_copy_key){
                attributes.append(codeSign_on_copy_key)
            }
            if !attributes.contains(remove_headers_on_copy){
                attributes.append(remove_headers_on_copy)
            }
        }
    }
    
    public func addCompilerFlag(flag:String) -> () {
        self.settingDataDictinaryItem(settings_key, dicItemKey: attributes_key, dicItemInitOperation: { (fls) -> Any in
            var flags:String = ""
            if let flagsStr = fls as? String{
                flags = flagsStr
            }
            return flags
            }) { (flags) -> () in
                var fls = flags as! String
                let flagsComponent = fls.componentsSeparatedByString(" ")
                if !flagsComponent.contains(flag){
                    fls = fls + " " + flag
                }
//                flags = fls
        }
    }
    
    private func setAttributesSettings(@noescape operation: inout [String] -> ()) -> (){
        
        self.settingDataDictinaryItem(settings_key, dicItemKey: attributes_key, dicItemInitOperation: { (attrs) -> Any in
            var attributes:[String] = []
            if let list = attrs as? [String]{
                attributes = list
            }
            return attributes
            }) { (attributes) -> () in
                var attrs = attributes as! [String]
                operation(&attrs)
//                attributes = attrs
        }
    }
}
