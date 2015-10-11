//
//  XCProject.swift
//  PBXEditor
//
//  Created by jayden on 15/10/11.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class XCProject{
    private lazy var _fileManager = NSFileManager.defaultManager()
    private var _datastore:[String:Any] = [:]
    private var _rootGroup:PBXGroup!
    private var _rootObjectKey:String!
    private var _project:PBXProject!
    
    // Objects
    private var _buildFiles:[String:PBXBuildFile]!
    private var _groups:[String:PBXGroup]!
    private var _fileReference:[String:PBXFileReference]!
    private var _nativeTarget:[String:PBXNativeTarget]!
    
    private var _frameworkBuildPhase:[String:PBXFrameworksBuildPhase]!
    private var _resourcesBuildPhase:[String:PBXResourcesBuildPhase]!
    private var _shellScriptBuildPhase:[String:PBXShellScriptBuildPhase]!
    private var _sourcesBuildPhase:[String:PBXSourcesBuildPhase]!
    private var _copyBuildPhase:[String:PBXCopyFilesBuildPhase]!
    
    private var _variantGroup:[String:PBXVariantGroup]!
    private var _buildConfiguration:[String:XCBuildConfiguration]!
    private var _configurationLists:[String:XCConfigurationList]!
    
    private var _projectRootPath:String = ""
    private var _filePath:String = ""
    private var _objects:[String:Any] = [:]
    
    
    public var buildFiles:[String:PBXBuildFile]{
        if _buildFiles == nil {
            _buildFiles = [String:PBXBuildFile](dictionary: _objects)
        }
        return _buildFiles!
    }
    
    public var groups:[String:PBXGroup]{
        if _groups == nil {
            _groups = [String:PBXGroup](dictionary: _objects)
        }
        return _groups!
    }
    
    public var fileReference:[String:PBXFileReference]{
        if _fileReference == nil {
            _fileReference = [String:PBXFileReference](dictionary: _objects)
        }
        return _fileReference!
    }
    
    public var nativeTarget:[String:PBXNativeTarget]{
        if _nativeTarget == nil {
            _nativeTarget = [String:PBXNativeTarget](dictionary: _objects)
        }
        return _nativeTarget!
    }
    
    
    public var frameworkBuildPhase:[String:PBXFrameworksBuildPhase]{
        if _frameworkBuildPhase == nil {
            _frameworkBuildPhase = [String:PBXFrameworksBuildPhase](dictionary: _objects)
        }
        return _frameworkBuildPhase!
    }
    
    public var resourcesBuildPhase:[String:PBXResourcesBuildPhase]{
        if _resourcesBuildPhase == nil {
            _resourcesBuildPhase = [String:PBXResourcesBuildPhase](dictionary: _objects)
        }
        return _resourcesBuildPhase!
    }
    
    public var shellScriptBuildPhase:[String:PBXShellScriptBuildPhase]{
        if _shellScriptBuildPhase == nil {
            _shellScriptBuildPhase = [String:PBXShellScriptBuildPhase](dictionary: _objects)
        }
        return _shellScriptBuildPhase!
    }
    
    public var sourcesBuildPhase:[String:PBXSourcesBuildPhase]{
        if _sourcesBuildPhase == nil {
            _sourcesBuildPhase = [String:PBXSourcesBuildPhase](dictionary: _objects)
        }
        return _sourcesBuildPhase!
    }
    
    public var copyBuildPhase:[String:PBXCopyFilesBuildPhase]{
        if _copyBuildPhase == nil {
            _copyBuildPhase = [String:PBXCopyFilesBuildPhase](dictionary: _objects)
        }
        return _copyBuildPhase!
    }
    
    
    public var variantGroup:[String:PBXVariantGroup]{
        if _variantGroup == nil {
            _variantGroup = [String:PBXVariantGroup](dictionary: _objects)
        }
        return _variantGroup!
    }
    
    public var buildConfiguration:[String:XCBuildConfiguration]{
        if _buildConfiguration == nil {
            _buildConfiguration = [String:XCBuildConfiguration](dictionary: _objects)
        }
        return _buildConfiguration!
    }
    
    public var configurationLists:[String:XCConfigurationList]{
        if _configurationLists == nil {
            _configurationLists = [String:XCConfigurationList](dictionary: _objects)
        }
        return _configurationLists!
    }
    
    
    public var projectRootPath:String {
        return _projectRootPath
    }
    
    public var  filePath:String {
        return _filePath
    }
    
    public var objects:[String:Any]{
        return _objects
    }
    
    public required init(){
        
    }
    
    public convenience required init(filePath:String){
        self.init()
        if !_fileManager.fileExistsAtPath(filePath) {
            print( "XCode project path does not exist: " + filePath)
            return
        }
        if !filePath.hasSuffix(".xcodeproj"){
            print(filePath + " is not a xcodeproj file")
        }
        
        print("Opening project " + filePath)
        _projectRootPath = filePath.componentsSeparatedByString("/").dropLast().joinWithSeparator("/")
        _filePath = filePath
       
        do{
            let contents = try String(contentsOfFile: _filePath + "/project.pbxproj")
            let parser = PBXParser()
            _datastore = parser.decode(contents)!
        }catch let error{
            print(error)
        }
        
        guard let objs = _datastore["objects"] as? [String:Any] else {
            print( "Errore \(_datastore.count)")
            return
        }
        
        _objects = objs
        
        guard let rootObjectKey = _datastore["rootObject"] as? String where rootObjectKey != "" else {
            _project = nil
            _rootGroup = nil
            return
        }
        
        _project = PBXProject(guid: rootObjectKey, dictonary: _objects[rootObjectKey] as! [String:Any] )
        _rootGroup = PBXGroup(guid: rootObjectKey,dictonary: _objects[_project.mainGroupID] as! [String:Any] );
        _rootObjectKey = rootObjectKey
        
    }
    
    public func addHeaderSearchPath(path:String) -> () {
        self.addHeaderSearchPaths([path])
    }
    
    public func addHeaderSearchPaths(paths:[String]) -> () {
        self.buildConfiguration.forEach { (k,v) -> () in
            v.addHeaderSearchPaths(paths)
        }
    }
    
    public func addLibrarySearchPath(path:String) -> () {
        self.addLibrarySearchPaths([path])
    }
    
    public func addLibrarySearchPaths(paths:[String]) -> () {
        self.buildConfiguration.forEach { (k,v) -> () in
            v.addLibrarySearchPaths(paths)
        }
    }
    
    public func addFrameworkSearchPath(path:String) -> () {
        self.addFrameworkSearchPaths([path])
    }
    
    public func addFrameworkSearchPaths(paths:[String]) -> () {
        self.buildConfiguration.forEach { (k,v) -> () in
            v.addFrameworkSearchPaths(paths)
        }
    }
    
    public func addOtherCFlag(flag:String) -> () {
        self.addOtherCFlags([flag])
    }
    
    public func addOtherCFlags(flags:[String]) -> () {
        self.buildConfiguration.forEach { (k,v) -> () in
            v.addOtherCFlags(flags)
        }
    }
    
    public func addOtherLinkerFlag(flag:String) -> () {
        self.addOtherLinkerFlags([flag])
    }
    
    public func addOtherLinkerFlags(flags:[String]) -> () {
        self.buildConfiguration.forEach { (k,v) -> () in
            v.addOtherLinkerFlags(flags)
        }
    }
    
    public func overWriteBuildSetting(settingName:String,settingValue:String, buildConfigName:String = "all") -> () {
        print("overwriteBuildSetting " + settingName + " " + settingValue + " " + buildConfigName)
        self.buildConfiguration.forEach { (k,v) -> () in
            if String(v.data["name"]!) == buildConfigName || String(v.data["name"]!) == "all"{
                v.overWriteBuildSetting(settingName, settingValue: settingValue)
            }
        }
    }
}