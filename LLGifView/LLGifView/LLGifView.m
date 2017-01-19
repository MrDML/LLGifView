//
//  LLGifView.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/15.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLGifView.h"
#import <ImageIO/ImageIO.h>

@interface LLGifView (){
    CGImageSourceRef    _gif;
    NSInteger           _index;
    NSInteger           _count;
    NSTimer             *_timer;
    NSDictionary        *_gifProperties;
}
@end

@implementation LLGifView

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dic = @{(NSString *)kCGImagePropertyGIFLoopCount:@0};
        _gifProperties = @{(NSString *)kCGImagePropertyGIFDictionary:dic};
        _gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:filePath], (CFDictionaryRef)_gifProperties);
        _count = CGImageSourceGetCount(_gif);
        [self play];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSData *)data{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dic = @{(NSString *)kCGImagePropertyGIFLoopCount:@0};
        _gifProperties = @{(NSString *)kCGImagePropertyGIFDictionary:dic};
        _gif = CGImageSourceCreateWithData((CFDataRef)data, (CFDictionaryRef)_gifProperties);
        _count = CGImageSourceGetCount(_gif);
        [self play];
    }
    return self;
}

- (void)startGif{
    if (!_timer) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(play) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] run];
        });
    }
}

- (void)stopGif{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)play{
    _index = _index%_count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(_gif, _index, (CFDictionaryRef)_gifProperties);
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
    _index ++;
}

- (void)dealloc {
    CFRelease(_gif);
}

@end