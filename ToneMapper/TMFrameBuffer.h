//
//  TMFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Defines a bindable frame buffer object.
@protocol TMFrameBuffer <NSObject>

/// Bind the frame buffer.
- (void)bind;

/// The size of the frame-buffer.
@property (readonly, nonatomic) CGSize size;

@end

NS_ASSUME_NONNULL_END
