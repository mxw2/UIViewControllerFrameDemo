//
//  AutoReleasePoolTest.h
//  VCFrame
//
//  Created by 马斯 on 2024/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoReleasePoolTest : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

NS_ASSUME_NONNULL_END
