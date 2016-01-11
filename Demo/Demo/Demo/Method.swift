//
//  Method.swift
//  Demo
//
//  Created by 林達也 on 2016/01/10.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation

public enum Method {
    case GET
    case POST
    case HEAD
    case PUT
    case DELETE
    case OPTIONS
    case TRACE
    case CONNECT
    case PATCH
    
    case UNKNOWN(Int)
}

extension Method: Hashable {
    
    public var hashValue: Int {
        return description.hashValue
    }
}

public func ==(lhs: Method, rhs: Method) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

extension Method: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        case .HEAD: return "HEAD"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        case .OPTIONS: return "OPTIONS"
        case .TRACE: return "TRACE"
        case .CONNECT: return "CONNECT"
        case .PATCH: return "PATCH"
        case .UNKNOWN: return "UNKNOWN"
        }
    }
}

import libevent

extension Method {
    
    init(cmd: evhttp_cmd_type) {
        switch cmd {
        case EVHTTP_REQ_GET: self = .GET
        case EVHTTP_REQ_POST: self = .POST
        case EVHTTP_REQ_HEAD: self = .HEAD
        case EVHTTP_REQ_PUT: self = .PUT
        case EVHTTP_REQ_DELETE: self = .DELETE
        case EVHTTP_REQ_OPTIONS: self = .OPTIONS
        case EVHTTP_REQ_TRACE: self = .TRACE
        case EVHTTP_REQ_CONNECT: self = .CONNECT
        case EVHTTP_REQ_PATCH: self = .PATCH
        default: self = .UNKNOWN(Int(cmd.rawValue))
        }
    }
}
