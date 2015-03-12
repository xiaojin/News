//
//  News.m
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "News.h"
@implementation News

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = [dict objectForKey:@"title"];
        self.desc = [dict objectForKey:@"description"];
        self.imageHref = [dict objectForKey:@"imageHref"];
        if ((NSNull *)self.desc == [NSNull null]) {
            self.desc = @"";
        }
        if ((NSNull *)self.imageHref == [NSNull null]) {
             self.imageHref = @"";
        }
        
    }
    return self;
}

@end
