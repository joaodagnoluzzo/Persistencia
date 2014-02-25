//
//  PERAdicionarTarefasViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/24/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERAdicionarTarefasViewController.h"

@interface PERAdicionarTarefasViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTarefa;
@property NSArray *categorias;
@property NSDictionary *dictionary;
@property NSString *selectedCategory;

@end

@implementation PERAdicionarTarefasViewController

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
    
    self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categorias" ofType:@"plist"]];
    
    self.categorias = [[NSArray alloc]initWithArray:self.dictionary.allKeys copyItems:YES];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
   
    [self.view addGestureRecognizer:tap];
    
}

- (IBAction)doneAction:(UIButton *)sender {

    //falta adicionar na lista
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskHasBeenAdded" object:self];
    
}

- (IBAction)voltarAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskHasBeenAdded" object:self];
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    [self resignGesture];
}

- (void)resignGesture{
    
    if([self.txtFieldTarefa isFirstResponder]){
        [self.txtFieldTarefa resignFirstResponder];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [self.categorias count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    
    return [self.categorias objectAtIndex:row];
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectedCategory = [self pickerView:self.pickerView titleForRow:row forComponent:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
