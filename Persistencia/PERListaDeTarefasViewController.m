//
//  PERListaDeTarefasViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/24/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERListaDeTarefasViewController.h"
#import "PERAdicionarTarefasViewController.h"

@interface PERListaDeTarefasViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PERListaDeTarefasViewController

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
}

- (IBAction)addAction:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    PERAdicionarTarefasViewController *pavc = (PERAdicionarTarefasViewController *)[storyboard instantiateViewControllerWithIdentifier:@"adicionarTarefas"];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddTask:) name:@"TaskHasBeenAdded" object:nil];
    
    
    [self presentViewController:pavc animated:YES completion:nil];
}

-(void)didAddTask:(NSNotification *)notification{
    
    if(![self.presentedViewController isBeingDismissed]){
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)logoffAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logoff" object:self];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *) tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
