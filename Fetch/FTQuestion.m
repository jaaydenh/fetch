//
//  FTQuestion.m
//  Fetch
//
//  Created by Halko, Jaayden on 3/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FTQuestion.h"

@implementation FTQuestion


- (id)initWithQuestion:(NSString*)question andAnswers:(NSArray*)answers {
    if  (self = [super init]) {
        self.questionText = question;
        self.answers = answers;
    }
    return self;
}


@end
