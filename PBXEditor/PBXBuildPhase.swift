//
//  PBXBuildPhase.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXBuildPhase:PBXObject{
    
    private let filesKey = "files"
    
    public var files:[String]{
        if !self.containsKey(filesKey){
            self.add(filesKey, obj:[String]())
        }
        return  self.data[filesKey] as! [String]
    }
    
    public required init() {
        super.init()
    }
    
    public func addBuildFile (file:PBXBuildFile){
        var fs = self.files
        fs.append(file.guid)
    }
    
    public func removeBuildFile(fid:String) -> (){
        guard let index = self.files.indexOf(fid) else {
            return
        }
        
        var fs = self.files
        fs.removeAtIndex(index)
        _data[filesKey] = fs
    }
    
    public func hasBuildFile (fid:String) -> Bool{
        guard self.dynamicType.isGuid(fid) && self.files.contains(fid) else{
            return false
        }
        return true
    }
    
}

public class PBXFrameworksBuildPhase : PBXBuildPhase{
    public required init(){
        super.init()
    }
}

public class PBXResourcesBuildPhase : PBXBuildPhase{
    public required init(){
        super.init()
    }
}

public class PBXShellScriptBuildPhase : PBXBuildPhase{
    public required init(){
        super.init()
    }
}

public class PBXSourcesBuildPhase : PBXBuildPhase{
    public required init(){
        super.init()
    }
}

public class PBXCopyFilesBuildPhase : PBXBuildPhase{
    
    //Embed Frameworks PBXCopyFilesBuildPhase constructor
    //to make sure "isa" = "PBXCopyFilesBuildPhase"
    
    public required init(){
        super.init()
    }
    
    public required convenience init(buildActionMask:Int ){
        self.init()
        self.add("buildActionMask", obj: buildActionMask)
        self.add("dstPath", obj: "")
        self.add("dstSubfolderSpec",obj:10)
        self.add("name", obj: "Embed Frameworks")
        self.add("runOnlyForDeploymentPostprocessing", obj: 0)
    }
    
}