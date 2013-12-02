//
//  CDMyScene.h
//  MegaMana
//

//  Copyright (c) 2013 cordial. All rights reserved.
//



#import "CDMasterScene.h"
typedef enum _Collision_Cats {
	enemy_category = 0x1,
	bullet_category = 0x1 << 1,
	level_category = 0x1 << 2
} CollisionCategories;

@interface CDMyScene : CDMasterScene <SKPhysicsContactDelegate>
@property (nonatomic, readwrite) CDAtlasLoader* atlas;
@property (nonatomic, readwrite) SKSpriteNode* megaman;
@property (nonatomic, readwrite) SKEmitterNode* frazzle;

-(IBAction)randomWall:(id)sender;
-(IBAction)shoot:(UITapGestureRecognizer*)sender;
-(IBAction)go:(UITapGestureRecognizer*)sender;
@end
