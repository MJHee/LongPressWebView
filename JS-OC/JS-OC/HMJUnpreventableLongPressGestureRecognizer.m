//
//  HMJUnpreventableLongPressGestureRecognizer.m
//  JS-OC
//
//  Created by MJHee on 16/5/10.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "HMJUnpreventableLongPressGestureRecognizer.h"

@implementation HMJUnpreventableLongPressGestureRecognizer
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}
@end
