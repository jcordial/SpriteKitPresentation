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
        /* Setup your scene here */

		//load the megaman texture
		SKTextureAtlas* megamanAtlas = [SKTextureAtlas atlasNamed:@"megaman"];

		NSString* seriesName = @"teleport_";

		NSArray* textureNames = [megamanAtlas.textureNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSNumber* num1 = @([[obj1 stringByReplacingOccurrencesOfString:seriesName withString:@""] integerValue]);
			NSNumber* num2 = @([[obj2 stringByReplacingOccurrencesOfString:seriesName withString:@""] integerValue]);
			return [num1 compare:num2];

		}];

		NSMutableArray* teleportTexture = [[NSMutableArray alloc] init];
		for (int i = 0, max = textureNames.count; i < max; i++) {
			[teleportTexture addObject:[megamanAtlas textureNamed:textureNames[i]]];
		}

		//we need to sort the frames to make sure they end up in the correct order
		self.teleportFrames = teleportTexture;

		//creat the megaman sprite
		SKSpriteNode* megaman = [SKSpriteNode spriteNodeWithTexture:teleportTexture[0]];
		[self addChild:megaman];

		//add the texture animation to make it
		//look like we're doing something
		SKAction* teleportAction = [SKAction animateWithTextures:self.teleportFrames  timePerFrame:0.1 resize:YES restore:NO ];
		[megaman runAction:teleportAction];


		//set the position to the middle of the screen
		[megaman setPosition:CGPointMake(size.width*0.5, size.height*0.5)];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
