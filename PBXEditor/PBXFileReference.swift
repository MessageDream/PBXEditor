//
//  PBXFileReference.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXFileReference:PBXObject{
    private let pathKey = "path";
    private let nameKey = "name";
    private let sourcetreeKey = "sourceTree";
    private let explicitFileTypeKey = "explicitFileType";
    private let lastknownFileTypeKey = "lastKnownFileType";
    private let encodingKey = "fileEncoding";
    
    public var compilerFlags:String?
    public var buildPhase:String?
    
    public var name:String?{
        return _data[nameKey] as? String
    }
    
    public var path:String?{
        return _data[pathKey] as? String
    }
    
    public static let typeNames = [
        ".a":"archive.ar",
        ".app": "wrapper.application",
        ".s": "sourcecode.asm",
        ".c": "sourcecode.c.c",
        ".cpp": "sourcecode.cpp.cpp",
        ".framework": "wrapper.framework",
        ".h": "sourcecode.c.h",
        ".pch": "sourcecode.c.h",
        ".icns": "image.icns",
        ".m":"sourcecode.c.objc",
        ".mm":"sourcecode.cpp.objcpp",
        ".nib":"wrapper.nib",
        ".plist":"text.plist.xml",
        ".png":"image.png",
        ".rtf":"text.rtf",
        ".tiff":"image.tiff",
        ".txt":"text",
        ".xcodeproj":"wrapper.pb-project",
        ".xib":"file.xib",
        ".strings":"text.plist.strings",
        ".bundle":"wrapper.plug-in",
        ".dylib":"compiled.mach-o.dylib",
        ".json":"text.json"
    ]
    
    public static let typePhases = [
        ".a": "PBXFrameworksBuildPhase",
        //        ".app": nil,
        ".s": "PBXSourcesBuildPhase",
        ".c": "PBXSourcesBuildPhase",
        ".cpp": "PBXSourcesBuildPhase",
        ".framework": "PBXFrameworksBuildPhase",
        //        ".h": nil,
        //        ".pch": nil,
        ".icns": "PBXResourcesBuildPhase",
        ".m": "PBXSourcesBuildPhase",
        ".mm": "PBXSourcesBuildPhase",
        ".nib": "PBXResourcesBuildPhase",
        ".plist": "PBXResourcesBuildPhase",
        ".png": "PBXResourcesBuildPhase",
        ".rtf": "PBXResourcesBuildPhase",
        ".tiff": "PBXResourcesBuildPhase",
        ".txt": "PBXResourcesBuildPhase",
        ".json": "PBXResourcesBuildPhase",
        //        ".xcodeproj": nil,
        ".xib": "PBXResourcesBuildPhase",
        ".strings": "PBXResourcesBuildPhase",
        ".bundle": "PBXResourcesBuildPhase",
        ".dylib": "PBXFrameworksBuildPhase"
    ]
    
    public required init() {
        super.init()
    }
    
    public convenience init(filePath:String,tree:TreeEnum = .SourceRoot) {
        self.init()
        self.add(pathKey, obj: filePath)
        self.add(nameKey, obj: NSFileManager.defaultManager().displayNameAtPath(filePath))
        self.add(sourcetreeKey, obj:(filePath.hasPrefix("/") ?.Absolute : tree).rawValue)
        self.guessFileType()
    }
    
    public func guessFileType() -> (){
        self.remove(explicitFileTypeKey)
        self.remove(lastknownFileTypeKey)
        let ext = String(_data[pathKey]).componentsSeparatedByString(".").last!
        if !self.dynamicType.typeNames.keys.contains(ext) {
            print("Unknown file extension: \(ext)\nPlease add extension and Xcode type to \(self.dynamicType).types")
            return
        }
        
        self.add(lastknownFileTypeKey, obj: self.dynamicType.typeNames[ext])
        self.buildPhase = self.dynamicType.typePhases[ext]
    }
}

public enum TreeEnum:String{
    case Absolute = "<absolute>"
    case Group = "<group>"
    case BuiltProductsDir = "BUILT_PRODUCTS_DIR"
    case DeveloperDir = "DEVELOPER_DIR"
    case Sdkroot = "SDKROOT"
    case SourceRoot = "SOURCE_ROOT"
}