//
//  PBXParser.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXResolver{
    internal var objects:[String:Any]!
    internal var rootObject:String!
    internal var index = [String:String]()
    
    public required init(pbxData:[String:Any]){
        self.objects = pbxData["objects"] as! [String:Any]
        self.rootObject = pbxData["rootObject"] as! String
        self.buildReverseIndex()
    }
    
    private func buildReverseIndex() -> (){
        self.objects.forEach{ (key,value) in
            if let val = value as? PBXBuildPhase {
                val.files.forEach{ fileGuid in
                    self.index[fileGuid] = key
                }
            }else if let val = value as? PBXGroup {
                val.children.forEach{childGuid in
                    index[childGuid] = key
                }
            }
        }
    }
    
    public func resolveName(guid:String) -> String?{
        guard self.objects.keys.contains(guid) else{
            print("\(self) ResolveName could not resolve \(guid)")
            return  nil
        }
        let entity:Any = self.objects[guid]
        if let en = entity as? PBXBuildFile{
            return self.resolveName(en.fileRef)
        }else if let en = entity as? PBXFileReference{
            return (en.name != nil ?en.name : en.path)
        }else if let en = entity as? PBXGroup{
            return (en.name != nil ?en.name : en.path)
        }else if entity is PBXProject || guid == self.rootObject{
            return "Project object"
        }else if entity is PBXFrameworksBuildPhase {
            return "Frameworks"
        }else if entity is PBXResourcesBuildPhase {
            return "Resources"
        }else if entity is PBXShellScriptBuildPhase {
            return "ShellScript"
        }else if entity is PBXSourcesBuildPhase {
            return "Sources"
        }else if entity is PBXCopyFilesBuildPhase {
            return "CopyFiles"
        }else if let en = entity as? PBXObject{
            return en.data["name"] as? String
        }
        print("UNRESOLVED GUID:\(guid)");
        return nil
    }
    
    public func resolveBuildPhaseNameForFile(guid:String) -> String?{
        guard let entity = self.objects[guid] as? PBXObject where self.index.keys.contains(entity.guid) else{
            return nil
        }
        guard let parentGuid = self.index[entity.guid] where self.objects.keys.contains(parentGuid) else{
            return nil
        }
        
        guard let parent = self.objects[parentGuid] as? PBXBuildPhase else{
            return nil
        }
        
        return self.resolveName(parent.guid)
    }
}
