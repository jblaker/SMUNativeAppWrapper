//
//  AppDelegate.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "AppDelegate.h"
#import "SMUManager.h"

@interface AppDelegate () {
  BOOL didInitialLoad;
}

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [self.window setBackgroundColor:[NSColor colorWithDeviceRed:0.917 green:0.921 blue:0.933 alpha:1.0]];
  [[SMUManager sharedInstance] setup];
}

+ (AppDelegate *)appDelegate {
	return (AppDelegate *)[[NSApplication sharedApplication] delegate];
}

#pragma mark - UI Actions

- (void)togglePlayback:(id)sender {
  [[SMUManager sharedInstance] togglePlayback];
}

- (void)nextTrack:(id)sender {
  [[SMUManager sharedInstance] nextTrack];
}

- (void)previousTrack:(id)sender {
  [[SMUManager sharedInstance] previousTrack];
}

- (void)likeTrack:(id)sender {
  [[SMUManager sharedInstance] likeTrack];
}

- (void)dislikeTrack:(id)sender {
  [[SMUManager sharedInstance] dislikeTrack];
}

@end