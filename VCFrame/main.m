//
//  main.m
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

static CFAbsoluteTime __startProcessTime = 0.f; // 进程创建时间
void processStartTime(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct kinfo_proc kProcInfo;
        int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, [[NSProcessInfo processInfo] processIdentifier]};
        size_t size = sizeof(kProcInfo);
        
        __startProcessTime = 0.f;
        if (sysctl(cmd, sizeof(cmd)/sizeof(*cmd), &kProcInfo, &size, NULL, 0) == 0) {
            NSUInteger startTime = kProcInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000.0 + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0;
            
            /// 处理成相对于2001/01/01 00:00:00的绝对时间戳，以便与CFAbsoluteTimeGetCurrent()时间戳相对应
            NSCalendar * calendar = [NSCalendar currentCalendar];
            calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            NSDate *date = [calendar dateWithEra:1
                                            year:2001
                                           month:1
                                             day:1
                                            hour:0
                                          minute:0
                                          second:0
                                      nanosecond:0];
            NSTimeInterval interval = [date timeIntervalSince1970];
            __startProcessTime = startTime - interval * 1000;
            NSLog(@"_startProcessTime = %f", __startProcessTime);
        }
    });
 }

static uint64_t loadTime;
__attribute__((constructor)) static void recordLoadTime(void) {
    loadTime = mach_absolute_time();
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
//        processStartTime();
//        double diff = CFAbsoluteTimeGetCurrent() * 1000 - __startProcessTime;
        
        uint64_t mainTime = mach_absolute_time();
        uint64_t preMainTime = mainTime - loadTime;
        NSLog(@"preMainTime = %llu", preMainTime);
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
