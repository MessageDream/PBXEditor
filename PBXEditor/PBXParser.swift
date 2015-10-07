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

public class PBXParser{
    public let pbxHeaderToken = "// !$*UTF8*$!\n"
    public let whiteSpaceSpace:Character = " "
    public let whiteSpaceTab:Character = "\t"
    public let whiteSpaceNewLine:Character = "\n"
    public let whiteSpaceCarriageReturn:Character = "\r"
    public let arrayBeginToken:Character = "("
    public let arrayEndToken:Character = ")"
    public let arrayItemDelimiterToken:Character = ","
    public let dictionaryBeginToken:Character = "{"
    public let dictionaryEndToken:Character = "}"
    public let dictionaryAssignToken:Character = "="
    public let dictionaryItemDelimiterToken:Character = ";"
    public let quotedStringBeginToken:Character = "\""
    public let quotedStringEndToken:Character = "\""
    public let quotedStringEscapeToken:Character = "\\"
    public let endOfFile =  "\u{1A}"
    public let commitBeginToken = "/*"
    public let commitEndToken = "*/"
    public let commitLineToken = "//"
    private let builderCapacity = 2000
    
    private var marker:String?
    private var data:[Character] = []
    private var index = 0
    private var resolver: PBXResolver!
    
    public required init(resolver:PBXResolver){
        self.resolver = resolver
    }
    
    public func decode(var inputData:String) -> [String:Any]? {
        guard inputData.hasPrefix(self.pbxHeaderToken) else{
            print("Wrong file format.")
            return nil
        }
        
        inputData = inputData.substringFromIndex(inputData.startIndex.advancedBy(13))
        
        for item in inputData.characters{
            self.data.append(item)
        }
        
        return self.paseValue() as? [String:Any]
    }
    
    public func encode(pbxData:[String:Any], readable:Bool = false) -> String? {
        let muString = NSMutableString(capacity: builderCapacity)
        muString.appendString("\(pbxHeaderToken)")
        let success = self.serializeValue(pbxData, mutableStrung: muString)
        muString.appendString("\n")
        return success ?String(muString):nil
    }
    
    private func indent(muString:NSMutableString,deep:Int) -> (){
        muString.appendString("".stringByPaddingToLength(deep, withString: "\t", startingAtIndex: 0))
    }
    
    private func endLine(muString:NSMutableString,useSpace:Bool = false) -> (){
        muString.appendString(useSpace ?" ":"\n")
    }
    
    private func markSection(muString:NSMutableString,name:String){
        if let mak = self.marker where mak != name{
        muString.appendString("/* End \(mak) section */\n")
        }
        
        if name != self.marker{
            muString.appendString("\n/* Begin \(name) section */\n")
        }
        
        self.marker = name
    }
    
    
    private func paseValue() -> Any {
        return ""
    }
    
   private func  serializeValue(pbxData:Any,mutableStrung:NSMutableString, readable:Bool = false,indent:Int = 0) -> Bool {
        return true
    }
    
}