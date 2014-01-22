//
//  ViewController.m
//  NACircularControl
//
//  Created by Dronna .com on 25/09/13.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    //Create the Circular Slider
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSValue valueWithCGRect:CGRectMake(0, 124, screenSize.width, screenSize.width)] forKey:kNAFrame];
    
    NACircularControl *circularControl = [[NACircularControl alloc] initWithDict:dict];
    circularControl.backgroundColor = [UIColor grayColor];
    circularControl.delegate = self;
    
    //Define Target-Action behaviour
//    [circularControl addTarget:self action:@selector(newValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:circularControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) NAangleChanged:(int)angle {
    NSLog(@"angle: %d", angle);
}

@end
