//: Playground - noun: a place where people can play

import Cocoa

import PBXEditor

var test = PBXNativeTarget(guid: "DEEFFEEFEFEEFEFEFEFEFEFE", dictonary: ["isa":"PBXObject"])


print(test)
var data = [String:Any]()

data.append(["isa":"PBXObject"])

var objects = [String:PBXObject](dictionary: ["dic":data])
objects["dic"]

var dataes = [String:String]()

var stream = [[String:String]]()

stream.append(dataes)

dataes["123"] = "34567677"
dataes

stream

