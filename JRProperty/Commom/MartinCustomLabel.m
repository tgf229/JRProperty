//
//  MartinCustomLabel.m
//  JRProperty
//
//  Created by liugt on 14/12/1.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MartinCustomLabel.h"

@implementation MartinCustomLabel

- (void)drawTextInRect:(CGRect)rect
{
    if (_characterSpacing)
    {
        // Drawing code
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat size = self.font.pointSize;
        
        CGContextSelectFont (context, [self.font.fontName UTF8String], size, kCGEncodingMacRoman);
        CGContextSetCharacterSpacing (context, _characterSpacing);
        CGContextSetTextDrawingMode (context, kCGTextFill);
        
        // Rotate text to not be upside down
        CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(context, xform);
        const char *cStr = [self.text UTF8String];
        CGContextShowTextAtPoint (context, rect.origin.x, rect.origin.y + size + _topSpacing, cStr, strlen(cStr));
    }
    else
    {
        // no character spacing provided so do normal drawing
        [super drawTextInRect:rect];
    }
}

@end
