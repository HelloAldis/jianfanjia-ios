//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ItemImageCollectionCell.h"

@interface ItemImageCollectionCell ()

@property(strong, nonatomic) UIImage *normalImage;
@property(strong, nonatomic) UIImage *editingImage;
@property(strong, nonatomic) NSString *titleText;
@property(assign, nonatomic) BOOL isEditing;
@property(assign, nonatomic) BOOL isRemovable;
@property(strong, nonatomic) UIButton *deleteButton;
@property(strong, nonatomic) UIButton *button;
@property(assign, nonatomic) NSInteger index;
@property(assign, nonatomic) CGPoint point;//long press point

@end

@implementation ItemImageCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable {
    self = [super initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.normalImage = [UIImage imageNamed:imageName];
        self.titleText = title;
        self.isEditing = NO;
        self.index = aIndex;
        self.isRemovable = removable;
        
        
        // place a clickable button on top of everything
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.button setFrame:self.bounds];
        [self.button setBackgroundImage:self.normalImage forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor clearColor]];
        [self.button setTitle:self.titleText forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        longPress = nil;
        [self addSubview:self.button];
        
        if (self.isRemovable) {
            // place a remove button on top right corner for removing item from the board
            self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float w = 20;
            float h = 20;
            
            [self.deleteButton setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, w, h)];
            [self.deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
            self.deleteButton.backgroundColor = [UIColor clearColor];
            [self.deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.deleteButton setHidden:YES];
            [self addSubview:self.deleteButton];
        }
    }
    return self;
}

#pragma mark - UI actions

- (void) clickItem:(id)sender {
    [self.delegate gridItemDidClicked:self];
}
- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer{
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.point = [gestureRecognizer locationInView:self];
            [self.delegate gridItemDidEnterEditingMode:self];
            //放大这个item
            [self setAlpha:1.0];
            NSLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            self.point = [gestureRecognizer locationInView:self];
            [self.delegate gridItemDidEndMoved:self withLocation:self.point moveGestureRecognizer:gestureRecognizer];
            //变回原来大小
            [self setAlpha:0.5f];
            NSLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            
            [self.delegate gridItemDidMoved:self withLocation:self.point moveGestureRecognizer:gestureRecognizer];
            NSLog(@"press long changed");
            break;
        default:
            NSLog(@"press long else");
            break;
    }
    
    //CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    
}

- (void) removeButtonClicked:(id) sender  {
    [self.delegate gridItemDidDeleted:self atIndex:self.index];
}

#pragma mark - Custom Methods

- (void) enableEditing {
    
    if (self.isEditing == YES)
        return;
    
    // put item in editing mode
    self.isEditing = YES;
    
    // make the remove button visible
    [self.deleteButton setHidden:NO];
    [self.button setEnabled:NO];
    // start the wiggling animation
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    
    // inform the springboard that the menu items are now editable so that the springboard
    // will place a done button on the navigationbar
    //[(SESpringBoard *)self.delegate enableEditingMode];
    
}

- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [self.deleteButton setHidden:YES];
    [self.button setEnabled:YES];
    self.isEditing = NO;
}

# pragma mark - Overriding UiView Methods

- (void) removeFromSuperview {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [self.deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

@end
