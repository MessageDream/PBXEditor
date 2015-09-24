//
//  PBXFileReference.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXFileReference:PBXObject{
    internal let pathKey = "path";
    internal let nameKey = "name";
    internal let sourcetreeKey = "sourceTree";
    internal let explicitFileTypeKey = "explicitFileType";
    internal let lastknownFileTypeKey = "lastKnownFileType";
    internal let encodingKey = "fileEncoding";
    
    public var compilerFlags:String?
    public var buildPhase:String?
    
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
        ".app": nil,
        ".s": "PBXSourcesBuildPhase",
        ".c": "PBXSourcesBuildPhase",
        ".cpp": "PBXSourcesBuildPhase",
        ".framework": "PBXFrameworksBuildPhase",
        ".h": nil,
        ".pch": nil,
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
        ".xcodeproj": nil,
        ".xib": "PBXResourcesBuildPhase",
        ".strings": "PBXResourcesBuildPhase",
        ".bundle": "PBXResourcesBuildPhase",
        ".dylib": "PBXFrameworksBuildPhase"
    ]
    

    
}