//
// Created on 2018/6/19.
//

#import "OPSceneAdaptorCore.h"

@interface OPSceneAdaptorCore ()

@property (nonatomic) NSMutableDictionary<NSNumber *, NSMutableDictionary<NSString *, id> *> *objectDict; // scene: <protocol, class>

@end

@implementation OPSceneAdaptorCore

+ (instancetype)sharedInstance
{
    static OPSceneAdaptorCore *core;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [OPSceneAdaptorCore new];
    });
    return core;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _objectDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerClass:(Class)theClass forProtocol:(Protocol *)theProtocol
{
    NSAssert([theClass conformsToProtocol:theProtocol], @"%@ should confirm to %@", theClass, theProtocol);
    if (![theClass conformsToProtocol:theProtocol]) {
        return;
    }
    
    NSNumber *scene = @0;
    if ([theClass conformsToProtocol:@protocol(OPSceneAdapting)]) {
        scene = @([theClass scene]);
    }
    @synchronized (self.objectDict) {
        NSMutableDictionary *dict = self.objectDict[scene];
        if (!dict) {
            dict = [NSMutableDictionary dictionary];
            self.objectDict[scene] = dict;
        }
        dict[NSStringFromProtocol(theProtocol)] = theClass;
    }
}

- (id)createObjectForProtocol:(Protocol *)theProtocol
{
    NSAssert(self.getCurrentScene, @"需要先设置 getCurrentScene");
    OPScene scene = self.getCurrentScene ? self.getCurrentScene() : OPSceneDefault;
    return [self createObjectForProtocol:theProtocol scene:scene];
}

- (nullable id)createObjectForProtocol:(Protocol *)theProtocol scene:(OPScene)scene
{
    Class cls;
    @synchronized (self.objectDict) {
        cls = self.objectDict[@(scene)][NSStringFromProtocol(theProtocol)];
    }
    if (cls) {
        if ([cls respondsToSelector:@selector(sharedInstance)]) {
            return [cls sharedInstance];
        }
        return [cls new];
    }
    return nil;
}

@end
