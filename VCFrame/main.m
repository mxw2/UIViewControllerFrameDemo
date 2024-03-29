//
//  main.m
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
//        NSObject *object = [[NSObject alloc] init];
//        [object autorelease];
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
