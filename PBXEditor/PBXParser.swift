//
//  PBXParser.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/23.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class PBXResolver{
    private var objects:[String:Any]!
    private var rootObject:String!
    private var index = [String:String]()
    
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
    
    public func resolveName(guid:String) -> String{
        guard self.objects.keys.contains(guid) else{
            print("\(self) ResolveName could not resolve \(guid)")
            return ""
        }
        let entity:Any = self.objects[guid]
        switch entity {
        case let en where en is PBXGroup:
            
            break
        default:
            break
        }
        return ""
    }
}
