//
//  VCFrameDefine.h
//  VCFrame
//
//  Created by marsxinwang on 2021/9/15.
//

#ifndef VCFrameDefine_h
#define VCFrameDefine_h


#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* VCFrameDefine_h */
