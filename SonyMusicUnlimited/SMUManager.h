//
//  SMUManager.h
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/22/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMUManager : NSObject

+ (SMUManager *)sharedInstance;
- (void)setup;
- (IBAction)togglePlayback:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)likeTrack:(id)sender;
- (IBAction)dislikeTrack:(id)sender;

@end
