//
//  main.swift
//  Demo
//
//  Created by 林達也 on 2016/01/09.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import Foundation
import libevent
import libevent_helper

let HTTPD_ADDR = "0.0.0.0"
let HTTPD_PORT: UInt16 = 8081

func empty<T>(count: Int, repeatedValue: T) -> [T] {
    return Array<T>(count: count, repeatedValue: repeatedValue)
}

func req_handler(req: UnsafeMutablePointer<evhttp_request>, arg: UnsafeMutablePointer<Void>) {
    
    let evbuf = evbuffer_new()
    if evbuf == nil {
        evhttp_send_error(req, HTTP_SERVUNAVAIL, "Failed to create buffer")
        return
    }
    
    let conn = evhttp_request_get_connection(req)
    var address: UnsafeMutablePointer<Int8> = nil
    var port: UInt16 = 0
    evhttp_connection_get_peer(conn, &address, &port)
    print(String.fromCString(address), port)
    
    let uri = evhttp_request_get_evhttp_uri(req)
    print(String.fromCString(evhttp_uri_get_scheme(uri)))
    print(String.fromCString(evhttp_request_get_host(req)))
    print(req.memory.remote_port)
    print(String.fromCString(req.memory.uri))
    print(String.fromCString(req.memory.remote_host))
    print(req.memory.response_code)
    print(String.fromCString(evhttp_request_get_uri(req)))
    
    
    
    let method = Method(cmd: evhttp_request_get_command(req))
    print(method)
    
    let headers = http_request_get_input_headers(req)
    for (k, v) in headers {
        print(k, v)
    }
    
    print("-----")
    let input_buf = evhttp_request_get_input_buffer(req)
    while evbuffer_get_length(input_buf) > 0 {
        var copied = Array<CChar>(count: 128, repeatedValue: 0)
        let n = evbuffer_remove(input_buf, &copied, 128)
        if n > 0 {
            fwrite(copied, 1, Int(n), stdout)
        }
    }
    print("-----")
    
    let message = "Hello world😀"
    evhttp_add_header(req.memory.output_headers, "Content-Type", "text/plain")
    evhttp_add_header(req.memory.output_headers, "Content-Length", "\(message.utf8.count)")
    evbuffer_add(evbuf, message, message.utf8.count)
    evhttp_send_reply(req, HTTP_OK, "", evbuf)
    evbuffer_free(evbuf)
}


let ev_base = event_base_new()
let httpd = evhttp_new(ev_base)

if evhttp_bind_socket(httpd, HTTPD_ADDR, HTTPD_PORT) < 0 {
    perror("evhttp_bind_socket()")
    exit(EXIT_FAILURE)
}

evhttp_set_gencb(httpd, req_handler, nil)
event_base_dispatch(ev_base)
evhttp_free(httpd)
event_base_free(ev_base)

