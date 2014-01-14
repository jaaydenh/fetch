//
//  MyScene.m
//  Fetch
//
//  Created by Jaayden on 10/18/13.
//  Copyright (c) 2013 partytroll. All rights reserved.
//

#import "GameScene.h"
#import "FTGameNode.h"

static NSString * const kObjectName = @"movable";
static const uint32_t objectCategory     =  0x1 << 0;
static const uint32_t inventoryCategory        =  0x1 << 1;

@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) FTGameNode *selectedNode;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
//@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;       // dynamic animator

@end

@implementation GameScene

int originalX;
int originalY;
int selectedInventoryX;
int selectedInventoryY;
CGRect slot1;
CGRect slot2;
CGRect slot3;
CGRect slot4;
CGRect slot5;
CGRect slot6;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background1"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];

        [self addChild:_background];
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        //SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        //myLabel.text = @"Hello, World!";
        //myLabel.fontSize = 30;
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        //[self addChild:myLabel];
        
        for(int i = 0; i < 6; ++i) {
            SKSpriteNode *inventorySlot = [SKSpriteNode spriteNodeWithImageNamed:@"inventorySlot"];
            inventorySlot.size = CGSizeMake(40.0, 40.0);
            inventorySlot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:inventorySlot.size]; // 1
            inventorySlot.physicsBody.dynamic = YES; // 2
            inventorySlot.physicsBody.categoryBitMask = inventoryCategory; // 3
            inventorySlot.physicsBody.contactTestBitMask = objectCategory; // 4
            inventorySlot.physicsBody.collisionBitMask = 0; // 5
            
            float offset = (float)i;
            [inventorySlot setPosition:CGPointMake((inventorySlot.size.width + 5) * offset + 80, 30)];
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
        
        [self layoutGameObjects];

        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
  //  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //[[self view] addGestureRecognizer:tapGestureRecognizer];
    
    _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:_gestureRecognizer];
}

- ( void ) willMoveFromView: (SKView *) view {
    
    NSLog(@"Scene moved from view");
    [[self view] removeGestureRecognizer: _gestureRecognizer ];
    
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}*/

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    FTGameNode *touchedNode = (FTGameNode *)[self nodeAtPoint:touchLocation];
    
    //2
	//if(![_selectedNode isEqual:touchedNode]) {
		[_selectedNode removeAllActions];
		//[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
        
		_selectedNode = touchedNode;
		//3
		if([[touchedNode name] isEqualToString:kObjectName]) {
            _selectedNode.size = CGSizeMake(_selectedNode.size.width * 1.5, _selectedNode.size.height * 1.5);
			//SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
			//										  [SKAction rotateByAngle:0.0 duration:0.1],
			//										  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			//[_selectedNode runAction:[SKAction repeatActionForever:sequence]];
		}
	//}
    
}

float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}

CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}

-(void)loadGameObjects {
    
}

-(void)layoutGameObjects {
    // Pass in list of images for a level based on difficulty
    // images should have coordinates, difficulty and category, color, names for each language
    // generate questions for a level based on images

    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Objects"];
    
    NSArray *imageNames = @[@"clock", @"computer", @"orange", @"toaster"];
    for(int i = 0; i < [imageNames count]; ++i) {
        NSString *imageName = [imageNames objectAtIndex:i];
        //FTGameNode *object = [FTGameNode spriteNodeWithImageNamed:imageName];
        FTGameNode *object = [FTGameNode spriteNodeWithTexture:[atlas textureNamed:imageName]];
        [object setName:kObjectName];
        object.size = CGSizeMake(40.0, 40.0);
        object.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:object.size]; // 1
        object.physicsBody.dynamic = YES; // 2
        object.physicsBody.categoryBitMask = objectCategory; // 3
        object.physicsBody.contactTestBitMask = inventoryCategory; // 4
        object.physicsBody.collisionBitMask = 0; // 5
        object.physicsBody.usesPreciseCollisionDetection = YES;
        
        [object setAnchorPoint: CGPointMake(0.5, 0.5)];
        
        float offsetFraction = ((float)(i + 1)) / ([imageNames count] + 1);
        [object setPosition:CGPointMake(300 * offsetFraction, 150)];
        object.originalPos = object.position;
        [_background addChild:object];
    }
}

-(void)generateQuestions {
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -[_background size].width+ winSize.width);
    retval.y = [self position].y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:kObjectName]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
    } else {
        CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
        [_background setPosition:[self boundLayerPos:newPos]];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    //if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        [self selectNodeForTouch:touchLocation];
    //}
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        [self selectNodeForTouch:touchLocation];
        originalX = _selectedNode.position.x;
        originalY = _selectedNode.position.y;
        NSLog(@"Pan begin X: %f, Y: %f", _selectedNode.position.x, _selectedNode.position.y);
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self panForTranslation:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (![[_selectedNode name] isEqualToString:kObjectName]) {
            
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = [_selectedNode position];
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            newPos = [self boundLayerPos:newPos];
            [_selectedNode removeAllActions];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            [_selectedNode runAction:moveTo];
        } else {
            _selectedNode.size = CGSizeMake(_selectedNode.size.width / 1.5, _selectedNode.size.height / 1.5);
            
            CGPoint currentPos = CGPointMake(_selectedNode.position.x + 20, _selectedNode.position.y + 20);
            
            if (CGRectContainsPoint(slot1, currentPos)) {
                [self moveObject:slot1.origin];

            } else if (CGRectContainsPoint(slot2, currentPos)) {
                [self moveObject:slot2.origin];
                
            } else if (CGRectContainsPoint(slot3, currentPos)) {
                [self moveObject:slot3.origin];
                
            } else if (CGRectContainsPoint(slot4, currentPos)) {
                [self moveObject:slot4.origin];
                
            } else if (CGRectContainsPoint(slot5, currentPos)) {
                [self moveObject:slot5.origin];
                
            } else if (CGRectContainsPoint(slot6, currentPos)) {
                [self moveObject:slot6.origin];
                
            } else {
                CGPoint newPos = CGPointMake(originalX, originalY);
                
                SKAction *moveTo = [SKAction moveTo:_selectedNode.originalPos duration:0.3];
                [moveTo setTimingMode:SKActionTimingEaseIn];
                [_selectedNode runAction:moveTo];
            }
            

            
            NSLog(@"Pan end X: %f, Y: %f", _selectedNode.position.x, _selectedNode.position.y);
        }
        
    }
}

- (void)moveObject:(CGPoint)position {
    SKAction *moveTo = [SKAction moveTo:position duration:0.3];
    [moveTo setTimingMode:SKActionTimingEaseIn];
    [_selectedNode runAction:moveTo];
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & objectCategory) != 0 &&
        (secondBody.categoryBitMask & inventoryCategory) != 0)
    {
        //[self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        NSLog(@"End Contact");
        //secondBody.node.xScale = 2.0;
        //secondBody.node.yScale = 2.0;
        UIColor *color = [UIColor colorWithRed:(120.0) green:(120.0) blue:(120.0) alpha:1];
        
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.0];
        [secondBody.node runAction:test];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & objectCategory) != 0 &&
        (secondBody.categoryBitMask & inventoryCategory) != 0)
    {
        //[self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        NSLog(@"Begin Contact");
        //secondBody.node.xScale = 2.0;
        //secondBody.node.yScale = 2.0;
        UIColor *color = [UIColor colorWithRed:(0.0) green:(255.0) blue:(0.0) alpha:1];
        
        SKAction *test = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:0.5];
        [secondBody.node runAction:test];
    }
}

@end
