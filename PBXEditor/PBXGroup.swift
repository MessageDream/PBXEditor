//
//  PBXGroup.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation
public class PBXGroup:PBXObject{
    private let children_key = "children";
    private let name_key = "name"
    private let path_key = "path"
    private let sourcetree_key = "sourceTree"
    
    public required init(){
        super.init()
    }
    
    public convenience init(name:String, path:String? = nil, tree:TreeEnum = .SourceRoot){
        self.init()
        self.add(name_key, obj: name)
        if let pa = path{
            self.add(path_key, obj: pa)
            self.add(sourcetree_key, obj: tree.rawValue)
        }else{
            self.add(sourcetree_key, obj: TreeEnum.Absolute.rawValue)
        }
    }
    
    public var children:[String]{
        if !self.containsKey(children_key){
            self.add(children_key, obj: [String]())
        }
        return self.data[children_key] as! [String]
    }
    
    public var name:String?{
        return _data[name_key] as? String
    }
    
    public var path:String?{
        return _data[path_key] as? String
    }
    
    public var sourceTree:String?{
        return _data[sourcetree_key] as? String
    }
    
    public func addChild(child:PBXObject) -> String? {
        guard child is PBXFileReference || child is PBXGroup else{
            return nil
        }
        var chr = self.children
        chr.append(child.guid)
        _data[children_key] = chr
        return child.guid
    }
    
    public func removeChild(cid:String) -> (){
        guard self.dynamicType.isGuid(cid) && self.containsKey(children_key) else{
            return
        }
        var chr = self.children
        if let index = chr.indexOf(cid){
            chr.removeAtIndex(index)
        }
        _data[children_key] = chr
    }
    
    public func hasChild(cid:String) ->Bool {
        guard self.dynamicType.isGuid(cid) && self.containsKey(children_key) else{
            return false
        }
        return self.children.contains(cid)
    }
}

public class PBXVariantGroup : PBXGroup{
    
    public required init(){
        super.init()
    }
}