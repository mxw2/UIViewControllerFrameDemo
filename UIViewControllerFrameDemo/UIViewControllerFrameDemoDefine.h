//
//  UIViewControllerFrameDemoDefine.h
//  UIViewControllerFrameDemo
//
//  Created by marsxinwang on 2021/9/15.
//

#ifndef UIViewControllerFrameDemoDefine_h
#define UIViewControllerFrameDemoDefine_h


#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* UIViewControllerFrameDemoDefine_h */
