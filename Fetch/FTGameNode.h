//
//  FTGameObject.h
//  Fetch
//
//  Created by Jaayden on 1/6/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FTGameNode : SKSpriteNode

@property CGPoint originalPos;
@property (nonatomic, strong) NSString *englishName;
@property (nonatomic, strong) NSString *spanishName;
@property (nonatomic, strong) NSString *objectColor;
@property (assign) BOOL isInInventory;
@property (assign) BOOL isCorrect;

@end
