//
//  PBXObject.swift
//  PBXEditor
//
//  Created by jayden on 15/9/20.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXObject:CustomStringConvertible{
    
    private let isa_key = "isa"
    
    internal var _guid:String!
    internal var _data:[String:Any]!
    
    public var guid:String{
        if let _ = _guid{
            _guid = self.dynamicType.generateGuid()
        }
        return _guid
    }
    
    public var data:[String:Any]{
        guard let _ = _data else{
            _data = [:]
            return _data
        }
        
        return _data
    }
    
    public var description:String{
        return "{" + self.toCSV() + "}"
    }
    
    public required  init(){
        _data = [:]
        _data[isa_key] = _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last!
        _guid = self.dynamicType.generateGuid()
    }
    
    public required  convenience init(guid:String){
        self.init()
        if self.dynamicType.isGuid(guid){
            _guid = guid
        }
    }
    
    public required convenience init(guid:String,dictonary:[String:Any]){
        self.init(guid: guid)
        guard let isa = dictonary[isa_key] as? String where isa == _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last! else {
            print("Dictionary is not a valid ISA object")
            return
        }
        
        dictonary.forEach{
            _data[$0] = $1
        }
    }
    
    public func add(key:String,obj:Any) -> (){
        _data[key] = obj
    }
    
    public func remove(key:String) -> (){
        if _data.keys.contains(key){
            _data.removeValueForKey(key)
        }
    }
    
    public func containsKey(key:String) -> Bool{
        return _data.keys.contains(key)
    }
    
    internal func toCSV() -> String{
        var ret = ""
        _data.forEach{
            ret += "<"
            ret += "\($0.0)"
            ret += ", "
            ret += "\($0.1)"
            ret += ">, "
        }
        return "\"" + ret + "\","
    }
    
    
    static func generateGuid() -> String {
        let uuid = NSUUID().UUIDString
        return uuid.substringToIndex(uuid.startIndex.advancedBy(8))
    }
    
    static func isGuid(guid:String) -> Bool{
        do{
            let regex = try! NSRegularExpression(pattern: "^[A-Za-z0-9]{24}$", options: .CaseInsensitive)
            return regex.numberOfMatchesInString(guid, options: [], range: NSMakeRange(0, guid.characters.count)) > 0
        }
    }
}

public class PBXNativeTarget:PBXObject{
    public required init(){
        super.init()
    }
}

public class PBXContainerItemProxy:PBXObject{
    public required init(){
        super.init()
    }
}
public class PBXReferenceProxy:PBXObject{
    public required init(){
        
    }
}