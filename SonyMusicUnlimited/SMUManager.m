//
//  SMUManager.m
//  SonyMusicUnlimited
//
//  Created by Jeremy Blaker on 8/22/13.
//  Copyright (c) 2013 blakerdesign. All rights reserved.
//

#import "SMUManager.h"
#import "AppDelegate.h"

#define kApplicationName  @"Sony Music Unlimited"
#define kNowPlayingClass  @"GBJWNX1BGBC"

@interface SMUManager () {
  WebView *_webView;
  NSMenuItem *_nowPlayingMenuItem;
  NSMenuItem *_artistNameMenuItem;
  NSMenuItem *_trackNameMenuItem;
  NSMenuItem *_playbackToggleMenuItem;
  NSMenu *_dockMenu;
  BOOL _isPlaying;
}

@end

@implementation SMUManager

+ (SMUManager *)sharedInstance {
  static SMUManager *sharedInstance = nil;
  if (sharedInstance) {
    return sharedInstance;
  }
  sharedInstance = [[SMUManager alloc] init];
  return sharedInstance;
}

- (void)setup {
  
  _nowPlayingMenuItem = [[AppDelegate appDelegate] nowPlayingMenuItem];
  [_nowPlayingMenuItem setTitle:@"Nothing Playing"];
  
  _webView = [[AppDelegate appDelegate] webView];
  [_webView setFrameLoadDelegate:self];
  
  _dockMenu = [[AppDelegate appDelegate] dockMenu];
  _trackNameMenuItem = [[AppDelegate appDelegate] trackNameMenuItem];
  _artistNameMenuItem = [[AppDelegate appDelegate] artistNameMenuItem];
  _playbackToggleMenuItem = [[AppDelegate appDelegate] playbackToggleMenuItem];
  
  [self shouldShowTrackInfoMenuItems:NO];
  
  [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(displayNowPlaying) userInfo:nil repeats:YES];
}

// This delegate method gets triggered every time the page loads, but before the JavaScript runs
- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
	// Allow this class to be usable through the "window.app" object in JavaScript
	// This could be any Objective-C class
	[windowScriptObject setValue:self forKey:@"app"];
}

- (void)togglePlayback {
  if ([[_playbackToggleMenuItem title] isEqualToString:@"Play"]) {
    [_playbackToggleMenuItem setTitle:@"Pause"];
  } else {
    [_playbackToggleMenuItem setTitle:@"Play"];
  }
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPlayPause"];
}

- (void)previousTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPrevious"];
}

- (void)nextTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerNext"];
}

- (void)likeTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerLike"];
}

- (void)dislikeTrack {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerDislike"];
}

- (void)triggerJavascriptEvent:(NSString *)eventName forElementID:(NSString *)elementID {
  NSString *javascriptCommand = [NSString stringWithFormat:@"var event = document.createEvent(\"HTMLEvents\"); event.initEvent(\"%@\", true, true); document.getElementById('%@').dispatchEvent(event)", eventName, elementID];
  [[_webView windowScriptObject] evaluateWebScript:javascriptCommand];
}

- (void)shouldShowTrackInfoMenuItems:(BOOL)b {
  if (b) {
    [_dockMenu insertItem:_trackNameMenuItem atIndex:1];
    [_dockMenu insertItem:_artistNameMenuItem atIndex:1];
  } else {
    [_dockMenu removeItem:_trackNameMenuItem];
    [_dockMenu removeItem:_artistNameMenuItem];
  }
}

- (void)displayNowPlaying {
  NSString *title = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:0];
  //NSString *album = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:2];
  NSString *artist = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:4];
  if ( title.length == 0 ) {
    [_nowPlayingMenuItem setTitle:@"Nothing Playing"];
    if ( _isPlaying == YES ) {
      [self shouldShowTrackInfoMenuItems:NO];
      _isPlaying = NO;
    }
  } else {
    [_nowPlayingMenuItem setTitle:@"Now Playing"];
    [_artistNameMenuItem setTitle:artist];
    [_trackNameMenuItem setTitle:title];
    if ( _isPlaying == NO ) {
      [self shouldShowTrackInfoMenuItems:YES];
      _isPlaying = YES;
    }
  }
}

- (NSString *)innerHTMLForElementWithClassName:(NSString *)className atIndex:(int)index {
  return [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('%@')[%i].innerHTML", className, index]];
}

@end
