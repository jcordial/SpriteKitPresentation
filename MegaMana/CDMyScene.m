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

		//set up the physical world


		self.atlas = [[CDAtlasLoader alloc] initWithPlist:@"sprite_loader_megaman"];
		NSArray* teleportFrames = [self.atlas texturesForAnimation:@"teleport"];

		//creat the megaman sprite
		self.megaman = [SKSpriteNode spriteNodeWithTexture:teleportFrames[0]];
		[self addChild:self.megaman];

		//add the texture animation to make it
		//look like we're doing something
		SKAction* teleportAction = [SKAction animateWithTextures:teleportFrames  timePerFrame:0.05 resize:YES restore:NO ];

		//set the position to the middle of the screen
		[self.megaman setPosition:CGPointMake(size.width*0.5, self.size.height)];

		//play the traditional megaman intro
		SKAction* move = [SKAction moveToY:size.height*0.5 duration:0.5];
		SKAction* introAction = [SKAction sequence:@[move,teleportAction,self.startAction]];
		[self.megaman runAction:introAction];


		//preload the particle stuff and add it to the scene
		NSString* pathToEmitter = [[NSBundle mainBundle] pathForResource:@"frazzle" ofType:@"sks"];
		self.frazzle = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToEmitter];
		[self.megaman addChild:self.frazzle];
		[self.frazzle setHidden:YES];

		//add boundaries to the world
		self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:(CGRect){
			{
				0,
				0
			},
			self.size}];
		self.physicsBody.collisionBitMask = bullet_category;
		self.physicsBody.categoryBitMask = level_category;



    }
    return self;
}
-(void)didMoveToView:(SKView *)view{
	UITapGestureRecognizer* shoot  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoot:)];
	shoot.numberOfTapsRequired = 2;

	UITapGestureRecognizer* walk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go:)];
	walk.numberOfTapsRequired = 1;

	[self.view addGestureRecognizer:walk];
	[self.view addGestureRecognizer:shoot];
}
-(void)willMoveFromView:(SKView *)view{
	UIView* v = self.view;
	NSArray* gesRecs = v.gestureRecognizers;
	for (UIGestureRecognizer* rec in gesRecs) {
		[v  removeGestureRecognizer:rec];
	}
}
-(void)go:(UITapGestureRecognizer *)sender{
	CGPoint pInV = [sender locationInView:self.view];
	CGFloat newX = [self convertPointFromView:pInV].x;
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
-(void)shoot:(UITapGestureRecognizer *)sender{
	SKSpriteNode* bullet = [SKSpriteNode spriteNodeWithImageNamed:@"bullet.png"];
	SKPhysicsBody* pkBody = [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.width*0.5];
	[self addChild:bullet];

	bullet.physicsBody = pkBody;
	bullet.position = CGPointMake(self.megaman.position.x + (self.megaman.size.width*0.5)*self.megaman.xScale,
								self.size.height*0.5);
	bullet.xScale = self.megaman.xScale;

	pkBody.affectedByGravity = YES;
	[pkBody applyForce:CGVectorMake(self.megaman.xScale * 500, 0)];

	pkBody.categoryBitMask = bullet_category;
	pkBody.collisionBitMask = level_category;
	pkBody.contactTestBitMask = enemy_category;

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
-(void)randomWall:(id)sender {
	CGFloat randX = arc4random_uniform(self.size.width);
	CGFloat randY = self.size.height*0.5;
	[self wallAt:CGPointMake(randX, randY)];
}
-(void)wallAt:(CGPoint)point{
	CGAffineTransform trans = CGAffineTransformIdentity;
	CGRect edgeLoop = CGRectMake(-25, -50, 50, 100);
	CGPathRef rectPath = CGPathCreateWithRect(edgeLoop, &trans);


	SKShapeNode* dummy = [SKShapeNode node];
	dummy.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:edgeLoop];
	dummy.path = rectPath;
	dummy.fillColor = [UIColor yellowColor];
	dummy.position = point;
	dummy.physicsBody.categoryBitMask = enemy_category;
	dummy.physicsBody.collisionBitMask = bullet_category;
	[self addChild:dummy];

}
#pragma mark - SKPhysicsContactDelegate
-(void)didBeginContact:(SKPhysicsContact *)contact{
	SKNode* enemy,*bullet;

    if ((contact.bodyA.categoryBitMask & enemy_category ) != 0){
		//we have a bullet for a
		enemy = contact.bodyA.node;
		bullet = contact.bodyB.node;
	} else {
		enemy = contact.bodyB.node;
		bullet = contact.bodyA.node;
	}

	//kill action
	SKAction* killAction = [SKAction sequence: @[
												[SKAction fadeAlphaTo:0 duration:0.15],
												[SKAction runBlock:^{
													[enemy removeFromParent];
													[self randomWall:nil];
												}]
												]
							];
	[enemy runAction:killAction];
	enemy.physicsBody = nil;
	[bullet removeFromParent];

  }
-(void)didEndContact:(SKPhysicsContact *)contact{

}
@end
