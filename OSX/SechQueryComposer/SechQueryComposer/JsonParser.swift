//
//  JsonParser.swift
//  SechQueryComposer
//
//  Copyright © 2015 Peter Stoehr. All rights reserved.
//

// Basiert auf SwiftyJSON --- https://github.com/SwiftyJSON/SwiftyJSON
import Foundation

enum JSONData {
    case JSONObject([String:JSONData])
    case JSONArray([JSONData])
    case JSONString(String)
    case JSONNumber(NSNumber)
    case JSONBool(Bool)
    
    var object : [String : JSONData]? {
        switch self {
        case .JSONObject(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var array : [JSONData]? {
        switch self {
        case .JSONArray(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var string : String? {
        switch self {
        case .JSONString(let aData):
            return aData
        default:
            return nil
        }
    }
    
    var integer : Int? {
        switch self {
        case .JSONNumber(let aData):
            return aData.integerValue
        default:
            return nil
        }
    }
    
    var bool: Bool? {
        switch self {
        case .JSONBool(let value):
            return value
        default:
            return nil
        }
    }
    
    subscript(i: Int) -> JSONData? {
        get {
            switch self {
            case .JSONArray(let value):
                return value[i]
            default:
                return nil
            }
        }
    }
    
    subscript(key: String) -> JSONData? {
        get {
            switch self {
            case .JSONObject(let value):
                return value[key]
            default:
                return nil
            }
        }
    }
    
    static func fromObject(object: AnyObject) -> JSONData? {
        switch object {
        case let value as String:
            return JSONData.JSONString(value as String)
        case let value as NSNumber:
            return JSONData.JSONNumber(value)
        case let value as NSDictionary:
            var jsonObject: [String:JSONData] = [:]
            for (key, value) : (AnyObject, AnyObject) in value {
                if let key = key as? String {
                    if let value = JSONData.fromObject(value) {
                        jsonObject[key] = value
                    } else {
                        return nil
                    }
                }
            }
            return JSONData.JSONObject(jsonObject)
        case let value as NSArray:
            var jsonArray: [JSONData] = []
            for v in value {
                if let v = JSONData.fromObject(v) {
                    jsonArray.append(v)
                } else {
                    return nil
                }
            }
            return JSONData.JSONArray(jsonArray)
        default:
            return nil
        }
    }
    
}