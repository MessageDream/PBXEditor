//
//  XCBuildConfiguration.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/25.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class XCBuildConfiguration:PBXObject{
    private let buildSettings_key = "buildSettings";
    private let header_search_paths_key = "HEADER_SEARCH_PATHS";
    private let library_search_paths_key = "LIBRARY_SEARCH_PATHS";
    private let framework_search_paths_key = "FRAMEWORK_SEARCH_PATHS";
    private let other_c_flags_key = "OTHER_CFLAGS";
    private let other_ldflags_key = "OTHER_LDFLAGS";
    
    public var buildSettings:[String:Any]?{
        if self.containsKey(buildSettings_key){
            return _data[buildSettings_key] as? [String:Any]
        }
        return nil
    }
    
    public required init(){
        super.init()
    }
    
    public func addHeaderSearchPaths(paths:[String],  recursive:Bool = true) -> (){
        self.addSearchPaths(paths, key: header_search_paths_key,recursive:recursive)
    }
    
    public func addLibrarySearchPaths(paths:[String], recursive:Bool = true) -> () {
        self.addSearchPaths(paths, key: library_search_paths_key,recursive:recursive)
    }
    
    public func addFrameworkSearchPaths(paths:[String], recursive:Bool = true) -> () {
        self.addSearchPaths(paths, key: framework_search_paths_key,recursive:recursive)
    }
    
    public func addOtherCFlag(flag:String) -> () {
        self.addOtherCFlags([flag])
    }
    
    public func addOtherCFlags(flags:[String]) -> () {
        self.addOtherFlags(flags, key: other_c_flags_key)
    }
    
    public func addOtherLinkerFlag(flag:String) -> () {
        self.addOtherLinkerFlags([flag])
    }
    
    public func addOtherLinkerFlags(flags:[String]) -> () {
        self.addOtherFlags(flags, key: other_ldflags_key)
    }
    
    public func overWriteBuildSetting(settingName:String,settingValue:String) -> () {
        self.addOtherFlags([settingValue], key: settingName)
    }
    
    private func addSettings(settingItems:[String],key:String, @noescape operation:(String, inout [String]) -> ()) -> (){
        var settings:[String:Any] = [:]
        if let dic = _data[buildSettings_key] as? [String:Any]{
            settings = dic
        }
        
        var items:[String] = []
        if let list = settings[key] as? [String]{
            items = list
        }else if let path = settings[key] as? String{
            items.append(path)
        }
        
        settingItems.forEach{item in
            operation(item,&items)
        }
        
        settings[other_c_flags_key] = items
        _data[buildSettings_key] = settings
    }
    
    private func addSearchPath(path:String, key:String, recursive:Bool = true) -> () {
        self.addSearchPaths([path],key: key,recursive: recursive)
    }
    
    private func addSearchPaths(paths:[String], key:String, recursive:Bool = true,var quoted:Bool = false) -> () {
        
        self.addSettings(paths, key: key) { (path, items) -> () in
            var currentPath = path
            if currentPath.containsString(" ") {
                quoted = true
            }
            if quoted {
                if currentPath.hasSuffix("/**"){
                    currentPath = "\\\"" + currentPath.stringByReplacingOccurrencesOfString("/**", withString: "\\\"/**")
                }else{
                    currentPath = "\\\"" + currentPath + "\\\""
                }
            }
            
            if !items.contains(currentPath) {
                items.append(currentPath)
            }
        }
    }
    
    private func addOtherFlags(flags:[String], key:String) -> (){
        self.addSettings(flags, key:key) { (flag, items) -> () in
            if !items.contains(flag){
                items.append(flag)
            }
        }
    }
}