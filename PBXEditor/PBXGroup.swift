//
//  PBXGroup.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation
public class PBXGroup:PBXObject{
    private let childrenKey = "children";
    private let nameKey = "name"
    private let pathKey = "path"
    private let sourceTreeKey = "sourceTree"
    
    public required init(){
        super.init()
    }
    
    public convenience init(name:String, path:String? = nil, tree:TreeEnum = .SourceRoot){
        self.init()
        self.add(nameKey, obj: name)
        if let pa = path{
            self.add(pathKey, obj: pa)
            self.add(sourceTreeKey, obj: tree.rawValue)
        }else{
            self.add(sourceTreeKey, obj: TreeEnum.Absolute.rawValue)
        }
    }
    
    public var children:[String]{
        if !self.containsKey(childrenKey){
            self.add(childrenKey, obj: [String]())
        }
        return self.data[childrenKey] as! [String]
    }
    
    public var name:String?{
        return _data[nameKey] as? String
    }
    
    public var path:String?{
        return _data[pathKey] as? String
    }
    
    public var sourceTree:String?{
        return _data[sourceTreeKey] as? String
    }
    
    public func addChild(child:PBXObject) -> String? {
        guard child is PBXFileReference || child is PBXGroup else{
            return nil
        }
        var chr = self.children
        chr.append(child.guid)
        _data[childrenKey] = chr
        return child.guid
    }
    
    public func removeChild(cid:String) -> (){
        guard self.dynamicType.isGuid(cid) && self.containsKey(childrenKey) else{
            return
        }
        var chr = self.children
        if let index = chr.indexOf(cid){
            chr.removeAtIndex(index)
        }
        _data[childrenKey] = chr
    }
    
    public func hasChild(cid:String) ->Bool {
        guard self.dynamicType.isGuid(cid) && self.containsKey(childrenKey) else{
            return false
        }
        return self.children.contains(cid)
    }
}