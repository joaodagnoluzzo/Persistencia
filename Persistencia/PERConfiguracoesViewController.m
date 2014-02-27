//
//  PERConfiguracoesViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/25/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERConfiguracoesViewController.h"

@interface PERConfiguracoesViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *sizeStepper;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property UIColor *currentColor;
@property (weak, nonatomic) IBOutlet UIButton *savoyeFont;
@property (weak, nonatomic) IBOutlet UIButton *timesFont;
@property UIFont *currentFont;
@property (weak, nonatomic) IBOutlet UIButton *defaultFont;
@end

@implementation PERConfiguracoesViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.currentFont = [UIFont fontWithName:[prefs objectForKey:@"Fonte"] size:[prefs integerForKey:@"TamFonte"]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%.0f",[prefs floatForKey:@"TamFonte"]];
    self.sizeStepper.value = [prefs integerForKey:@"TamFonte"];
}

-(void)atualizaLabels{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    self.redLabel.text = [NSString stringWithFormat:@"%.1f", [prefs floatForKey:@"Red"]];
    self.greenLabel.text = [NSString stringWithFormat:@"%.1f", [prefs floatForKey:@"Green"]];
    self.blueLabel.text = [NSString stringWithFormat:@"%.1f", [prefs floatForKey:@"Blue"]];
    self.redSlider.value = [self.redLabel.text floatValue];
    self.greenSlider.value = [self.greenLabel.text floatValue];
    self.blueSlider.value = [self.blueLabel.text floatValue];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    self.currentColor = window.tintColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self atualizaLabels];
    
    self.defaultFont.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    self.defaultFont.titleLabel.font = [UIFont fontWithName:@"Savoye LET" size:15];
    self.defaultFont.titleLabel.font = [UIFont fontWithName:@"Times New Roman" size:15];
    
}

-(void)atualizaCores{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    window.tintColor = [UIColor colorWithRed:[self.redSlider value]/255 green:[self.greenSlider value]/255 blue:[self.blueSlider value]/255 alpha:1.0];
}

- (IBAction)redSliderChanged:(UISlider *)sender {
    self.redLabel.text = [NSString stringWithFormat:@"%.1f", [self.redSlider value]];
    [self atualizaCores];
}

- (IBAction)greenSliderChanged:(UISlider *)sender {
    self.greenLabel.text = [NSString stringWithFormat:@"%.1f", [self.greenSlider value]];
    [self atualizaCores];

}

- (IBAction)blueSliderChanged:(UISlider *)sender {
    self.blueLabel.text = [NSString stringWithFormat:@"%.1f", [self.blueSlider value]];
    [self atualizaCores];
}

- (IBAction)changeFont:(id)sender {
    UIFont *fonte = [[(UIButton *)sender titleLabel] font];
    [[UILabel appearance] setFont:[UIFont fontWithName:self.currentFont.fontName size:self.sizeStepper.value]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[fonte fontName] forKey:@"Fonte"];
    [prefs synchronize];
    
}
- (IBAction)fontStepper:(UIStepper *)sender {
    self.sizeLabel.text = [NSString stringWithFormat:@"%.0f",[self.sizeStepper value]];
    [[UILabel appearance] setFont:[UIFont fontWithName:self.currentFont.fontName size:self.sizeStepper.value]];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:self.sizeStepper.value forKey:@"TamFonte"];
    [prefs synchronize];
    
}

- (IBAction)concluidoAction:(id)sender {
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:self.redSlider.value forKey:@"Red"];
    [prefs setFloat:self.greenSlider.value  forKey:@"Green"];
    [prefs setFloat:self.blueSlider.value  forKey:@"Blue"];
    [prefs synchronize];
    NSLog(@"%f,%f,%f", self.redSlider.value, self.greenSlider.value,self.blueSlider.value );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissConfig" object:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
