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
		NSArray* textureNames = megamanAtlas.textureNames;
		NSMutableArray* teleportTexture = [[NSMutableArray alloc] init];
		for (int i = 0, max = textureNames.count; i < max; i++) {
			[teleportTexture addObject:[megamanAtlas textureNamed:textureNames[i]]];
		}
		self.teleportFrames = teleportTexture;


		//creat the megaman sprite
		SKSpriteNode* megaman = [SKSpriteNode spriteNodeWithTexture:teleportTexture[0]];
		[self addChild:megaman];

		//add the texture animation to make it
		//look like we're doing something
		SKAction* teleportAction = [SKAction animateWithTextures:teleportTexture  timePerFrame:1];
		[megaman runAction:teleportAction];
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
