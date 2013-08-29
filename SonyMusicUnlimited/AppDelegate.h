//
//  AppDelegate.h
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/20/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#define kShouldUpdateStatusKey @"shouldUpdateStatus"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *dockMenu;
@property (weak) IBOutlet WebView *webView;
@property (weak) IBOutlet NSMenuItem *nowPlayingMenuItem;
@property (weak) IBOutlet NSMenuItem *trackNameMenuItem;
@property (weak) IBOutlet NSMenuItem *artistNameMenuItem;
@property (weak) IBOutlet NSMenuItem *playbackToggleMenuItem;
@property (weak) IBOutlet NSMenuItem *previousTrackMenuItem;
@property (weak) IBOutlet NSMenuItem *nextTrackMenuItem;
@property (weak) IBOutlet NSMenuItem *likeTrackMenuItem;
@property (weak) IBOutlet NSMenuItem *dislikeTrackMenuItem;
@property (weak) IBOutlet NSMenuItem *updateStatusMessageMenuItem;

- (IBAction)togglePlayback:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)likeTrack:(id)sender;
- (IBAction)dislikeTrack:(id)sender;
- (IBAction)toggleShouldUpdateStatus:(id)sender;

+ (AppDelegate *)appDelegate;

@end
