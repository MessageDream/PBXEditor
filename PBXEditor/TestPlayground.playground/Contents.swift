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

var filePath = ""
var absPath = "/Users/jayden/Documents/GoProjects/src/golang.org/x/tools"
var relativePath = "/Users/jayden"

var dis = NSFileManager.defaultManager().displayNameAtPath(absPath)
dis

var absComponents = absPath.componentsSeparatedByString("/")
var rootComponents = relativePath.componentsSeparatedByString("/")
var index = 0
for i in 0..<absComponents.count {
    if i <= rootComponents.count - 1 {
        if absComponents[i] == rootComponents[i] {
            continue
        }
    }
    index = i
    break
}

rootComponents.removeRange(0...index - 1 )
absComponents.removeRange(0...index - 1)
for _ in 0..<rootComponents.count {
    filePath += "../"
}
filePath += absComponents.joinWithSeparator("/")

let loc =  "1234.lproj"

loc.substringToIndex(loc.endIndex.advancedBy(-".lproj".characters.count))
