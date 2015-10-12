//
//  main.swift
//  PBXSample
//
//  Created by jayden on 15/10/11.
//  Copyright © 2015年 jayden. All rights reserved.
//

import Foundation

var proj = XCProject(filePath: "/Users/jayden/Documents/WorkSpace/XCodeProject/PassbookCard/PassbookDemo.xcodeproj")

//print(proj.buildConfiguration)
proj.addHeaderSearchPath("122113131")
proj.addOtherCFlag("45678")
//print(proj.groups)
print(proj.buildConfiguration)

