//
//  MyScene.m
//  Fetch
//
//  Created by Jaayden on 10/18/13.
//  Copyright (c) 2013 partytroll. All rights reserved.
//

#import "GameScene.h"
#import "FTGameNode.h"
#import "SKTUtils.h"
#import "FTQuestion.h"
#import "FTGameObject.h"
#import "NSMutableArray+Shuffling.h"
#import "Dialog.h"

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) FTGameObject *selectedNode;
@property (assign) CGPoint touchPoint;
@property (nonatomic, strong) NSMutableArray *gameNodes;
@property (nonatomic, strong) NSMutableArray *gameObjects;
@property (nonatomic, strong) NSMutableArray *inventorySlots;
@property (nonatomic, strong) NSMutableArray *questions;
@property (assign) int originalX;
@property (assign) int secondsLeft;
@property (assign) int seconds;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SKSpriteNode *character;
@property (assign) int questionNumber;
@property (assign) int score;

@end

@implementation GameScene

SKLabelNode *timerLabel;
SKLabelNode *questionLabel;
SKLabelNode *scoreLabel;
int originalY;
int selectedInventoryX;
int selectedInventoryY;
CGRect slot1;
CGRect slot2;
CGRect slot3;
CGRect slot4;
CGRect slot5;
CGRect slot6;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"kitchen"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];

        [self addChild:_background];
        
        [self setupScene];
        [self initInventory];
        [self loadGameObjects];
        [self generateQuestions];
        _questionNumber = 0;
        _score = 0;
        [self displayQuestion];

        
        timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        timerLabel.text = @"60";
        timerLabel.fontSize = 30;
        timerLabel.position = CGPointMake(25, CGRectGetHeight(self.frame) - 25);
        [self addChild:timerLabel];
        
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = @"0";
        scoreLabel.fontSize = 30;
        scoreLabel.position = CGPointMake(535, CGRectGetHeight(self.frame) - 25);
        [self addChild:scoreLabel];
        
        _character = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        _character.size = CGSizeMake(80.0, 150.0);
        [_character setPosition:CGPointMake(CGRectGetMidX(self.frame) - 120, CGRectGetHeight(self.frame) - 25)];
        [self addChild:_character];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        _secondsLeft = 60;
        [self countdownTimer];
    }
    return self;
}

- (void)setupScene {

}

- (void)displayQuestion {
    questionLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    FTQuestion *question = [_questions objectAtIndex:_questionNumber];
    //UIImage *bubbleImage = [UIImage imageNamed:@"speech-bubble"];
    //UIEdgeInsets edgeInsets = UIEdgeInsetsMake(37, 12, 12, 12);
    
    //Dialog *questionBubble = [[Dialog alloc] initWithText:question.questionText fontSize:30 noteChrome:bubbleImage edgeInsets:edgeInsets maximumWidth:200 topLeftCorner:CGPointMake(200,10)];

    //[questionBubble setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 25)];
    //[self addChild:questionBubble];
    
    //SKSpriteNode *test = [SKSpriteNode spriteNodeWithImageNamed:@"speech-bubble"];
    //test.size = CGSizeMake(100.0, 42.0);
    //[test setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - 25)];
    //[self addChild:test];
    
    questionLabel.text = question.questionText;
    questionLabel.fontSize = 20;
    questionLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 10, CGRectGetHeight(self.frame) - 25);
    /*UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:20    ];
    textLabel.text = @"test";
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.frame = CGRectMake(50, 50, 100, 100);*/
//    [self.view addSubview:textLabel];
    //[self.view addSubview:questionBubble.dialogView];
    [self addChild:questionLabel];
}

- (void)didMoveToView:(SKView *)view {

}

- (void)willMoveFromView:(SKView *) view {
    NSLog(@"Scene moved from view");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    for (UITouch *touch in touches) {
        CGPoint positionInScene = [touch locationInNode:self];
        
        for (FTGameObject *gameObject in _gameObjects) {
            if ([gameObject containsPoint:positionInScene]) {
                _selectedNode = gameObject;
                _touchPoint = positionInScene;
                //_selectedNode.size = CGSizeMake(_selectedNode.size.width * 1.3, _selectedNode.size.height * 1.3);
                _selectedNode.xScale = (float)1.3;
                _selectedNode.yScale = (float)1.3;
                //NSLog(@"Selected Node: %@", [gameNode name]);
                break;
            }
        }
        
        if ([_character containsPoint:positionInScene]) {
            [self checkAnswer];
        }
    }
}

- (void)checkAnswer {
    FTQuestion *question = [_questions objectAtIndex:_questionNumber];
    //int correctCount = 0;
    //int incorrectCount = 0;
    
    /*for (NSString *answer in question.answers){
        for (FTGameObject *gameNode in _gameObjects) {
            if (gameNode.isInInventory) {
                if ([gameNode.englishName isEqualToString:answer]) {
                    gameNode.isCorrect = YES;
                    correctCount++;
                } else {
                    incorrectCount++;
                }
            }
        }
    }*/
    
    NSMutableArray *inventoryArray = [[NSMutableArray alloc] init];
    
    for (FTGameObject *gameNode in _gameObjects) {
        if (gameNode.isInInventory) {
            [inventoryArray addObject:gameNode.englishName];
        }
    }
    
    NSSet *set1 = [NSSet setWithArray:question.answers];
    NSSet *set2 = [NSSet setWithArray:inventoryArray];
    
    if ([set1 isEqualToSet:set2]) {
    
    //if (correctCount == question.answers.count && incorrectCount == 0) {
        NSLog(@"Correct");
        
        _questionNumber++;
        if (_questionNumber >= _questions.count) {
            _questionNumber = 0;
        }
        question = [_questions objectAtIndex:_questionNumber];
        questionLabel.text = question.questionText;
        
        _score++;
        scoreLabel.text = [NSString stringWithFormat:@"%d", _score];
        
        for (FTGameObject *gameNode in _gameObjects) {
            if (gameNode.isInInventory) {
                NSString *burstPath = [[NSBundle mainBundle] pathForResource:@"BurstParticle" ofType:@"sks"];
                SKEmitterNode *particles = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
                particles.position = CGPointMake(gameNode.position.x, gameNode.position.y);
                [gameNode runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:.1],
                                                         [SKAction waitForDuration:0.5],
                                                          [SKAction fadeAlphaTo:1 duration:.3]]]];
                [self addChild:particles];
                
                SKAction *moveTo = [SKAction moveTo:gameNode.originalPos duration:0.3];
                [moveTo setTimingMode:SKActionTimingEaseIn];
                [gameNode runAction:moveTo];
                gameNode.isInInventory = NO;
            }
        }
        
        //[self resetInventoryColor];
    } else {
        NSLog(@"Incorrect");
        for (FTGameObject *gameNode in _gameObjects) {
            if (gameNode.isInInventory && !gameNode.isCorrect) {
                [gameNode runAction:[SKAction sequence:@[[SKAction moveByX:5 y:0 duration:.1],
                                                         [SKAction moveByX:-10 y:0 duration:.1],
                                                         [SKAction moveByX:10 y:0 duration:.1],
                                                         [SKAction moveByX:-5 y:0 duration:.1]]]];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchPoint = [[touches anyObject] locationInNode:self];
    
    /*if (CGRectContainsPoint(slot1, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[0] runAction:test];
    } else if (CGRectContainsPoint(slot2, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[1] runAction:test];
    } else if (CGRectContainsPoint(slot3, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[2] runAction:test];
    } else if (CGRectContainsPoint(slot4, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[3] runAction:test];
    } else if (CGRectContainsPoint(slot5, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[4] runAction:test];
    } else if (CGRectContainsPoint(slot6, _touchPoint)) {
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [_inventorySlots[5] runAction:test];
    } else {
        [self resetInventoryColor];
    }*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_selectedNode)
    {
        CGPoint currentPoint = [[touches anyObject] locationInNode:self];
        
        CGRect slot1Big = CGRectMake(slot1.origin.x, slot1.origin.y - 10, slot1.size.width, slot1.size.height + 20);
        CGRect slot2Big = CGRectMake(slot2.origin.x, slot2.origin.y - 10, slot2.size.width, slot2.size.height + 20);
        CGRect slot3Big = CGRectMake(slot3.origin.x, slot3.origin.y - 10, slot3.size.width, slot3.size.height + 20);
        CGRect slot4Big = CGRectMake(slot4.origin.x, slot4.origin.y - 10, slot4.size.width, slot4.size.height + 20);
        CGRect slot5Big = CGRectMake(slot5.origin.x, slot5.origin.y - 10, slot5.size.width, slot5.size.height + 20);
        CGRect slot6Big = CGRectMake(slot6.origin.x, slot6.origin.y - 10, slot6.size.width, slot6.size.height + 20);
        
        if (CGRectContainsPoint(slot1Big, currentPoint)) {
            [self moveObjectToInventory:slot1];
            
        } else if (CGRectContainsPoint(slot2Big, currentPoint)) {
            [self moveObjectToInventory:slot2];
            
        } else if (CGRectContainsPoint(slot3Big, currentPoint)) {
            [self moveObjectToInventory:slot3];
            
        } else if (CGRectContainsPoint(slot4Big, currentPoint)) {
            [self moveObjectToInventory:slot4];
            
        } else if (CGRectContainsPoint(slot5Big, currentPoint)) {
            [self moveObjectToInventory:slot5];
            
        } else if (CGRectContainsPoint(slot6Big, currentPoint)) {
            [self moveObjectToInventory:slot6];
            
        } else {
            SKAction *moveTo = [SKAction moveTo:_selectedNode.originalPos duration:0.3];
            [moveTo setTimingMode:SKActionTimingEaseIn];
            [_selectedNode runAction:moveTo];
            _selectedNode.isInInventory = NO;
        }
        
        //_selectedNode.size = CGSizeMake(_selectedNode.size.width / 1.3, _selectedNode.size.height / 1.3);
        _selectedNode.xScale = (float)1.0;
        _selectedNode.yScale = (float)1.0;
        _selectedNode = nil;
    }
}

- (void)resetInventoryColor {
    for (SKSpriteNode *node in _inventorySlots) {
        UIColor *color = [UIColor colorWithRed:(120.0) green:(120.0) blue:(120.0) alpha:1];
        
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [node runAction:test];
    }
}

- (void)initInventory {
    _inventorySlots = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 6; ++i) {
        SKSpriteNode *inventorySlot = [SKSpriteNode spriteNodeWithImageNamed:@"inventorySlot"];
        inventorySlot.size = CGSizeMake(40.0, 40.0);
        [inventorySlot setAnchorPoint:CGPointMake(0.0, 0.0)];
        
        float offset = (float)i;
        [inventorySlot setPosition:CGPointMake((inventorySlot.size.width + 5) * offset + 50, 10)];
        [_inventorySlots addObject:inventorySlot];
        [_background addChild:inventorySlot];
        
        if (i == 0) {
            slot1 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        } else if (i == 1) {
            slot2 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        } else if (i == 2) {
            slot3 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        } else if (i == 3) {
            slot4 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        } else if (i == 4) {
            slot5 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        } else if (i == 5) {
            slot6 = CGRectMake(inventorySlot.position.x, inventorySlot.position.y, 40.0, 40.0);
        }
    }
}

- (void)loadGameObjects {
    // load x number of objects into scene
    // objects should be atleast x pixels from all other objects
    // objects can have more than one possible placement positions
    // 1. get array of all possible objects for a scene
    
    NSString* path = [[ NSBundle mainBundle] bundlePath];
    NSString* finalPath = [ path stringByAppendingPathComponent:@"GameData.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    NSDictionary *scenes = [NSDictionary dictionaryWithDictionary:[plistData objectForKey:@"Scenes"]];
    
    NSArray *gameObjectArray = [NSArray arrayWithArray:[scenes objectForKey:@"Kitchen"]];
    
    _gameObjects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *gameObjectDictionary in gameObjectArray) {
        //FTGameObject *gameObject = [FTGameObject node];
        FTGameObject *gameObject = [[FTGameObject alloc] initWithImageNamed:[gameObjectDictionary objectForKey:@"englishName"]];
        [gameObject createWithDictionary:gameObjectDictionary];
        
        [_gameObjects addObject:gameObject];
        [_background addChild:gameObject];
    }
    
    
    // 2. place object at a randomly selected position out of the possible placement positions for that object
    // 3. Check that object is not too close to other objects, if it is try a different position else skip this object
}

- (void)generateQuestions {
    _questions = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *colorDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *categoryDictionary = [[NSMutableDictionary alloc] init];
    
    for (FTGameObject *object in _gameObjects) {
        
        // color questions
        for (id color in object.objectColor) {
            NSMutableArray *colorAnswers = [colorDictionary objectForKey:color];
            
            if (colorAnswers) {
                [colorAnswers addObject:object.englishName];
                [colorDictionary setObject:colorAnswers forKey:color];
            } else {
                colorAnswers = [[NSMutableArray alloc] init];
                [colorAnswers addObject:object.englishName];
                [colorDictionary setObject:colorAnswers forKey:color];
            }
        }
        
        // category questions
        for (id category in object.category) {
            NSMutableArray *categoryAnswers = [categoryDictionary objectForKey:category];
            
            if (categoryAnswers) {
                [categoryAnswers addObject:object.englishName];
                [categoryDictionary setObject:categoryAnswers forKey:category];
            } else {
                categoryAnswers = [[NSMutableArray alloc] init];
                [categoryAnswers addObject:object.englishName];
                [categoryDictionary setObject:categoryAnswers forKey:category];
            }
        }
        
        NSString *questionText = [NSString stringWithFormat:@"Find a %@", object.englishName];
        NSArray *answers = [[NSArray alloc] initWithObjects:object.englishName, nil];
        FTQuestion *question = [[FTQuestion alloc] initWithQuestion:questionText andAnswers:answers];
        [_questions addObject:question];
    }
    
    for (NSString *key in colorDictionary) {
        NSMutableArray *value = [colorDictionary objectForKey:key];
        NSString *plural = @"";
        if (value.count > 1) {
            plural = @"s";
        }
        NSString *questionText = [NSString stringWithFormat:@"Find %lu %@ thing%@", (unsigned long)value.count, key, plural];
        FTQuestion *question = [[FTQuestion alloc] initWithQuestion:questionText andAnswers:value];
        [_questions addObject:question];
    }
    
    for (NSString *key in categoryDictionary) {
        NSMutableArray *value = [categoryDictionary objectForKey:key];
        NSString *plural = @"";
        if (value.count > 1) {
            plural = @"s";
        }
        NSString *questionText = [NSString stringWithFormat:@"Find %lu %@%@", (unsigned long)value.count, key, plural];
        FTQuestion *question = [[FTQuestion alloc] initWithQuestion:questionText andAnswers:value];
        [_questions addObject:question];
    }
    
    [_questions shuffle];
}

- (void)update:(CFTimeInterval)currentTime {

    if (_selectedNode) {
        _touchPoint.x = Clamp(_touchPoint.x, _selectedNode.frame.size.width / 2, self.size.width - _selectedNode.frame.size.width / 2);
        _touchPoint.y = Clamp(_touchPoint.y, _selectedNode.frame.size.height / 2, self.size.height - _selectedNode.frame.size.height / 2);
        _selectedNode.position = _touchPoint;
    }
}

- (void)moveObjectToInventory:(CGRect)position {
    SKAction *moveTo = [SKAction moveTo:CGPointMake(position.origin.x + position.size.width / 2, position.origin.y + position.size.height / 2) duration:0.1];
    [moveTo setTimingMode:SKActionTimingEaseIn];
    _selectedNode.isInInventory = YES;
    [_selectedNode runAction:moveTo];
    
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(_secondsLeft > 0 ){
        _secondsLeft-- ;
        timerLabel.text = [NSString stringWithFormat:@"%d", _secondsLeft];
    }
    else{
        _secondsLeft = 60;
    }
}

-(void)countdownTimer{
    _secondsLeft = _seconds = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

@end
