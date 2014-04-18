//
//  FTQuestion.h
//  Fetch
//
//  Created by Halko, Jaayden on 3/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTQuestion : NSObject

@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSArray *answers;

- (id)initWithQuestion:(NSString*)question andAnswers:(NSArray*)answers;

@end
