//
//  CDMasterScene.m
//  MegaMana
//
//  Created by Jason Cordial on 11/29/13.
//  Copyright (c) 2013 cordial. All rights reserved.
//

#import "CDMasterScene.h"

@implementation CDMasterScene
@synthesize startAction=_startAction;
-(instancetype)initWithSize:(CGSize)size
{
	if((self = [super initWithSize:size])){
		[self setUserInteractionEnabled:NO];
		_startAction = [SKAction performSelector:@selector(start) onTarget:self];
	}
	return self;
}

-(void)start;
{
	[self setUserInteractionEnabled:YES];
}
@end
