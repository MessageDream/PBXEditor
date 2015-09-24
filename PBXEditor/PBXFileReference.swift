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
    
}