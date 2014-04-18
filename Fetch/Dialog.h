//
//  Dialog.h
//  Fetch
//
//  Created by Halko, Jaayden on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dialog : NSObject

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIImageView *dialogView;

- (id)initWithText:(NSString *)text fontSize:(float)fontSize noteChrome:(UIImage *)img edgeInsets:(UIEdgeInsets)insets maximumWidth:(CGFloat)width topLeftCorner:(CGPoint)corner;

@end
