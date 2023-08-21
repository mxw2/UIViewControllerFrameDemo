//
//  MyPoint.h
//  VCFrame
//
//  Created by 马斯 on 2023/8/20.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class MyPoint;

@protocol MyPointExport <JSExport>

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

- (void)description;
- (MyPoint *)makePointerWithX:(double)x y:(double)y;
 
@end

@interface MyPoint : NSObject <MyPointExport>

@end

NS_ASSUME_NONNULL_END
