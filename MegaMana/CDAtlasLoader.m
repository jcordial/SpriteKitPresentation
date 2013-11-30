//
//  CDAtlasLoader.m
//  MegaMana
//
//  Created by Jason Cordial on 11/29/13.
//  Copyright (c) 2013 cordial. All rights reserved.
//

#import "CDAtlasLoader.h"
@interface CDAnimation : NSObject 
	@property (readwrite,nonatomic) NSString* name;
	@property (readwrite,nonatomic) NSString* prefix;
	@property (readwrite,nonatomic) NSString* number_format;
	@property (readwrite,nonatomic) NSMutableArray* frames;
-(void)sortFrames;
@end
@implementation CDAnimation

-(NSString *)description{
	return [NSString stringWithFormat:@"%@: name - %@", NSStringFromClass([self class]), self.name];
}
@end


@implementation CDAtlasLoader
@synthesize atlasName = _atlasName;
-(id)initWithPlist:(NSString *)plistName;
{
	if((self = [super init])){
		NSBundle* mainBundle = [NSBundle mainBundle];
		_atlasName = plistName;
		NSString* pathToList = [mainBundle pathForResource:_atlasName ofType:@"plist"];
		_animations = [[NSMutableDictionary alloc]init ];

		if(pathToList) {
			_animProperties = [NSDictionary dictionaryWithContentsOfFile:pathToList];

			[self initialize];
		} else{
			//file doesn't exist, lets flip our shit and breaks things because of, Fred Durst style. Dolla Billz yall.
			NSException* exception = [NSException exceptionWithName:@"CDAtlasLoader - Oh Shit Son" reason:@"The file you asked me to load doesn't exist in the main app bundle. What. The. Hell." userInfo:@{@"plistName":plistName}];

			[exception raise];

		}
	}
	return self;
}
-(void)initialize{
	NSArray* animations = _animProperties[CDATLAS_ANIMATIONS_KEY];
	_atlasName = _animProperties[CDATLAS_ATLAS_NAME_KEY];
	_tAtlas = [SKTextureAtlas atlasNamed:_atlasName];

	NSMutableArray* frameNames = [NSMutableArray arrayWithArray:[[_tAtlas textureNames] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [obj1 compare:obj2];
	}]] ;

	//there should be no overlap
	for (int i = 0, max = animations.count; i < max; i++) {
		NSDictionary* anim = animations[i];
		CDAnimation* animation = [[CDAnimation alloc] init];
		animation.prefix = anim[CDATLAS_PREFIX_KEY];
		animation.name = anim[CDATLAS_NAME_KEY];
		animation.number_format = anim[CDATLAS_NUMBER_FORMAT_KEY];
		animation.frames = [NSMutableArray array];
		NSMutableIndexSet* removers = [NSMutableIndexSet indexSet];
		for (int j = 0, nextmax = frameNames.count; j < nextmax; j++) {
			NSString* frameName = frameNames[j];
			if([frameName rangeOfString:animation.prefix].location == NSNotFound){
				continue;
			}
			[animation.frames addObject:[_tAtlas textureNamed:frameNames[j]]];
			[removers addIndex:j];

		}
		[_animations setObject:animation forKey:animation.name];
		if(removers.count > 0){
			[frameNames removeObjectsAtIndexes:removers];
		}

	}
}
-(NSArray *)texturesForAnimation:(NSString *)animationName{
	CDAnimation* animation = _animations[animationName];
	return animation.frames;
}





@end
