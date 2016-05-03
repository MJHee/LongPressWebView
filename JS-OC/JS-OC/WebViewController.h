//
//  WebViewController.h
//  JS-OC
//
//  Created by MJHee on 16/4/20.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
} GesStateType;

@interface WebViewController : UIViewController
@end
