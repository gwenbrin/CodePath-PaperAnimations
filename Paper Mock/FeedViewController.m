//
//  FeedViewController.m
//  Paper Mock
//
//  Created by Gwen Brinsmead on 6/22/14.
//  Copyright (c) 2014 Gwen Brinsmead. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@property UIView *feedView;
@property (assign, nonatomic) CGPoint offsetFromCenter;

@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
    
}

- (void)viewDidLoad
{
    // remove status bar
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    // create frame and imageview for menu
    CGRect menuFrame = CGRectMake(0, 0, 320, 568);
    UIImage *menuImage = [UIImage imageNamed:@"menu"];
    UIImageView *menuImageView = [[UIImageView alloc] initWithFrame:menuFrame];
    menuImageView.image = menuImage;
    [self.view addSubview:menuImageView];
    
    // create feed view (will contain headline and news)
    CGRect feedFrame = CGRectMake(0, 0, 320, 568);
    UIView *feedView = [[UIView alloc] initWithFrame:feedFrame];
    [self.view addSubview:feedView];
    
    // create image view for headline image, add to feed view
    CGRect headlineFrame = CGRectMake(0, 0, 320, 568);
    UIImage *headlineImage = [UIImage imageNamed:@"headline"];
    UIImageView *headlineImageView = [[UIImageView alloc] initWithFrame:headlineFrame];
    headlineImageView.image = headlineImage;
    [feedView addSubview:headlineImageView];
    
    // create scroll view for news feed, add scroll view to feed view
    CGRect newsScrollFrame  = CGRectMake(0, 315, 320, 253);
    UIScrollView *newsScrollView = [[UIScrollView alloc] initWithFrame:newsScrollFrame];
    newsScrollView.contentSize = CGSizeMake(1444,253);
    [feedView addSubview:newsScrollView];
    
    // create image view for news image, add image view to scroll view
    CGRect newsFrame = CGRectMake(0, 0, 1444, 253);
    UIImage *newsImage = [UIImage imageNamed:@"news"];
    UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:newsFrame];
    newsImageView.image = newsImage;
    [newsScrollView addSubview:newsImageView];
    
    // create pan gesture recognizer, add to feed view
    UIPanGestureRecognizer *feedPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onFeedPan:)];
    [feedView addGestureRecognizer:feedPanGestureRecognizer];
    
    // assign feedView to feedView property
    self.feedView = feedView;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)onFeedPan:(UIPanGestureRecognizer *)feedPanGestureRecognizer {
    
    CGPoint point = [feedPanGestureRecognizer locationInView:self.view];
    static CGPoint initialPoint;
    
    if (feedPanGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        
        // calculate offset
        self.offsetFromCenter = CGPointMake(point.x - self.feedView.center.x, point.y - self.feedView.center.y);
        
        // get initial y point
        initialPoint = feedPanGestureRecognizer.self.view.center;
        NSLog(@"initialPoint: %@", NSStringFromCGPoint(initialPoint));

    } else if (feedPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        
        //reposition feedView based on pan
        if (self.feedView.center.y < 284) {
            NSLog(@"dragging up beyond the bounds oh noes: %f", point.y);
            self.feedView.center = CGPointMake(self.feedView.center.x, point.y - self.offsetFromCenter.y);
        } else if (self.feedView.center.y >= 284) {
            NSLog(@"dragging within bounds");
            self.feedView.center = CGPointMake(self.feedView.center.x, point.y - self.offsetFromCenter.y);
        }
        
    } else if (feedPanGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
        
        if (initialPoint.y < self.feedView.center.y) {
            
            // animate re-positioning feedview on down
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1.4 initialSpringVelocity:3 options:0 animations:^{
                self.feedView.center = CGPointMake(self.feedView.center.x, 852 - 44);
            }completion:nil];
            
        } else if (initialPoint.y > self.feedView.center.y) {
            
            // animate re-positioning feedview on up
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1.4 initialSpringVelocity:3 options:0 animations:^{
                self.feedView.center = CGPointMake(self.feedView.center.x, 284);
            }completion:nil];
            
        }
        
    }
    
}

@end









