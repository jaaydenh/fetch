//
//  FTGameObject.m
//  Fetch
//
//  Created by Halko, Jaayden on 3/4/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FTGameObject.h"

@interface FTGameObject() {
    NSDictionary *gameObjectData;
    SKSpriteNode *gameObject;
}

@end

@implementation FTGameObject

- (id)initWithImageNamed:(NSString *)name {
    if (self = [super init]) {
        self.image = name;
    }
    return self;
}

-(void)createWithDictionary: (NSDictionary*) objectData {
    
    gameObjectData = [NSDictionary dictionaryWithDictionary:objectData];

    gameObject = [SKSpriteNode spriteNodeWithImageNamed:[gameObjectData objectForKey:@"englishName"]];
    
    NSArray *positionsArray = [NSArray arrayWithArray:([objectData objectForKey:@"position"])];
    
    _originalPos = CGPointFromString(positionsArray[0]);
    
    self.position = _originalPos;
    
    gameObject.size = CGSizeMake(40.0, 40.0);
    [gameObject setAnchorPoint: CGPointMake(0.5, 0.5)];
    
    self.isInInventory = NO;    
    
    self.englishName = [NSString stringWithString:[objectData objectForKey:@"englishName"]];
    self.spanishName = [NSString stringWithString:[objectData objectForKey:@"spanishName"]];
    self.spanishGender = [NSString stringWithString:[objectData objectForKey:@"spanishGender"]];
    self.spanishPlural = [NSString stringWithString:[objectData objectForKey:@"spanishPlural"]];
    self.objectColor = [NSArray arrayWithArray:([objectData objectForKey:@"color"])];
    self.category = [NSArray arrayWithArray:([objectData objectForKey:@"category"])];
    
    [self addChild:gameObject];
}

@end
