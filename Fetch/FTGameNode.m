//
//  FTGameObject.m
//  Fetch
//
//  Created by Jaayden on 1/6/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FTGameNode.h"


@implementation FTGameNode

- (id)initWithImageNamed:(NSString *)name {
    if (self = [super init]) {
        self = [FTGameNode spriteNodeWithImageNamed:name];
    }
    return self;
}



@end
