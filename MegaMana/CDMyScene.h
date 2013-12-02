//
//  CDMyScene.h
//  MegaMana
//

//  Copyright (c) 2013 cordial. All rights reserved.
//



#import "CDMasterScene.h"
@interface CDMyScene : CDMasterScene <SKPhysicsContactDelegate>
@property (nonatomic, readwrite) CDAtlasLoader* atlas;
@property (nonatomic, readwrite) SKSpriteNode* megaman;
@property (nonatomic, readwrite) SKEmitterNode* frazzle;
-(IBAction)shoot:(UITapGestureRecognizer*)sender;
-(IBAction)go:(UITapGestureRecognizer*)sender;
@end
