//
//  AutoCompleteView.m
//  Scriptorium
//
//  Created by Timothy Ritchey on Sat Jan 11 2003.
//  Copyright (c) 2003 Red Rome Logic. All rights reserved.
//

#import "AutoCompleteView.h"

void logRect(NSRect aRect) {
    NSLog(@"%.1f, %.1f, %.1f, %.1f", aRect.origin.x, aRect.origin.y,
          aRect.size.width, aRect.size.height);
}
@implementation AutoCompleteView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:(NSViewWidthSizable|NSViewHeightSizable)];

        upperMatrix = [[NSMatrix alloc] initWithFrame:NSMakeRect(0,0,0,0)];
        [upperMatrix setCellClass:[NSTextFieldCell class]];
        [upperMatrix setBackgroundColor:[NSColor redColor]];
        [upperMatrix setDrawsCellBackground:NO];
        
        lowerMatrix = [[NSMatrix alloc] initWithFrame:NSMakeRect(0,0,0,0)];
        [lowerMatrix setCellClass:[NSTextFieldCell class]];
        [lowerMatrix setBackgroundColor:[NSColor redColor]];
        [lowerMatrix setDrawsCellBackground:NO];
        
        showUpper = NO;
        showLower = NO;

        lowerFrame = NSZeroRect;
        upperFrame = NSZeroRect;

        downArrowView = [[NSImageView alloc] init];
        [downArrowView setImage:[NSImage imageNamed:@"downArrow"]];
        upArrowView = [[NSImageView alloc] init];
        [upArrowView setImage:[NSImage imageNamed:@"upArrow"]];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
    [backgroundColor set];
    if(showUpper)
        [[self backgroundPathForRect:upperFrame isUpper:YES] fill];
    if(showLower)
        [[self backgroundPathForRect:lowerFrame isUpper:NO] fill];
}

- (void)setController:(AutoCompleteController*)aController
{
    controller = aController;
    [upperMatrix setTarget:controller];
    [lowerMatrix setTarget:controller];
}

- (void)setBackgroundColor:(NSColor*)aColor
{
    [backgroundColor release];
    backgroundColor = [aColor retain];
}

- (void)setTextAttributes:(NSDictionary*)attributes
{
    [textAttributes release];
    textAttributes = [attributes copy];
}

- (void)setCompletionArray:(NSArray*)anArray
{
    [completionArray release];
    completionArray = [anArray retain];
}

- (void)setCompletionPoint:(NSPoint)aPoint
{
    completionPoint = aPoint;
    [[self window] setFrameOrigin:completionPoint];
    cpDelta = 0.0;
}

- (void)setCompletionIndex:(int)index
{
    int i = 0, j = 0, startIndex = 0, stopIndex = 0;
    NSTextFieldCell *cell;
    float height = 0;
    NSRect newFrame = [self frame];
    int count = [completionArray count];
    BOOL showUpArrow = NO;
    BOOL showDownArrow = NO;
    NSString *string;
    NSAttributedString *as;

    NSRect windowFrame = [[self window] frame];
    completionPoint.x = windowFrame.origin.x;
    completionPoint.y = windowFrame.origin.y + cpDelta;

    // lower matrix
    if(index < count - 1) {
        // we have a lower matrix
        if(!showLower) {
            [self addSubview:lowerMatrix];
            showLower = YES;
        }
        startIndex = index + 1;
        stopIndex = count;
        if((stopIndex - startIndex) > 10) {
            showDownArrow = YES;
            stopIndex = startIndex + 10;
        } else {
            showDownArrow = NO;
        }
        j = 0;
        [lowerMatrix renewRows:stopIndex-startIndex columns:1];
        for(i = startIndex; i < stopIndex; ++i) {
            cell = [lowerMatrix cellAtRow:j column:0];
            string = [completionArray objectAtIndex:i];
            as = [[NSAttributedString alloc] initWithString:string
                                                 attributes:textAttributes];

            [cell setAttributedStringValue:[as autorelease]];
            ++j;
        }
        [lowerMatrix sizeToFit];
        lowerFrame.size = [lowerMatrix frame].size;
        if(showDownArrow) {
            lowerFrame.size.height += 12;
            [lowerMatrix setFrameOrigin:NSMakePoint(0,12)];
        } else {
            [lowerMatrix setFrameOrigin:NSZeroPoint];
        }
        height += lowerFrame.size.height;
        newFrame.origin.y = completionPoint.y - lowerFrame.size.height;
    } else {
        showLower = NO;
        [lowerMatrix retain];
        [lowerMatrix removeFromSuperview];
        newFrame.origin.y = completionPoint.y;
    }

    // make room for middle text field
    float h;
    if(index < 0 || index > [completionArray count])
        h = [[NSString stringWithString:@"."] sizeWithAttributes:textAttributes].height;
    else
       h = [[completionArray objectAtIndex:index] sizeWithAttributes:textAttributes].height;
    newFrame.origin.y -= h;
    height += h;
    cpDelta = height;
    // upper matrix
    
    if(index > 0) {
        // we have an upper matrix
        if(!showUpper) {
            [self addSubview:upperMatrix];
            showUpper = YES;
        }

        if(index > 10) {
            showUpArrow = YES;
            startIndex = index - 10;
        } else {
            showUpArrow = NO;
            startIndex = 0;
        } 
        stopIndex = index; j = 0;
        [upperMatrix renewRows:stopIndex-startIndex columns:1];
        for(i = startIndex; i < stopIndex; ++i) {
            cell = [upperMatrix cellAtRow:j column:0];
            string = [completionArray objectAtIndex:i];
            as = [[NSAttributedString alloc] initWithString:string
                                                 attributes:textAttributes];
            [cell setAttributedStringValue:[as autorelease]];
            ++j;
        }
        [upperMatrix sizeToFit];
        [upperMatrix setFrameOrigin:NSMakePoint(0,height)];
        upperFrame = [upperMatrix frame];
        if(showUpArrow) {
            upperFrame.size.height += 12;
        }
        height += upperFrame.size.height;
    } else {
        showUpper = NO;
        [upperMatrix retain];
        [upperMatrix removeFromSuperview];
        height -= h;
    }



    float width;
    if(lowerFrame.size.width > upperFrame.size.width) {
        width = lowerFrame.size.width;
        upperFrame.size.width = width;
    } else {
        width = upperFrame.size.width;
        lowerFrame.size.width = width;
    }



    if(showUpArrow) {
        [upArrowView setFrame:NSMakeRect(width/2 - 5.5, height - 13, 11, 11)];
        [self addSubview:upArrowView];
    } else {
        [upArrowView retain];
        [upArrowView removeFromSuperview];
    }
    if(showDownArrow) {

        [downArrowView setFrame:NSMakeRect(width/2 - 5.5, 2, 11, 11)];
        [self addSubview:downArrowView];
    } else {
        [downArrowView retain];
        [downArrowView removeFromSuperview];
    }

    newFrame.origin.x = completionPoint.x;
    newFrame.size.width = width;
    newFrame.size.height = height;
    [[self window] setFrame:newFrame display:YES animate:YES];
    [self setNeedsDisplay:YES];

}

- (BOOL)isFlipped
{
    return NO;
}

- (NSBezierPath*)backgroundPathForRect:(NSRect)aRect isUpper:(BOOL)flag
{
    NSPoint origin = aRect.origin;
    NSSize size = aRect.size;
    float radius = [@"." sizeWithAttributes:textAttributes].height/2;
    NSBezierPath *path = [NSBezierPath bezierPath];
    if(!flag) {
        origin.x += radius;
        [path moveToPoint:origin];
        origin.y += radius;
        [path appendBezierPathWithArcWithCenter:origin radius:radius startAngle:180.0
                                       endAngle:270.0 clockwise:NO];

        origin.x += (size.width - radius*2); origin.y -= radius;
        [path lineToPoint:origin];
        origin.y += radius;
        [path appendBezierPathWithArcWithCenter:origin radius:radius startAngle:270.0
                                       endAngle:0.0 clockwise:NO];
        origin.y += (size.height - radius); origin.x += radius;
        [path lineToPoint:origin];
        origin.x -= (size.width);
        [path lineToPoint:origin];
        origin.y -= (size.height - radius);
        [path lineToPoint:origin];
    } else {
        [path moveToPoint:origin];
        origin.x += size.width;
        [path lineToPoint:origin];
        origin.y += (size.height - radius);
        [path lineToPoint:origin];
        origin.x -= radius;
        [path appendBezierPathWithArcWithCenter:origin radius:radius startAngle:0.0
                                       endAngle:90.0 clockwise:NO];
        origin.y += radius; origin.x -=(size.width - radius*2);
        [path lineToPoint:origin];
        origin.y -= radius;
        [path appendBezierPathWithArcWithCenter:origin radius:radius startAngle:90.0
                                       endAngle:180.0 clockwise:NO];
        origin.x -= radius; origin.y -= (size.height - radius);
        [path lineToPoint:origin];

    }
    return path;
    
}

@end
