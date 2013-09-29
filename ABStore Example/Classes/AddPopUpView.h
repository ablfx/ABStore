//
//  AddPopUpView.h
//  ABStore Example
//
//  Created by Alexander Blunck on 9/28/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPopUpView : UIView

//Show / Hide
-(void) showWithCompletion:(void(^)(NSString *text))block;

@end
