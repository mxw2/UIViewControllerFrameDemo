//
//  LGAsyncLabel.m
//  VCFrame
//
//  Created by 马斯 on 2024/4/12.
//

#import "LGAsyncLabel.h"
#import <CoreText/CoreText.h>

@implementation LGAsyncLabel

- (void)displayLayer:(CALayer *)layer {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 异步绘制-子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"当前线程:%@", NSThread.currentThread);
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef contentRef = UIGraphicsGetCurrentContext();
        CGContextSetTextMatrix(contentRef, CGAffineTransformIdentity);
        CGContextTranslateCTM(contentRef, 0, size.height);
        CGContextScaleCTM(contentRef, 1.0, -1.0);
        CGMutablePathRef path = CGPathCreateMutable();
        // frame
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGContextSetFillColorWithColor(contentRef, UIColor.systemPinkColor.CGColor);
        // 拉伸frame
        CGContextAddRect(contentRef, CGRectMake(0, 0, size.width * scale, size.height * scale));
        CGContextFillPath(contentRef);
        
        NSMutableAttributedString *attritedString = [[NSMutableAttributedString alloc] initWithString:@"temp"];
        [attritedString addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:50]
                               range:NSMakeRange(0, 4)];
        [attritedString addAttribute:NSForegroundColorAttributeName
                               value:UIColor.blackColor
                               range:NSMakeRange(0, 4)];
        // 生成CTFrameSetterRef
        CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attritedString);
        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef,
                                                       CFRangeMake(0, attritedString.length),
                                                       path,
                                                       NULL);
        CTFrameDraw(frameRef, contentRef);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id)image.CGImage;
        });
    });
}

@end
