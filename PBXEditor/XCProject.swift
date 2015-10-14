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
    private var _fileReferences:[String:PBXFileReference]!
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
    
    public var fileReferences:[String:PBXFileReference]{
        if _fileReferences == nil {
            _fileReferences = [String:PBXFileReference](dictionary: _objects)
        }
        return _fileReferences!
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
    
    public func getObject(guid:String) -> Any?{
        return _objects[guid]
    }
    
   
    
    public func addFile(var filePath:String, var parent:PBXGroup? = nil, tree:TreeEnum = .SourceRoot, creatBuildFiles:Bool = true, weak:Bool = false) -> () {
        
        var absPath = ""
        if !filePath.hasPrefix("/") && tree != .SDKRoot{
            absPath = _fileManager.currentDirectoryPath + "/" + filePath
        }
        
        let (exist,isDir) = isFileExistAndIsDir(absPath)
        
        if !exist && tree != .SDKRoot {
            print("Miss file: \(absPath)")
            return
        }else if tree == .SourceRoot {
            print( "Source Root File" );
            filePath = getRelativePath(absPath, projPath: _projectRootPath)
        }else if tree == .Group {
            print("Group file")
            filePath = _fileManager.displayNameAtPath(filePath)
        }
        
        if parent == nil {
            parent = _rootGroup
        }
        if isFileReferenceExist(_fileManager.displayNameAtPath(filePath)){
            print("File already exists:\(filePath)")
            return
        }
        
        let fileRef = PBXFileReference(filePath: filePath, tree:tree)
        parent?.addChild(fileRef)
       _fileReferences[fileRef.guid] = fileRef
        
        if fileRef.buildPhase != nil && creatBuildFiles {
            switch fileRef.buildPhase! {
            case .PBXFrameworksBuildPhase:
                frameworkBuildPhase.forEach({ (item) -> () in
                    buildAddFile(fileRef, currentBuildPhase: item.1)
                })
                if tree == .SourceRoot {
                   let libPath = "$(SRCROOT)/" + filePath.componentsSeparatedByString("/").dropLast().joinWithSeparator("/")
                    if isDir{
                       addFrameworkSearchPath(libPath)
                    }else{
                       addLibrarySearchPath(libPath)
                    }
                }
                break
            case .PBXResourcesBuildPhase:
               resourcesBuildPhase.forEach({ (item) -> () in
                buildAddFile(fileRef, currentBuildPhase: item.1)
               })
                break
            case .PBXShellScriptBuildPhase:
                shellScriptBuildPhase.forEach({ (item) -> () in
                    buildAddFile(fileRef, currentBuildPhase: item.1)
                })
                break
            case .PBXSourcesBuildPhase:
                sourcesBuildPhase.forEach({ (item) -> () in
                    buildAddFile(fileRef, currentBuildPhase: item.1)
                })
                break
            case .PBXCopyFilesBuildPhase:
                copyBuildPhase.forEach({ (item) -> () in
                    buildAddFile(fileRef, currentBuildPhase: item.1)
                })
                break
            default:
                print("File not supported: \(filePath)")
                break
            }
           print("Adding \(fileRef.buildPhase!.rawValue) build file")
        }else{
           print("File not supported: \(filePath)")
        }
        
    }
    
    public func addEmbedFramework(fileName:String) -> () {
        print("Add Embed Framework: " + fileName)
        guard let  fileRef = getFile(_fileManager.displayNameAtPath(fileName)) else{
            print("Embed Framework must added already: " + fileName)
            return
        }
        
        guard let embedPhase = addEmbedFrameworkBuildPhase() else{
            print("AddEmbedFrameworkBuildPhase Failed.")
            return
        }
        
        let buildFile = PBXBuildFile(fileRef: fileRef)
        buildFile.addCodeSignOnCopy()
        _buildFiles[buildFile.guid] = buildFile
        
        embedPhase.addBuildFile(buildFile)
        
    }
    
    public func addFolder(folderPath:String, var parent:PBXGroup? = nil,var exclude:[String]? = nil,
        recursive:Bool = true, creatBuildFile:Bool = true) -> () {
            print("Folder path:\(folderPath)")
            if !_fileManager.fileExistsAtPath(folderPath){
                print("Directory doesn't exist?")
                return
            }
            
            if folderPath.hasSuffix(".lproj"){
                addLocFolder(folderPath, parent: parent, exclude: exclude, recursive: recursive, creatBuildFile: creatBuildFile)
                return
            }
            
            if exclude == nil{
                print("Exclude was nil")
                exclude = []
            }
            
            if parent == nil {
                print("Parent was nil")
                parent = _rootGroup
            }
            
            let newGroup = getGroup(_fileManager.displayNameAtPath(folderPath),parent:parent)
            print("New Group created")
            let contents = try! _fileManager.contentsOfDirectoryAtPath(filePath)
            for item in contents{
                let itemPath = "\(filePath)/\(item)"
            
                let (exist,isDir) = isFileExistAndIsDir(itemPath)
                
                guard exist else {
                    continue
                }
                if isDir{
                    if itemPath.hasSuffix(".bundle"){
                        print("This is a special folder: \(itemPath)")
                        addFile(itemPath, parent: newGroup, tree: TreeEnum.SourceRoot, creatBuildFiles: creatBuildFile)
                        continue
                    }
                    
                    if recursive {
                        print("recursive")
                        addFolder(itemPath, parent: newGroup, exclude: exclude, recursive: recursive, creatBuildFile: creatBuildFile)
                    }
                }else{
                    if let regexExclude = exclude?.joinWithSeparator("|"){
                        let regex = try! NSRegularExpression(pattern:regexExclude, options: .CaseInsensitive)
                        if regex.numberOfMatchesInString(itemPath, options:[], range:NSMakeRange(0, itemPath.characters.count)) > 0 {
                            continue
                        }
                        print("Adding Files for Folder")
                        addFile(itemPath, parent: newGroup, tree: .SourceRoot, creatBuildFiles: creatBuildFile)
                    }
                }
            }
    }
    
    public func addLocFolder(folderPath:String, var parent:PBXGroup? = nil, var exclude:[String]? = nil,
        recursive:Bool = true, creatBuildFile:Bool = true) -> () {
            if exclude == nil{
                exclude = []
            }
            
            if parent == nil {
                parent = _rootGroup
            }
            
            let locName = _fileManager.displayNameAtPath(folderPath)
            
            let relativePath = getRelativePath(folderPath, projPath: _projectRootPath)
            let newGroup = getGroup(locName, path: relativePath, parent: parent)
           
            let region = locName.substringToIndex(locName.endIndex.advancedBy(-".lproj".characters.count))
           
            _project.addRegion(region)
            
            let contents = try! _fileManager.contentsOfDirectoryAtPath(filePath)
            for item in contents{
                let itemPath = "\(filePath)/\(item)"
                if let regexExclude = exclude?.joinWithSeparator("|"){
                    let regex = try! NSRegularExpression(pattern:regexExclude, options: .CaseInsensitive)
                    if regex.numberOfMatchesInString(itemPath, options:[], range:NSMakeRange(0, itemPath.characters.count)) > 0 {
                        continue
                    }
                    
                    let variant = PBXVariantGroup(name: _fileManager.displayNameAtPath(itemPath), path: nil, tree: TreeEnum.Group)
                    _variantGroup[variant.guid] = variant
                    newGroup!.addChild(variant)
                    addFile(itemPath, parent: variant, tree: .Group, creatBuildFiles: creatBuildFile)
                }
            }
    }
    
    private func getNativeTarget(name:String) -> PBXNativeTarget? {
        var target: PBXNativeTarget? = nil
        for item in nativeTarget {
            if let na = item.1.data["name"] as? String where na == name{
                target = item.1
                break
            }
        }
        return target
    }
    
    private func getBuildActionMask() -> Int {
        var mask = 0
        for item in copyBuildPhase {
            if let msk = item.1.data["buildActionMask"] as? Int {
                mask = msk
                break
            }
        }
        return mask
    }
    
    private func getFile(name:String) -> PBXFileReference? {
        for item in fileReferences{
            if let fName = item.1.name where fName == name{
                return item.1
            }
        }
        
        return nil
    }
    
    private func getGroup(name:String, path:String? = nil, var parent:PBXGroup? = nil) -> PBXGroup? {
        if parent == nil {
            parent = _rootGroup
        }
        for item in groups {
            if let n = item.1.name where n == name && parent!.hasChild(item.0){
                return item.1
            }else if let p = item.1.path where p == name && parent!.hasChild(item.0){
                return item.1
            }
        }
        
        let result = PBXGroup(name: name, path: path)
        _groups[result.guid] = result
        parent!.addChild(result)
        return result
    }
    
    private func addEmbedFrameworkBuildPhase() -> PBXCopyFilesBuildPhase? {
        var phase:PBXCopyFilesBuildPhase? = nil
        guard let nativeTarget = getNativeTarget("") else {
            print("Not found Correct NativeTarget.")
            return phase
        }
        
        //check if embed framework buildPhase ex
        for item in copyBuildPhase{
            if let name = item.1.data["name"] as? String where name == "Embed Frameworks" {
                return item.1
            }
        }
        
        let buildActionMask = getBuildActionMask()
        phase = PBXCopyFilesBuildPhase(buildActionMask: buildActionMask)
        var buildPhases = nativeTarget.data["buildPhases"] as? [Any]
        buildPhases?.append(phase!.guid)
        nativeTarget.add("buildPhases", obj:buildPhases)
        _copyBuildPhase[phase!.guid] = phase!
        return phase
    }
    
    
    private func getRelativePath(absPath:String,projPath:String) -> String {
        var filePath = ""
        var absComponents = absPath.componentsSeparatedByString("/")
        var projComponents = projPath.componentsSeparatedByString("/")
        var index = 0
        for i in 0..<absComponents.count {
            if i <= projComponents.count - 1 {
                if absComponents[i] == projComponents[i] {
                    continue
                }
            }
            index = i
            break
        }
        
        projComponents.removeRange(0...index - 1 )
        absComponents.removeRange(0...index - 1)
        for _ in 0..<projComponents.count {
            filePath += "../"
        }
        filePath += absComponents.joinWithSeparator("/")
        return filePath
    }
    
    
    
    private func isFileReferenceExist(name:String) -> Bool {
        for item in self.fileReferences {
            guard item.1.name == name else {
               continue
            }
            return true
        }
        return false
    }
    
    private func isFileExistAndIsDir(path:String) -> (Bool,Bool){
        var isDirPointer:UnsafeMutablePointer<ObjCBool> = UnsafeMutablePointer<ObjCBool>(bitPattern: 1)
        isDirPointer.initialize(ObjCBool(false))
        let exist = _fileManager.fileExistsAtPath(path, isDirectory: isDirPointer)
        let isDir = isDirPointer.memory.boolValue
        
        defer {
            isDirPointer.destroy()
            isDirPointer.dealloc(1)
            isDirPointer = nil
        }
        return (exist,isDir)
    }
    
    private func buildAddFile(fileRef:PBXFileReference,currentBuildPhase:PBXBuildPhase, weak:Bool = false) -> () {
        let buildFile = PBXBuildFile(fileRef:fileRef, weak: weak)
        _buildFiles[buildFile.guid] = buildFile
        currentBuildPhase.addBuildFile(buildFile)
    }
}