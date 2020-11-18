//
//  PHSegmentedControl.m
//  PHSegmentedControl
//
//  Created by 朱力 on 2019/12/4.
//

#import "PHSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "UIColor+PH.h"

@interface PHScrollView : UIScrollView
@end

@interface PHSegmentedControl ()

@property (nonatomic, strong) CALayer *selectionIndicatorStripLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorBoxLayer;
@property (nonatomic, strong) CALayer *selectionIndicatorArrowLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, readwrite) NSArray<NSNumber *> *segmentWidthsArray;
@property (nonatomic, strong) PHScrollView *scrollView;

@end

@implementation PHScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.dragging) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    } else{
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@implementation PHSegmentedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray<NSString *> *)secTitles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        [self commonInit];
        self.secTitles = secTitles;
        self.type = PHSegmentedControlTypeText;
    }
    
    return self;
}

- (id)initWithSelImgs:(NSArray<UIImage *> *)secImgs
              selImgs:(NSArray<UIImage *> *)selImgs {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
        self.secImgs = secImgs;
        self.selImgs = selImgs;
        self.type = PHSegmentedControlTypeImages;
    }
    return self;
}

- (instancetype)initWithSelImgs:(NSArray<UIImage *> *)secImgs
                        selImgs:(NSArray<UIImage *> *)selImgs
                         titles:(NSArray<NSString *> *)secTitles {
	self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
		if (secImgs.count != secTitles.count) {
			[NSException raise:NSRangeException
                        format:@"%s:secImgs%ld secTitles%ld",
             sel_getName(_cmd), (unsigned long)secImgs.count,
             (unsigned long)secTitles.count];
        }
        self.secImgs = secImgs;
        self.selImgs = selImgs;
		self.secTitles = secTitles;
        self.type = PHSegmentedControlTypeTextImages;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.segmentWidth = 0.0f;
}

- (void)commonInit {
    self.scrollView = [[PHScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.selCursorHeight = 5.0f;
    self.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.selectionStyle = PHSegmentedControlSelectionStyleTextWidthStripe;
    self.selCursorSite = PHSegmentedControlSelectionIndicatorLocationUp;
    self.selectionIndicatorArrowLayer = [CALayer layer];
    self.selectionIndicatorStripLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer = [CALayer layer];
    self.selectionIndicatorBoxLayer.opacity = self.selCurBoxOpacity;
    self.selectionIndicatorBoxLayer.borderWidth = 1.0f;
    self.selCurBoxOpacity = 0.2;
    [self initUIDefaultStyle];
}

- (void)initUIDefaultStyle {
    self.selectedSegmentIndex = 0;
    self.segmentWidthStyle = PHSegmentedControlSegmentWidthStyleFixed;
    self.opaque = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.userDraggable = YES;
    self.touchEnabled = YES;
    self.verticalDividerEnabled = NO;
    self.type = PHSegmentedControlTypeText;
    self.verticalDividerWidth = 1.0f;
    self.verticalDividerColor = [UIColor blackColor];
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1.0f;
    self.shouldAnimateUserSelection = YES;
    self.contentMode = UIViewContentModeRedraw;
    self.selectionIndicatorColor = [UIColor ph_colorWithHexString:@"34B5E5"];
    self.selectionIndicatorBoxColor = self.selectionIndicatorColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSegmentsRects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateSegmentsRects];
}

- (void)setSecTitles:(NSArray<NSString *> *)secTitles {
    _secTitles = secTitles;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSecImgs:(NSArray<UIImage *> *)secImgs {
    _secImgs = secImgs;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setSelCursorSite:(PHSegmentedControlSelectionIndicatorLocation)selCursorSite {
	_selCursorSite = selCursorSite;
	if (selCursorSite == PHSegmentedControlSelectionIndicatorLocationNone) {
		self.selCursorHeight = 0.0f;
	}
}

- (void)setSelCurBoxOpacity:(CGFloat)selCurBoxOpacity {
    _selCurBoxOpacity = selCurBoxOpacity;
    self.selectionIndicatorBoxLayer.opacity = _selCurBoxOpacity;
}

- (void)setSegmentWidthStyle:(PHSegmentedControlSegmentWidthStyle)segmentWidthStyle {
    if (self.type == PHSegmentedControlTypeImages) {
        _segmentWidthStyle = PHSegmentedControlSegmentWidthStyleFixed;
    } else {
        _segmentWidthStyle = segmentWidthStyle;
    }
}

- (void)setBorderType:(PHSegmentedControlBorderType)borderType {
    _borderType = borderType;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (CGSize)measureTitleAtIndex:(NSUInteger)index {
    if (index >= self.secTitles.count) {
        return CGSizeZero;
    }
    
    id title = self.secTitles[index];
    CGSize size = CGSizeZero;
    BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
    if ([title isKindOfClass:[NSString class]] && !self.titleFormatter) {
        NSDictionary *titleAttrs = [self resultingTitleTextAttributes];
        if (selected) {
            titleAttrs = [self resultingSelectedTitleTextAttributes];
        }
        size = [(NSString *)title sizeWithAttributes:titleAttrs];
        UIFont *font = titleAttrs[@"NSFont"];
        size = CGSizeMake(ceil(size.width), ceil(size.height-font.descender));
    } else if ([title isKindOfClass:[NSString class]] && self.titleFormatter) {
        size = [self.titleFormatter(self, title, index, selected) size];
    } else if ([title isKindOfClass:[NSAttributedString class]]) {
        size = [(NSAttributedString *)title size];
    }
    return CGRectIntegral((CGRect){CGPointZero, size}).size;
}

- (NSAttributedString *)attributedTitleAtIndex:(NSUInteger)index {
    id title = self.secTitles[index];
    BOOL selected = (index == self.selectedSegmentIndex) ? YES : NO;
    if ([title isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)title;
    } else if (!self.titleFormatter) {
        NSDictionary *titleAttrs = [self resultingTitleTextAttributes];
        if (selected) {
            titleAttrs = [self resultingSelectedTitleTextAttributes];
        }
        UIColor *titleColor = titleAttrs[NSForegroundColorAttributeName];
        if (titleColor) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:titleAttrs];
            
            dict[NSForegroundColorAttributeName] = titleColor;
            
            titleAttrs = [NSDictionary dictionaryWithDictionary:dict];
        }
        
        return [[NSAttributedString alloc] initWithString:(NSString *)title attributes:titleAttrs];
    } else {
        return self.titleFormatter(self, title, index, selected);
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawRectStyle];
    CGRect oldRect = rect;
    if (self.type == PHSegmentedControlTypeText) {
        [self drawTypeText:oldRect];
    } else if (self.type == PHSegmentedControlTypeImages) {
        [self drawTypeImage:oldRect];
    } else if (self.type == PHSegmentedControlTypeTextImages){
        [self drawTypeTextImage:oldRect];
	}
    [self addSelectionIndicators];
}

- (void)drawRectStyle {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
    if (_indicatorCorner) {
        self.selectionIndicatorStripLayer.cornerRadius = self.selCursorHeight/2.f;
        self.selectionIndicatorStripLayer.masksToBounds = YES;
    } else {
        self.selectionIndicatorStripLayer.cornerRadius =0 ;
        self.selectionIndicatorStripLayer.masksToBounds = NO;
    }
    self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorBoxColor.CGColor;
    self.selectionIndicatorBoxLayer.borderColor = self.selectionIndicatorBoxColor.CGColor;
    if (_boxCorner) {
        CGFloat cornerRadius = (self.frame.size.height - (_boxEdgeInset.top + _boxEdgeInset.bottom)) / 2.f;
        self.selectionIndicatorBoxLayer.cornerRadius = cornerRadius;
        self.selectionIndicatorBoxLayer.masksToBounds = YES;
    } else {
        self.selectionIndicatorBoxLayer.cornerRadius = 0;
        self.selectionIndicatorBoxLayer.masksToBounds = NO;
    }
    self.scrollView.layer.sublayers = nil;
}

- (void)drawTypeText:(CGRect)oldRect {
    [self.secTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat strWidth = 0;
        CGFloat strHeight = 0;
        CGSize size = [self measureTitleAtIndex:idx];
        strWidth = size.width;
        strHeight = size.height;
        CGRect rectDiv = CGRectZero;
        CGRect fullRect = CGRectZero;
        BOOL locUP = (self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationUp);
        BOOL selStyle = (self.selectionStyle != PHSegmentedControlSelectionStyleBox);
        CGFloat yValue = [self countYValue:selStyle strHeight:strHeight locUP:locUP];
        CGRect rect;
        if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
            rect = CGRectMake((self.segmentWidth * idx) + (self.segmentWidth - strWidth) / 2, yValue, strWidth, strHeight);
            rectDiv = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2),
                                 self.selCursorHeight * 2, self.verticalDividerWidth,
                                 self.frame.size.height - (self.selCursorHeight * 4));
            fullRect = CGRectMake(self.segmentWidth * idx, 0, self.segmentWidth, oldRect.size.height);
        } else {
            CGFloat xOffset = 0; NSInteger iValue = 0;
            for (NSNumber *width in self.segmentWidthsArray) {
                if (idx == iValue) { break; }
                xOffset = xOffset + [width floatValue];
                iValue++;
            }
            CGFloat widthForIndex = [[self.segmentWidthsArray objectAtIndex:idx] floatValue];
            rect = CGRectMake(xOffset, yValue, widthForIndex, strHeight);
            fullRect = CGRectMake(self.segmentWidth * idx, 0, widthForIndex, oldRect.size.height);
            rectDiv = CGRectMake(xOffset - (self.verticalDividerWidth / 2),
                                 self.selCursorHeight * 2, self.verticalDividerWidth,
                                 self.frame.size.height - (self.selCursorHeight * 4));
        }
        rect = CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));
        [self typeTextTitleLayer:rect idx:idx rectDiv:rectDiv fullRect:fullRect];
    }];
}

- (CGFloat)countYValue:(BOOL)selStyle
          strHeight:(CGFloat)strHeight
            locUP:(BOOL)locUP {
    CGFloat topHeight = (CGRectGetHeight(self.frame) - selStyle * self.selCursorHeight) / 2;
    CGFloat selHeight = self.selCursorHeight * locUP;
     return roundf(topHeight - strHeight / 2 + selHeight);
}

- (void)typeTextTitleLayer:(CGRect)rect idx:(NSUInteger)idx rectDiv:(CGRect)rectDiv fullRect:(CGRect)fullRect {
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.frame = rect;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
        titleLayer.truncationMode = kCATruncationEnd;
    }
    titleLayer.string = [self attributedTitleAtIndex:idx];
    titleLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.scrollView.layer addSublayer:titleLayer];
    if (self.isVerticalDividerEnabled && idx > 0) {
        CALayer *verticalDividerLayer = [CALayer layer];
        verticalDividerLayer.frame = rectDiv;
        verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;
        [self.scrollView.layer addSublayer:verticalDividerLayer];
    }
    [self addBackgroundAndBorderLayerWithRect:fullRect];
}

- (void)drawTypeImage:(CGRect)oldRect {
    [self.secImgs enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
        UIImage *icon = iconImage;
        CGFloat imageWidth = icon.size.width;
        CGFloat imageHeight = icon.size.height;
        CGFloat yValue = roundf(CGRectGetHeight(self.frame) - self.selCursorHeight) / 2 - imageHeight / 2 + ((self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationUp) ? self.selCursorHeight : 0);
        CGFloat xValue = self.segmentWidth * idx + (self.segmentWidth - imageWidth)/2.0f;
        CGRect rect = CGRectMake(xValue, yValue, imageWidth, imageHeight);
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = rect;
        if (self.selectedSegmentIndex == idx) {
            if (self.selImgs) {
                UIImage *highlightIcon = [self.selImgs objectAtIndex:idx];
                imageLayer.contents = (id)highlightIcon.CGImage;
            } else {
                imageLayer.contents = (id)icon.CGImage;
            }
        } else {
            imageLayer.contents = (id)icon.CGImage;
        }
        [self.scrollView.layer addSublayer:imageLayer];
        if (self.isVerticalDividerEnabled && idx>0) {
            CALayer *verticalDividerLayer = [CALayer layer];
            verticalDividerLayer.frame = CGRectMake((self.segmentWidth * idx) - (self.verticalDividerWidth / 2), self.selCursorHeight * 2, self.verticalDividerWidth, self.frame.size.height-(self.selCursorHeight * 4));
            verticalDividerLayer.backgroundColor = self.verticalDividerColor.CGColor;
            [self.scrollView.layer addSublayer:verticalDividerLayer];
        }
        [self addBackgroundAndBorderLayerWithRect:rect];
    }];
}

- (void)drawTypeTextImage:(CGRect)oldRect {
    [self.secImgs enumerateObjectsUsingBlock:^(id iconImage, NSUInteger idx, BOOL *stop) {
        UIImage *icon = iconImage;
        CGSize imageSize = CGSizeMake(icon.size.width, icon.size.height);
        CGSize stringSize = [self measureTitleAtIndex:idx];
        CGPoint imageOffsetSize = CGPointMake(self.segmentWidth * idx, ceilf((self.frame.size.height - imageSize.height) / 2.0));
        CGPoint textOffsetSize = CGPointMake(self.segmentWidth * idx, ceilf((self.frame.size.height - stringSize.height) / 2.0));
        if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
            [self textImageStyleFixed:idx stringSize:stringSize imageSize:imageSize imageOffsetSize:imageOffsetSize textOffsetSize:textOffsetSize icon:icon];
        } else if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
            [self textImageStyleDynamic:idx stringSize:stringSize imageSize:imageSize imageOffsetSize:imageOffsetSize textOffsetSize:textOffsetSize icon:icon];
        }
    }];
}

- (void)textImageStyleFixed:(NSUInteger)idx stringSize:(CGSize)stringSize imageSize:(CGSize)imageSize
              imageOffsetSize:(CGPoint)imageOffsetSize textOffsetSize:(CGPoint)textOffsetSize icon:(UIImage *)icon {
    BOOL isImgInLineWidthText = self.imagePosition == PHSegmentedControlImagePositionLeftOfText || self.imagePosition == PHSegmentedControlImagePositionRightOfText;
    if (isImgInLineWidthText) {
        CGFloat whitespace = self.segmentWidth - stringSize.width - imageSize.width - self.textImageSpacing;
        if (self.imagePosition == PHSegmentedControlImagePositionLeftOfText) {
            imageOffsetSize.x += whitespace / 2.0;
            textOffsetSize.x = imageOffsetSize.x + imageSize.width + self.textImageSpacing;
        } else {
            textOffsetSize.x += whitespace / 2.0;
            imageOffsetSize.x = textOffsetSize.x + stringSize.width + self.textImageSpacing;
        }
    } else {
        imageOffsetSize.x = self.segmentWidth * idx + (self.segmentWidth - imageSize.width) / 2.0f; // Start with edge inset
        textOffsetSize.x  = self.segmentWidth * idx + (self.segmentWidth - stringSize.width) / 2.0f;
        CGFloat whitespace = CGRectGetHeight(self.frame) - imageSize.height - stringSize.height - self.textImageSpacing;
        if (self.imagePosition == PHSegmentedControlImagePositionAboveText) {
            imageOffsetSize.y = ceilf(whitespace / 2.0);
            textOffsetSize.y = imageOffsetSize.y + imageSize.height + self.textImageSpacing;
        } else if (self.imagePosition == PHSegmentedControlImagePositionBelowText) {
            textOffsetSize.y = ceilf(whitespace / 2.0);
            imageOffsetSize.y = textOffsetSize.y + stringSize.height + self.textImageSpacing;
        }
    }
    [self textImageLayerSet:imageOffsetSize imageSize:imageSize textOffsetSize:textOffsetSize stringSize:stringSize idx:idx icon:icon];
}

- (void)textImageStyleDynamic:(NSUInteger)idx stringSize:(CGSize)stringSize imageSize:(CGSize)imageSize
              imageOffsetSize:(CGPoint)imageOffsetSize textOffsetSize:(CGPoint)textOffsetSize icon:(UIImage *)icon {
    CGFloat xOffset = 0; NSInteger iValue = 0;
    for (NSNumber *width in self.segmentWidthsArray) {
        if (idx == iValue) { break; } xOffset = xOffset + [width floatValue]; iValue++;
    }
    BOOL isImgInLineWidthText = (self.imagePosition == PHSegmentedControlImagePositionLeftOfText) || (self.imagePosition == PHSegmentedControlImagePositionRightOfText);
    if (isImgInLineWidthText) {
        if (self.imagePosition == PHSegmentedControlImagePositionLeftOfText) {
            imageOffsetSize.x = xOffset;
            textOffsetSize.x = imageOffsetSize.x + imageSize.width + self.textImageSpacing;
        } else {
            textOffsetSize.x = xOffset;
            imageOffsetSize.x = textOffsetSize.x + stringSize.width + self.textImageSpacing;
        }
    } else {
        imageOffsetSize.x = xOffset + ([self.segmentWidthsArray[iValue] floatValue] - imageSize.width) / 2.0f; // Start with edge inset
        textOffsetSize.x  = xOffset + ([self.segmentWidthsArray[iValue] floatValue] - stringSize.width) / 2.0f;
        CGFloat whitespace = CGRectGetHeight(self.frame) - imageSize.height - stringSize.height - self.textImageSpacing;
        if (self.imagePosition == PHSegmentedControlImagePositionAboveText) {
            imageOffsetSize.y = ceilf(whitespace / 2.0);
            textOffsetSize.y = imageOffsetSize.y + imageSize.height + self.textImageSpacing;
        } else if (self.imagePosition == PHSegmentedControlImagePositionBelowText) {
            textOffsetSize.y = ceilf(whitespace / 2.0);
            imageOffsetSize.y = textOffsetSize.y + stringSize.height + self.textImageSpacing;
        }
    }
    [self textImageLayerSet:imageOffsetSize imageSize:imageSize textOffsetSize:textOffsetSize stringSize:stringSize idx:idx icon:icon];
}

- (void)textImageLayerSet:(CGPoint)imageOffsetSize imageSize:(CGSize)imageSize textOffsetSize:(CGPoint)textOffsetSize
               stringSize:(CGSize)stringSize idx:(NSUInteger)idx icon:(UIImage *)icon {
    CGRect imageRect = CGRectMake(imageOffsetSize.x, imageOffsetSize.y, imageSize.width, imageSize.height);
    CGRect textRect = CGRectMake(ceilf(textOffsetSize.x), ceilf(textOffsetSize.y), ceilf(stringSize.width), ceilf(stringSize.height));
    CATextLayer *titleLayer = [CATextLayer layer];
    titleLayer.frame = textRect;
    titleLayer.alignmentMode = kCAAlignmentCenter;
    titleLayer.string = [self attributedTitleAtIndex:idx];
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
        titleLayer.truncationMode = kCATruncationEnd;
    }
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = imageRect;
    if (self.selectedSegmentIndex == idx) {
        if (self.selImgs) {
            UIImage *highlightIcon = [self.selImgs objectAtIndex:idx];
            imageLayer.contents = (id)highlightIcon.CGImage;
        } else {
            imageLayer.contents = (id)icon.CGImage;
        }
    } else {
        imageLayer.contents = (id)icon.CGImage;
    }
    [self.scrollView.layer addSublayer:imageLayer];
    titleLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.scrollView.layer addSublayer:titleLayer];
    [self addBackgroundAndBorderLayerWithRect:imageRect];
}

- (void)addSelectionIndicators {
    if (self.selectedSegmentIndex != PHSegmentedControlNoSegment) {
        if (self.selectionStyle == PHSegmentedControlSelectionStyleArrow) {
            if (!self.selectionIndicatorArrowLayer.superlayer) {
                [self setArrowFrame];
                [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
            }
        } else {
            if (!self.selectionIndicatorStripLayer.superlayer) {
                self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
                [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
                
                if (self.selectionStyle == PHSegmentedControlSelectionStyleBox && !self.selectionIndicatorBoxLayer.superlayer) {
                    CGRect boxFrame = [self frameForFillerSelectionIndicator];
                    boxFrame.size.height -= (_boxEdgeInset.top + _boxEdgeInset.bottom);
                    boxFrame.origin.y += (_boxEdgeInset.top + _boxEdgeInset.bottom)/2.f;
                    self.selectionIndicatorBoxLayer.frame = boxFrame;
                    [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
                }
            }
        }
    }
}

- (void)addBackgroundAndBorderLayerWithRect:(CGRect)fullRect {
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = fullRect;
    [self.layer insertSublayer:backgroundLayer atIndex:0];
    CALayer * borderLayer = [CALayer layer];
    [backgroundLayer addSublayer: borderLayer];
    switch (self.borderType) {
        case PHSegmentedControlBorderTypeTop:{
            borderLayer.frame = CGRectMake(0, 0, fullRect.size.width, self.borderWidth);
            borderLayer.backgroundColor = self.borderColor.CGColor;
            break;
        }
        case PHSegmentedControlBorderTypeLeft: {
            borderLayer.frame = CGRectMake(0, 0, self.borderWidth, fullRect.size.height);
            borderLayer.backgroundColor = self.borderColor.CGColor;
            break;
        }
        case PHSegmentedControlBorderTypeBottom: {
            borderLayer.frame = CGRectMake(0, fullRect.size.height - self.borderWidth, fullRect.size.width, self.borderWidth);
            borderLayer.backgroundColor = self.borderColor.CGColor;
            break;
        }
        case PHSegmentedControlBorderTypeRight: {
            borderLayer.frame = CGRectMake(fullRect.size.width - self.borderWidth, 0, self.borderWidth, fullRect.size.height);
            borderLayer.backgroundColor = self.borderColor.CGColor;
            break;
        }
        default:
            break;
    }
}

- (void)setArrowFrame {
    self.selectionIndicatorArrowLayer.frame = [self frameForSelectionIndicator];
    
    self.selectionIndicatorArrowLayer.mask = nil;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    CGPoint p11 = CGPointZero;
    CGPoint p22 = CGPointZero;
    CGPoint p33 = CGPointZero;
    
    if (self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationDown) {
        p11 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, 0);
        p22 = CGPointMake(0, self.selectionIndicatorArrowLayer.bounds.size.height);
        p33 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, self.selectionIndicatorArrowLayer.bounds.size.height);
    }
    
    if (self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationUp) {
        p11 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width / 2, self.selectionIndicatorArrowLayer.bounds.size.height);
        p22 = CGPointMake(self.selectionIndicatorArrowLayer.bounds.size.width, 0);
        p33 = CGPointMake(0, 0);
    }
    
    [arrowPath moveToPoint:p11];
    [arrowPath addLineToPoint:p22];
    [arrowPath addLineToPoint:p33];
    [arrowPath closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.selectionIndicatorArrowLayer.bounds;
    maskLayer.path = arrowPath.CGPath;
    self.selectionIndicatorArrowLayer.mask = maskLayer;
}

- (CGRect)frameForSelectionIndicator {
    CGFloat indicatorYOffset = 0.0f;
    if (self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationDown) {
        indicatorYOffset = self.bounds.size.height - self.selCursorHeight + self.selectionIndicatorEdgeInsets.bottom - (self.isTextWidth ? 6 : 0);
    }
    if (self.selCursorSite == PHSegmentedControlSelectionIndicatorLocationUp) {
        indicatorYOffset = self.selectionIndicatorEdgeInsets.top;
    }
    CGFloat sectionWidth = 0.0f;
    if (self.type == PHSegmentedControlTypeText) {
        sectionWidth = [self measureTitleAtIndex:self.selectedSegmentIndex].width + self.extendedIndicatorLength;
    } else if (self.type == PHSegmentedControlTypeImages) {
        UIImage *sectionImage = [self.secImgs objectAtIndex:self.selectedSegmentIndex];
        sectionWidth = sectionImage.size.width;
    } else if (self.type == PHSegmentedControlTypeTextImages) {
		CGFloat stringWidth = [self measureTitleAtIndex:self.selectedSegmentIndex].width;
		UIImage *sectionImage = [self.secImgs objectAtIndex:self.selectedSegmentIndex];
        sectionWidth = MAX(stringWidth, sectionImage.size.width);
	}
    if (self.selectionStyle == PHSegmentedControlSelectionStyleArrow) {
        CGFloat widthToEnd = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStart = (self.segmentWidth * self.selectedSegmentIndex);
        CGFloat xValue = widthToStart + ((widthToEnd - widthToStart) / 2) - (self.selCursorHeight/2);
        return CGRectMake(xValue - (self.selCursorHeight / 2), indicatorYOffset, self.selCursorHeight * 2, self.selCursorHeight);
    } else {
        return [self otherSelectionStyleFrame:sectionWidth indicatorYOffset:indicatorYOffset];
    }
}

- (CGRect)otherSelectionStyleFrame:(CGFloat)sectionWidth indicatorYOffset:(CGFloat)indicatorYOffset {
    if (self.selectionStyle == PHSegmentedControlSelectionStyleTextWidthStripe &&
        sectionWidth <= self.segmentWidth &&
        self.segmentWidthStyle != PHSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat widthToEnd = (self.segmentWidth * self.selectedSegmentIndex) + self.segmentWidth;
        CGFloat widthToStart = (self.segmentWidth * self.selectedSegmentIndex);
        CGFloat xValue = ((widthToEnd - widthToStart) / 2) + (widthToStart - sectionWidth / 2);
        NSInteger indicatorWidth = sectionWidth + 20;
        if (self.isTextWidth) {
            indicatorWidth = sectionWidth;
        }
        if (self.yxtIndicatorWidth!=0) {
            indicatorWidth = self.yxtIndicatorWidth;
        }
        return CGRectMake(xValue + self.selectionIndicatorEdgeInsets.left + (sectionWidth -indicatorWidth)/2, indicatorYOffset, indicatorWidth, self.selCursorHeight);
    } else {
        if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
            CGFloat selOffset = 0.0f; NSInteger iValue = 0;
            for (NSNumber *width in self.segmentWidthsArray) {
                if (self.selectedSegmentIndex == iValue)
                    break;
                selOffset = selOffset + [width floatValue];
                iValue++;
            }
            return CGRectMake(selOffset + self.selectionIndicatorEdgeInsets.left, indicatorYOffset, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] - self.selectionIndicatorEdgeInsets.right, self.selCursorHeight + self.selectionIndicatorEdgeInsets.bottom);
        }
        return CGRectMake((self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * self.selectedSegmentIndex, indicatorYOffset, self.segmentWidth - self.selectionIndicatorEdgeInsets.right, self.selCursorHeight);
    }
}

- (CGRect)frameForFillerSelectionIndicator {
    if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
        CGFloat selOffset = 0.0f; NSInteger iValue = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == iValue) { break; }
            selOffset = selOffset + [width floatValue];
            iValue++;
        }
        return CGRectMake(selOffset, 0, [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue], CGRectGetHeight(self.frame));
    }
    return CGRectMake(self.segmentWidth * self.selectedSegmentIndex, 0, self.segmentWidth, CGRectGetHeight(self.frame));
}

- (void)updateSegmentsRects {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    if ([self sectionCount] > 0) {
        self.segmentWidth = self.frame.size.width / [self sectionCount];
    }
    if (self.type == PHSegmentedControlTypeText && self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
        [self typeTextStyleFixed];
    } else if (self.type == PHSegmentedControlTypeText && self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
        [self typeTextStyleDynamic];
    } else if (self.type == PHSegmentedControlTypeImages) {
        for (UIImage *sectionImage in self.secImgs) {
            CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(imageWidth, self.segmentWidth);
        }
    } else if (self.type == PHSegmentedControlTypeTextImages && self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed){
        [self.secTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
            CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }];
    } else if (self.type == PHSegmentedControlTypeTextImages && self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
        [self typeImagesStyleDynamic];
    }
    self.scrollView.scrollEnabled = self.isUserDraggable;
    self.scrollView.contentSize = CGSizeMake([self totalSegmentedControlWidth], self.frame.size.height);
}

- (void)typeTextStyleFixed {
    [self.secTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
        self.segmentWidth = MAX(stringWidth, self.segmentWidth);
    }];
}

- (void)typeTextStyleDynamic {
    NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
    __block CGFloat totalWidth = 0.0;
    [self.secTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
        totalWidth += stringWidth;
        [mutableSegmentWidths addObject:[NSNumber numberWithFloat:stringWidth]];
    }];
    if (self.shouldStretchSegmentsToScreenSize && totalWidth < self.bounds.size.width) {
        CGFloat whitespace = self.bounds.size.width - totalWidth;
        CGFloat whitespaceForSegment = whitespace / [mutableSegmentWidths count];
        [mutableSegmentWidths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat extendedWidth = whitespaceForSegment + [obj floatValue];
            [mutableSegmentWidths replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:extendedWidth]];
        }];
    }
    self.segmentWidthsArray = [mutableSegmentWidths copy];
}

- (void)typeImagesStyleDynamic {
    NSMutableArray *mutableSegmentWidths = [NSMutableArray array];
    __block CGFloat totalWidth = 0.0;
    int iValue = 0;
    [self.secTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringWidth = [self measureTitleAtIndex:idx].width + self.segmentEdgeInset.right;
        UIImage *sectionImage = [self.secImgs objectAtIndex:iValue];
        CGFloat imageWidth = sectionImage.size.width + self.segmentEdgeInset.left;
        CGFloat combinedWidth = 0.0;
        if (self.imagePosition == PHSegmentedControlImagePositionLeftOfText || self.imagePosition == PHSegmentedControlImagePositionRightOfText) {
            combinedWidth = imageWidth + stringWidth + self.textImageSpacing;
        } else {
            combinedWidth = MAX(imageWidth, stringWidth);
        }
        totalWidth += combinedWidth;
        [mutableSegmentWidths addObject:[NSNumber numberWithFloat:combinedWidth]];
    }];
    if (self.shouldStretchSegmentsToScreenSize && totalWidth < self.bounds.size.width) {
        CGFloat whitespace = self.bounds.size.width - totalWidth;
        CGFloat whitespaceForSegment = whitespace / [mutableSegmentWidths count];
        [mutableSegmentWidths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat extendedWidth = whitespaceForSegment + [obj floatValue];
            [mutableSegmentWidths replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:extendedWidth]];
        }];
    }
    self.segmentWidthsArray = [mutableSegmentWidths copy];
}

- (NSUInteger)sectionCount {
    if (self.type == PHSegmentedControlTypeText) {
        return self.secTitles.count;
    } else if (self.type == PHSegmentedControlTypeImages ||
               self.type == PHSegmentedControlTypeTextImages) {
        return self.secImgs.count;
    }
    
    return 0;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    if (self.secTitles || self.secImgs) {
        [self updateSegmentsRects];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CGRect enlargeRect = [self getEnlargeRect];
    if (CGRectContainsPoint(enlargeRect, touchLocation)) {
        NSInteger segment = 0;
        if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
            segment = (touchLocation.x + self.scrollView.contentOffset.x) / self.segmentWidth;
        } else if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
            CGFloat widthLeft = (touchLocation.x + self.scrollView.contentOffset.x);
            for (NSNumber *width in self.segmentWidthsArray) {
                widthLeft = widthLeft - [width floatValue];
                if (widthLeft <= 0)
                    break;
                segment++;
            }
        }
        NSUInteger sectionsCount = 0;
        if (self.type == PHSegmentedControlTypeImages) {
            sectionsCount = [self.secImgs count];
        } else if (self.type == PHSegmentedControlTypeTextImages || self.type == PHSegmentedControlTypeText) {
            sectionsCount = [self.secTitles count];
        }
        if (segment != self.selectedSegmentIndex && segment < sectionsCount && self.isTouchEnabled) {
            [self setSelectedSegmentIndex:segment animated:self.shouldAnimateUserSelection notify:YES];
        }
    }
}

- (CGRect)getEnlargeRect {
    CGFloat xValue = self.bounds.origin.x;
    CGFloat yValue = self.bounds.origin.y;
    CGFloat wValue = self.bounds.size.width;
    CGFloat hValue = self.bounds.size.height;
    CGFloat lEnlarge = self.enlargeEdgeInset.left;
    CGFloat tEnlarge = self.enlargeEdgeInset.top;
    CGFloat rEnlarge = self.enlargeEdgeInset.right;
    CGFloat bEnlarge = self.enlargeEdgeInset.bottom;
    return CGRectMake(xValue - lEnlarge, yValue - tEnlarge,
               wValue + lEnlarge + rEnlarge,
               hValue + tEnlarge + bEnlarge);
}

#pragma mark - Scrolling

- (CGFloat)totalSegmentedControlWidth {
    if (self.type == PHSegmentedControlTypeText && self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
        return self.secTitles.count * self.segmentWidth;
    } else if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleDynamic) {
        return [[self.segmentWidthsArray valueForKeyPath:@"@sum.self"] floatValue];
    } else {
        return self.secImgs.count * self.segmentWidth;
    }
}

- (void)scrollToSelectedSegmentIndex:(BOOL)animated {
    CGRect rectForSelectedIndex = CGRectZero;
    CGFloat selOffset = 0;
    if (self.segmentWidthStyle == PHSegmentedControlSegmentWidthStyleFixed) {
        rectForSelectedIndex = CGRectMake(self.segmentWidth * self.selectedSegmentIndex,
                                          0,
                                          self.segmentWidth,
                                          self.frame.size.height);
        selOffset = (CGRectGetWidth(self.frame) / 2) - (self.segmentWidth / 2);
    } else {
        NSInteger curIndex = 0;
        CGFloat offsetter = 0;
        for (NSNumber *width in self.segmentWidthsArray) {
            if (self.selectedSegmentIndex == curIndex)
                break;
            offsetter = offsetter + [width floatValue];
            curIndex++;
        }
        rectForSelectedIndex = CGRectMake(offsetter,
                                          0,
                                          [[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue],
                                          self.frame.size.height);
        selOffset = (CGRectGetWidth(self.frame) / 2) - ([[self.segmentWidthsArray objectAtIndex:self.selectedSegmentIndex] floatValue] / 2);
    }
    CGRect rectToScrollTo = rectForSelectedIndex;
    rectToScrollTo.origin.x -= selOffset;
    rectToScrollTo.size.width += selOffset * 2;
    [self.scrollView scrollRectToVisible:rectToScrollTo animated:animated];
}

#pragma mark - Index Change

- (void)setSelectedSegmentIndex:(NSInteger)index {
    _selectedSegmentIndex = index;
    [self setSelectedSegmentIndex:index animated:NO notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    self.selectedSegmentIndex = index;
    [self setSelectedSegmentIndex:index animated:animated notify:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    self.selectedSegmentIndex = index;
    [self setNeedsDisplay];
    if (index == PHSegmentedControlNoSegment) {
        [self.selectionIndicatorArrowLayer removeFromSuperlayer];
        [self.selectionIndicatorStripLayer removeFromSuperlayer];
        [self.selectionIndicatorBoxLayer removeFromSuperlayer];
    } else {
        [self scrollToSelectedSegmentIndex:animated];
        if (animated) {
            [self segmentWithAnimation:index notify:notify];
        } else {
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectionIndicatorArrowLayer.actions = newActions;
            [self setArrowFrame];
            self.selectionIndicatorStripLayer.actions = newActions;
            self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
            self.selectionIndicatorBoxLayer.actions = newActions;
            self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
            if (notify)
                [self notifyForSegmentChangeToIndex:index];
        }
    }
}

- (void)segmentWithAnimation:(NSUInteger)index notify:(BOOL)notify {
    if(self.selectionStyle == PHSegmentedControlSelectionStyleArrow) {
        if ([self.selectionIndicatorArrowLayer superlayer] == nil) {
            [self.scrollView.layer addSublayer:self.selectionIndicatorArrowLayer];
            [self setSelectedSegmentIndex:index animated:NO notify:YES];
            return;
        }
    }else {
        if ([self.selectionIndicatorStripLayer superlayer] == nil) {
            [self.scrollView.layer addSublayer:self.selectionIndicatorStripLayer];
            if (self.selectionStyle == PHSegmentedControlSelectionStyleBox && [self.selectionIndicatorBoxLayer superlayer] == nil)
                [self.scrollView.layer insertSublayer:self.selectionIndicatorBoxLayer atIndex:0];
            [self setSelectedSegmentIndex:index animated:NO notify:YES];
            return;
        }
    }
    if (notify)
        [self notifyForSegmentChangeToIndex:index];
    self.selectionIndicatorArrowLayer.actions = nil;
    self.selectionIndicatorStripLayer.actions = nil;
    self.selectionIndicatorBoxLayer.actions = nil;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.15f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self setArrowFrame];
    self.selectionIndicatorBoxLayer.frame = [self frameForSelectionIndicator];
    self.selectionIndicatorStripLayer.frame = [self frameForSelectionIndicator];
    self.selectionIndicatorBoxLayer.frame = [self frameForFillerSelectionIndicator];
    [CATransaction commit];
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

#pragma mark - Styling Support

- (NSDictionary *)resultingTitleTextAttributes {
    NSDictionary *defaults = @{
        NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
        NSForegroundColorAttributeName : [UIColor blackColor],
    };
    
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    
    if (self.titleTextAttributes) {
        [resultingAttrs addEntriesFromDictionary:self.titleTextAttributes];
    }

    return [resultingAttrs copy];
}

- (NSDictionary *)resultingSelectedTitleTextAttributes {
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:[self resultingTitleTextAttributes]];
    
    if (self.selectedTitleTextAttributes) {
        [resultingAttrs addEntriesFromDictionary:self.selectedTitleTextAttributes];
    }
    
    return [resultingAttrs copy];
}

@end
