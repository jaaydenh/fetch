//
//  FTGameObject.h
//  Fetch
//
//  Created by Halko, Jaayden on 3/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FTGameObject : SKNode

@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) CGPoint position;

@property CGPoint originalPos;
@property (nonatomic, strong) NSString *englishName;
@property (nonatomic, strong) NSString *spanishName;
@property (nonatomic, strong) NSString *spanishGender;
@property (nonatomic, strong) NSString *spanishPlural;
@property (nonatomic, strong) NSArray *objectColor;
@property (nonatomic, strong) NSArray *category;
@property (assign) BOOL isInInventory;
@property (assign) BOOL isCorrect;

- (id)initWithImageNamed:(NSString*)name;
- (void)createWithDictionary:(NSDictionary*) objectData;

@end
