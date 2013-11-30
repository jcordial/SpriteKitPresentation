//
//  CDMyScene.m
//  MegaMana
//
//  Created by Jason Cordial on 11/29/13.
//  Copyright (c) 2013 cordial. All rights reserved.
//

#import "CDMyScene.h"



@implementation CDMyScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
		self.atlas = [[CDAtlasLoader alloc] initWithPlist:@"sprite_loader_megaman"];

		NSArray* teleportFrames = [self.atlas texturesForAnimation:@"teleport"];

		//creat the megaman sprite
		self.megaman = [SKSpriteNode spriteNodeWithTexture:teleportFrames[0]];

		[self addChild:self.megaman];

		//add the texture animation to make it
		//look like we're doing something
		SKAction* teleportAction = [SKAction animateWithTextures:teleportFrames  timePerFrame:0.05 resize:YES restore:NO ];

		//set the position to the middle of the screen
		[self.megaman setPosition:CGPointMake(size.width*0.5, self.megaman.frame.size.height)];


		SKAction* move = [SKAction moveToY:size.height*0.5 duration:0.25];

		SKAction* introAction = [SKAction sequence:@[move,teleportAction,self.startAction]];

		[self.megaman runAction:introAction];


		//preload the particle
		NSString* pathToEmitter = [[NSBundle mainBundle] pathForResource:@"frazzle" ofType:@"sks"];
		self.frazzle = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToEmitter];

		[self.megaman addChild:self.frazzle];
		
		[self.frazzle setHidden:YES];

    }
    return self;
}
-(void)start;
{


	[super start];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

	UITouch* touch =  [touches anyObject];
	CGFloat newX = [touch locationInNode:self].x;
	SKAction* action = [self moveAction:newX];



	if(newX < self.megaman.position.x){
		self.megaman.xScale = -1;
	} else {
		self.megaman.xScale = 1;

	}
	[self.megaman removeActionForKey:@"walk"];
	[self.megaman runAction:action withKey:@"walk"];
	self.frazzle.position = CGPointMake(self.megaman.frame.size.width*0.5, 8);
	[self.frazzle setHidden:NO];
}

-(SKAction*) moveAction:(CGFloat)x;
{
	SKAction* moveAction = [SKAction moveToX:x duration:1];
	SKAction* walkAnimationAction = [SKAction animateWithTextures:[self.atlas texturesForAnimation:@"run_gun"] timePerFrame:0.1 resize:YES restore:YES];
	SKAction* frazzleHideAction = [SKAction runBlock:^{
		self.frazzle.hidden = YES;
	}];
    SKAction* walkAction = [SKAction group:@[walkAnimationAction, moveAction]];

	SKAction* walkSequence = [SKAction sequence:@[walkAction,frazzleHideAction]];

	return walkSequence;
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
