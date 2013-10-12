//
//  SMUManager.h
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/22/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface SMUManager : NSObject

+ (SMUManager *)sharedInstance;
- (void)setup;
- (void)togglePlayback;
- (void)previousTrack;
- (void)nextTrack;
- (void)likeTrack;
- (void)dislikeTrack;
- (void)toggleShouldUpdateStatus;

@property (strong) NSStatusItem *playbackToggleStatusItem;
@property (strong) NSStatusItem *nextTrackStatusItem;

@end
