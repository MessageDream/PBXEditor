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
    public let pbx_header_token = "// !$*UTF8*$!\n"
    public let white_space_space:Character = " "
    public let white_space_tab:Character = "\t"
    public let white_space_newLine:Character = "\n"
    public let white_space_carriage_return:Character = "\r"
    public let array_begin_token:Character = "("
    public let array_end_token:Character = ")"
    public let array_item_delimiter_token:Character = ","
    public let dictionary_begin_token:Character = "{"
    public let dictionary_end_token:Character = "}"
    public let dictionary_assign_token:Character = "="
    public let dictionary_item_delimiter_token:Character = ";"
    public let quoted_string_begin_token:Character = "\""
    public let quoted_string_end_token:Character = "\""
    public let quoted_string_escape_token:Character = "\\"
    public let end_of_file:Character =  "\u{1A}"
    public let comment_begin_token = "/*"
    public let comment_end_token = "*/"
    public let comment_line_token = "//"
    private let builder_capacity = 2000
    
    private var marker:String?
    private var data:[Character] = []
    private var index = 0
    private var resolver: PBXResolver!
    
    public required init(){
        
    }
    
    public required init(resolver:PBXResolver){
        self.resolver = resolver
    }
    
    public func decode(var inputData:String) -> [String:Any]? {
        guard inputData.hasPrefix(self.pbx_header_token) else{
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
        let muString = NSMutableString(capacity: builder_capacity)
        muString.appendString("\(pbx_header_token)")
        let success = self.serializeValue(pbxData, mutableString: muString)
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
    
    private func guidComment(guid:String,muString:NSMutableString) ->Bool {
        guard let fileName = self.resolver.resolveName(guid) else {
            print(("GUIDComment \(guid) [no filename]"))
            return false
        }
        
        if let location = self.resolver.resolveBuildPhaseNameForFile(guid){
            muString.appendString(" /* \(fileName) in \(location) */")
        }else{
            muString.appendString(" /* \(fileName) */")
        }
        
        return true
    }
    
    private func peek(step:Int = 1) -> String? {
        var sneak = ""
        for i in 1...step {
            if self.data.count - 1 < self.index + i {
                break
            }
           
            sneak  +=  String(self.data[self.index + i])
        }
        return Optional(sneak)
    }
    
    private func skipWhiteSpace() -> Bool {
        var isWhiteSpace = false
       let regex = try! NSRegularExpression(pattern: "\\s", options: .CaseInsensitive)
        while let char = Optional(self.stepForeward()) where  regex.numberOfMatchesInString(String(char), options: [], range: NSMakeRange(0, 1)) > 0 {
            isWhiteSpace = true
        }
        
        self.stepBackward()
        
        if self.skipComments() {
            isWhiteSpace = true
            self.skipWhiteSpace()
        }
        return isWhiteSpace
    }
    
    private func skipComments() -> Bool {
        var s = ""
        if let tag = peek(2) {
            switch tag {
            case comment_begin_token:
                while self.peek(2) != comment_end_token {
                    s += String(self.stepForeward())
                }
                s += String(self.stepForeward(2))
                break
            case comment_line_token:
                while self.stepForeward() != "\n" {
                    continue
                }
                break
            default:
                return false
            }
        }
        
        return true
    }
    
    private func stepForeward(step:Int = 1) -> Character {
        self.index = min(self.data.count, self.index + step)
        print("========\(self.index)")
        return self.data[self.index]
    }
    
    private func stepBackward(step:Int = 1) -> Character {
        self.index = max(0, self.index - step)
        print("========\(self.index)")
        return self.data[self.index]
    }
    
    private func nextToken() -> Character {
        self.skipWhiteSpace()
        return self.stepForeward()
    }
    
    private func paseValue() -> Any? {
        switch self.nextToken() {
        case end_of_file:
            print("end of file")
            return nil
        case dictionary_begin_token:
            return self.parseDictionary()
        case array_begin_token:
            return self.parseArray()
        case quoted_string_begin_token:
            return self.parseString()
        default:
            self.stepBackward()
            return self.parseEntity()
        }
    }
    
    private func parseDictionary() -> [String:Any] {
        self.skipWhiteSpace()
        var dic:[String:Any] = [:]
        var keyString = ""
        var complete = false
        while !complete {
            switch self.nextToken() {
            case end_of_file:
                print("Error: reached end of file inside a dictionary: \(self.index)")
                complete = true
                break
            case dictionary_item_delimiter_token:
                keyString = ""
                break
            case dictionary_end_token:
                keyString = ""
                complete = true
            case dictionary_assign_token:
                if !dic.keys.contains(keyString) {
                    if let v = self.paseValue() {
                       dic[keyString] = v
                    }
                }
                break
            default:
                self.stepBackward()
                if let value = self.paseValue() where value is String {
                    keyString = value as! String
                }
                break
                
            }
        }
        
        return dic
    }
   
    private func parseArray() -> [Any] {
        var list:[Any] = []
        var complete = false
        while !complete {
            switch self.nextToken() {
            case end_of_file:
                print("Error: reached end of file inside a dictionary: \(self.index)")
                complete = true
                break
            case array_end_token:
                complete = true
                break
            case array_item_delimiter_token:
                break
            default:
                self.stepBackward()
                if let value = self.paseValue(){
                    list.append(value)
                }
                break
            }
        }
        return list
    }
    
    private func parseString() -> String {
        var s = ""
        var c = self.stepForeward()
        
        while c != quoted_string_end_token {
            s += String(c)
            if c == quoted_string_escape_token {
                s += String(self.stepForeward())
            }
            c = self.stepForeward()
        }
        return s
    }
    
    private func parseEntity() -> Any {
        var word = ""
        let regex = try! NSRegularExpression(pattern: "[;,\\s=]", options: .CaseInsensitive)
        while let peekStr = self.peek() where regex.numberOfMatchesInString(peekStr, options: [], range:NSMakeRange(0, peekStr.characters.count)) <= 0 {
            word += String(self.stepForeward())
        }
        
        let regex2 = try! NSRegularExpression(pattern: "^\\d$", options: .CaseInsensitive)
        if word.characters.count != 24 && regex2.numberOfMatchesInString(word, options: [], range:NSMakeRange(0, word.characters.count)) > 0 {
            return Int(word)!
        }
        return word
    }
    
    
    
    private func  serializeValue(pbxData:Any?,mutableString:NSMutableString, readable:Bool = false,indent:Int = 0) -> Bool {
        guard let value = pbxData else{
            mutableString.appendString("null")
            return true
        }
        if let pbxobj = value as? PBXObject {
            self.serializeDictionary(pbxobj.data, muString: mutableString, readAble:readable, indent:indent)
        }else if let dic = value as? [String:Any] {
            self.serializeDictionary(dic, muString: mutableString, readAble:readable, indent:indent)
        }else if let array = value as? Array<Any> {
            self.serializeArray(array, muString:mutableString, readAble:readable, indent:indent)
        }else if let va = value as? Bool {
            self.serializeString(String(Int(va)), muString: mutableString,useQuotes: false)
        }else{
            self.serializeString(String(value), muString: mutableString,useQuotes: false)
        }
        return true
    }
    
    private func serializeDictionary(dictionary:[String:Any], muString:NSMutableString, readAble:Bool = false, indent:Int = 0) -> () {
        muString.appendString(String(dictionary_begin_token))
        if readAble {
            endLine(muString)
        }
        
        for (k,v) in dictionary {
            if readAble && indent == 1 {
                self.markSection(muString, name: k)
            }
            if readAble {
                self.indent(muString, deep: indent + 1)
            }
            
            self.serializeString(k, muString:muString,useQuotes: false)
            muString.appendString(" \(dictionary_assign_token) ")
            self.serializeValue(v, mutableString: muString,readable:(readAble && (!(v is PBXBuildFile) && !(v is PBXFileReference))),indent:indent + 1);
            muString.appendString(String(dictionary_item_delimiter_token))
            endLine(muString)
        }
        
        if readAble && indent == 1 {
            markSection(muString, name:"")
        }
        if readAble {
            self.indent(muString, deep: indent)
        }
        muString.appendString(String(dictionary_end_token))
    }
    
    private func serializeArray(array:[Any], muString:NSMutableString, readAble:Bool = false, indent:Int = 0) -> () {
        muString.appendString(String(array_begin_token))
        if readAble {
            endLine(muString)
        }
        array.forEach{item in
            if readAble {
                self.indent(muString, deep: indent + 1)
            }
            self.serializeValue(item, mutableString: muString, readable: readAble, indent: indent + 1)
            muString.appendString(String(array_item_delimiter_token))
            endLine(muString)
        }
        if readAble {
            self.indent(muString, deep: indent)
        }
        muString.appendString(String(array_end_token))
    }
    
    private func serializeString(aString:String, muString:NSMutableString,var useQuotes:Bool = false) -> () {
        let regex = NSPredicate(format:"SELF MATCHES %@", "^[A-Fa-f0-9]{24}$")
        if regex.evaluateWithObject(aString){
            muString.appendString(aString)
            self.guidComment(aString, muString: muString)
            return
        }
        if aString == "" {
            muString.appendString(String(quoted_string_begin_token))
            muString.appendString(String(quoted_string_end_token))
            return
        }
        
        let regex2 = NSPredicate(format:"SELF MATCHES %@", "^[A-Fa-f0-9_./-]+$")
        if !regex2.evaluateWithObject(aString){
            useQuotes =  true
        }
        
        if useQuotes {
            muString.appendString(String(quoted_string_begin_token))
        }
        muString.appendString(aString)
        if useQuotes {
            muString.appendString(String(quoted_string_end_token))
        }
    }
    
}