//
//  PBXObject.swift
//  PBXEditor
//
//  Created by jayden on 15/9/20.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

class XCPObject{
    
    let isaKey = "isa"
    
    var _guid:String!
    var _data:[String:Any]!
    
    var guid:String{
        if let _ = _guid{
            _guid = ""
        }
        return _guid
    }
    
    var data:[String:Any]{
        if let _ = _data{
            _data = [:]
        }
        
        return _data
    }
    
    init(){
        _data = [:]
        _data[isaKey] = _stdlib_getDemangledTypeName(self).componentsSeparatedByString(".").last!
        _guid = self.generateGuid()
    }
    
    convenience init(guid:String){
        self.init()
        if self.isGuid(guid){
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
    
    func generateGuid() -> String {
        return ""
    }
    
    func isGuid(guid:String) -> Bool{
        return true
    }
}
