//
//  helper.h
//  libevent-helper
//
//  Created by 林達也 on 2016/01/08.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <evhttp.h>

struct evhttp_request;

 NSDictionary<NSString *, NSString *> * _Nonnull http_request_get_input_headers(struct evhttp_request  * _Nonnull req);
