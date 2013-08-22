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
#define kURLToLoad        @"https://music.sonyentertainmentnetwork.com"

@interface SMUManager () {
  WebView *_webView;
  NSMenuItem *_nowPlayingMenuItem;
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
  _webView = [[AppDelegate appDelegate] webView];
  [_webView setMainFrameURL:kURLToLoad];
  [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(displayNowPlaying) userInfo:nil repeats:YES];
}

- (void)togglePlayback:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPlayPause"];
}

- (void)previousTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerPrevious"];
}

- (void)nextTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerNext"];
}

- (void)likeTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerLike"];
}

- (void)dislikeTrack:(id)sender {
  [self triggerJavascriptEvent:@"click" forElementID:@"PlayerDislike"];
}

- (void)triggerJavascriptEvent:(NSString *)eventName forElementID:(NSString *)elementID {
  NSString *javascriptCommand = [NSString stringWithFormat:@"var event = document.createEvent(\"HTMLEvents\"); event.initEvent(\"%@\", true, true); document.getElementById('%@').dispatchEvent(event)", eventName, elementID];
  [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
}

- (void)displayNowPlaying {
  NSString *title = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:0];
  NSString *album = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:2];
  NSString *artist = [self innerHTMLForElementWithClassName:kNowPlayingClass atIndex:4];
  NSString *nowPlaying;
  if ( title.length == 0 ) {
    nowPlaying = @"Nothing Playing";
    [[[NSApplication sharedApplication] mainWindow] setTitle:kApplicationName];
  } else {
    nowPlaying = [NSString stringWithFormat:@"%@ - %@ - %@", title, album, artist];
    [[[NSApplication sharedApplication] mainWindow] setTitle:[NSString stringWithFormat:@"%@ | %@", kApplicationName, nowPlaying]];
  }
  [_nowPlayingMenuItem setTitle:nowPlaying];
}

- (NSString *)innerHTMLForElementWithClassName:(NSString *)className atIndex:(int)index {
  return [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByClassName('%@')[%i].innerHTML", className, index]];
}

@end
