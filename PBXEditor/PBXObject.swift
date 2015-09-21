//
//  PBXObject.swift
//  PBXEditor
//
//  Created by jayden on 15/9/20.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

class PBXObject{
    
    let isaKey = "isa"
    
    var _guid:String!
    var _data:[String:Any]!
    
    var guid:String{
        if let _ = _guid{
            _guid = self.dynamicType.generateGuid()
        }
        return _guid
    }
    
    var data:[String:Any]{
        if let _ = _data{
            _data = [:]
        }
        
        return _data
    }
    
    var description:String{
        return "{" + self.toCSV() + "}"
    }
    
    init(){
        _data = [:]
        _data[isaKey] = _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last!
        _guid = self.dynamicType.generateGuid()
    }
    
    convenience init(guid:String){
        self.init()
        if self.dynamicType.isGuid(guid){
            _guid = guid
        }
    }
    
    convenience init(guid:String,dictonary:[String:Any]){
        self.init(guid: guid)
        guard let isa = dictonary[isaKey] as? String where isa == _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last! else {
            print("Dictionary is not a valid ISA object")
            return
        }
        
        dictonary.forEach{
            _data[$0] = $1
        }
        
    }
    
    func add(key:String,obj:Any) -> (){
        _data[key] = obj
    }
    
    func remove(key:String) -> (){
        _data.removeValueForKey(key)
    }
    
    func containsKey(key:String) -> Bool{
        return _data.keys.contains(key)
    }
    
    func toCSV() -> String{
        return "\"" + data.description + "\","
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
