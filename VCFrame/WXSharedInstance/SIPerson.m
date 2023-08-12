//
//  SIPerson.m
//  SharedInstance
//
//  Created by 王鑫 on 16/9/17.
//  Copyright © 2016年 王鑫. All rights reserved.
//

#import "SIPerson.h"

@implementation SIPerson

//SISingletonM(Default)

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"SIPerson init");
    }
    return self;
}

- (void)dealloc {
    NSLog(@"SIPerson dealloc");
}

@end
