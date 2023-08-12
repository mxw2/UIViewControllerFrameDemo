//
//  SIPerson.h
//  SharedInstance
//
//  Created by 王鑫 on 16/9/17.
//  Copyright © 2016年 王鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SISingleton.h"
@interface SIPerson : NSObject
@property(copy,nonatomic) NSString *name;
@property(copy,nonatomic) NSString *num;
//SISingletonH(Default)
@end
