//
//  helper.m
//  libevent-helper
//
//  Created by 林達也 on 2016/01/08.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

#import "helper.h"
#import <evhttp.h>

NSDictionary<NSString *, NSString *> *http_request_get_input_headers(struct evhttp_request *req)
{
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    struct evkeyvalq *headers = evhttp_request_get_input_headers(req);
    for (struct evkeyval *header = headers->tqh_first; header; header = header->next.tqe_next) {
        NSString *key = [NSString stringWithUTF8String:header->key];
        NSString *value = [NSString stringWithUTF8String:header->value];
        dict[key] = value;
    }

    return dict;
}

