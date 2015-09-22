//: Playground - noun: a place where people can play

import Cocoa

import PBXEditor

var test = PBXNativeTarget(guid: "DEEFFEEFEFEEFEFEFEFEFEFE", dictonary: ["isa":"PBXObject"])


print(test)
var data = [String:PBXObject]()

data.append(["1234":test])
//test.data.append(["fgt":test])
//test.data