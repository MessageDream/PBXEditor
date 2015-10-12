//: Playground - noun: a place where people can play

import Cocoa

import PBXEditor

var itemdata:[String:Any] = ["456":["789"]]

var _data:[String:Any] = ["123":itemdata]


internal func settingDataDictinaryItem(dicKey:String,dicItemKey:String,@noescape dicItemInitOperation:Any? -> Any , @noescape dicItemOperation:inout Any -> ()) -> (){
    var settings:[String:Any] = [:]

    if let dic = _data[dicKey] as? [String:Any]{
        settings = dic
    }
    var item = dicItemInitOperation(settings[dicItemKey])
    
    dicItemOperation(&item)
    
    settings[dicItemKey] = item
    
    _data[dicKey] = settings
}

private func setSettings(@noescape operation: inout [String] -> ()) -> (){
    
    settingDataDictinaryItem("123", dicItemKey: "456", dicItemInitOperation: { (attrs) -> Any in
        var attributes:[String] = []
        if let list = attrs as? [String]{
            attributes = list
        }
        return attributes
        }) { (attributes) -> () in
            var attrs = attributes as! [String]
            operation(&attrs)
//            attributes = attrs
    }
}

setSettings { (items) -> () in
    items.append("hede")
    items.append("wererre")
}


var proj = XCProject(filePath: "/Users/jayden/Documents/IOS/test/test.xcodeproj")


