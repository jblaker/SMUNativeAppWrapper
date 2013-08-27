//
//  AppDelegate.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "AppDelegate.h"
#import "SMUManager.h"

#define kURLToLoad @"https://music.sonyentertainmentnetwork.com"

@implementation AppDelegate

@synthesize webView, window;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [webView setMainFrameURL:kURLToLoad];
  [[SMUManager sharedInstance] setup];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
	[self bringMainWindowToFront:nil];
	return YES;
}

- (void)bringMainWindowToFront:(id)sender {
	[window makeKeyAndOrderFront:sender];
	if ([[webView mainFrameURL] isEqualTo:@""]) {
		[webView setMainFrameURL:kURLToLoad];
	}
}

+ (AppDelegate *)appDelegate {
	return (AppDelegate *)[[NSApplication sharedApplication] delegate];
}

#pragma mark - UI Actions

- (IBAction)togglePlayback:(id)sender {
  [[SMUManager sharedInstance] togglePlayback];
}

- (IBAction)nextTrack:(id)sender {
  [[SMUManager sharedInstance] nextTrack];
}

- (IBAction)previousTrack:(id)sender {
  [[SMUManager sharedInstance] previousTrack];
}

- (IBAction)likeTrack:(id)sender {
  [[SMUManager sharedInstance] likeTrack];
}

- (IBAction)dislikeTrack:(id)sender {
  [[SMUManager sharedInstance] dislikeTrack];
}

@end