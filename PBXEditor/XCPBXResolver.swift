//
//  XCPBXResolver.swift
//  PBXEditor
//
//  Created by Jayden Zhao on 15/9/25.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

public class XCPBXResolver:PBXResolver{
    public required init(pbxData:[String:Any]){
        super.init(pbxData:pbxData)
    }
    
    public override func resolveName(guid: String) -> String? {
        guard self.objects.keys.contains(guid) else{
            print("\(self) ResolveName could not resolve \(guid)")
            return  nil
        }
        
        let entity:Any = self.objects[guid]
        if let en = entity as? XCConfigurationList {
            return en.data["defaultConfigurationName"] as? String
        }else if let en = entity as? XCBuildConfiguration{
            return en.data["name"] as? String
        }
        
        return super.resolveName(guid)
    }
}