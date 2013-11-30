//
//  CDAtlasLoader.h
//  MegaMana
//
//  Created by Jason Cordial on 11/29/13.
//  Copyright (c) 2013 cordial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define CDATLAS_ANIMATIONS_KEY @"animations"
#define CDATLAS_ATLAS_NAME_KEY @"atlas"
#define CDATLAS_PREFIX_KEY @"prefix"
#define CDATLAS_NAME_KEY @"name"
#define CDATLAS_NUMBER_FORMAT_KEY @"number_format"
@interface CDAtlasLoader : NSObject{
	NSString* _atlasName;
	NSMutableDictionary* _animations;
	NSDictionary* _animProperties;
	SKTextureAtlas* _tAtlas;
}
@property(readonly,nonatomic) NSDictionary* animProperties;
@property(readonly,nonatomic) NSString* atlasName;
@property (copy) NSComparisonResult (^blockProperty)(id,id);

-(id)initWithPlist:(NSString*)plistName;

-(SKTexture*) textureForAnimation:(NSString*) animationName atIndex: (NSInteger) index;
-(NSArray*) texturesForAnimation:(NSString*)animationName;


@end
