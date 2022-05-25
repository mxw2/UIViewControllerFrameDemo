//
// Created on 2018/6/19.
//

#import <Foundation/Foundation.h>
#import "OPSceneAdapting.h"

#define OP_ADAPTOR_OBJECT(theProtocol) \
    ((id<theProtocol>)[[OPSceneAdaptorCore sharedInstance] createObjectForProtocol:@protocol(theProtocol)])
#define OP_SCENE_ADAPTOR_OBJECT(theScene, theProtocol) \
    ((id<theProtocol>)[[OPSceneAdaptorCore sharedInstance] createObjectForProtocol:@protocol(theProtocol) scene:theScene])

NS_ASSUME_NONNULL_BEGIN

@interface OPSceneAdaptorCore : NSObject

@property (nonatomic, copy) OPScene (^getCurrentScene)(void);

+ (instancetype)sharedInstance;

- (void)registerClass:(Class)theClass forProtocol:(Protocol *)theProtocol;

/**
 Create the instance of `theClass` that tied to `theProtocol` by `registerClass:forProtocol:` for current scene.
 
 @important
 Use this for most of cases.
 
 @param theProtocol the protocol to create instance
 @return the instance of `theClass` tied to the protocol
 */
- (id)createObjectForProtocol:(Protocol *)theProtocol;

/**
 Create the instance of `theClass` that tied to `theProtocol` by `registerClass:forProtocol:` for `scene`

 @param theProtocol the protocol to create instance
 @param scene OPScene enum
 @return the instance of `theClass` tied to the protocol
 */
- (nullable id)createObjectForProtocol:(Protocol *)theProtocol scene:(OPScene)scene;

@end

NS_ASSUME_NONNULL_END
