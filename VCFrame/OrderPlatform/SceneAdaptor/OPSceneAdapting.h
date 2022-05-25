//
// Created on 2018/6/19.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OPScene) {
    OPSceneDefault,
    OPSceneRetail,
};

@protocol OPSceneAdapting <NSObject>

@property (nonatomic, class, readonly) OPScene scene;

@optional

+ (instancetype)sharedInstance;

@end
