//
//  CDMasterScene.h
//  MegaMana
//
//  Created by Jason Cordial on 11/29/13.
//  Copyright (c) 2013 cordial. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CDAtlasLoader.h"
@interface CDMasterScene : SKScene
@property(readonly,nonatomic) SKAction* startAction;
-(void)start;

@end