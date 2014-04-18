//
//  Dialog.m
//  Fetch
//
//  Created by Halko, Jaayden on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Dialog.h"

@implementation Dialog

- (id)initWithText:(NSString *)text fontSize:(float)fontSize noteChrome:(UIImage *)img edgeInsets:(UIEdgeInsets)insets maximumWidth:(CGFloat)width topLeftCorner:(CGPoint)corner
{
    
    if (self = [super init]) {
        _text = [NSString stringWithString:text];
        
        UIFont *font = [UIFont boldSystemFontOfSize: fontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName: font};
        
        CGSize computedSize = [text sizeWithAttributes:attributes];
        
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont systemFontOfSize:fontSize];
        textLabel.text = self.text;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        textLabel.frame = CGRectMake(insets.left, insets.top, computedSize.width, computedSize.height);
        _dialogView = [[UIImageView alloc] initWithFrame:CGRectMake(corner.x, corner.y, textLabel.bounds.size.width+insets.left+insets.right, textLabel.bounds.size.height+insets.top+insets.bottom)];
        _dialogView.image = [img resizableImageWithCapInsets:insets];
        
        [_dialogView addSubview:textLabel];
        
        //[self addSubview:_dialogView];
        //SKSpriteNode *test = [[SKSpriteNode alloc] init];
        
        //[self addChild:_dialogView ];
    }
    return self;
}

@end
