//
//  PERListaDeTarefasViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/24/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERListaDeTarefasViewController.h"
#import "PERAdicionarTarefasViewController.h"
#import "PERAppDelegate.h"
#import "PERMapViewController.h"
#import "Tarefa.h"
#import "Categoria.h"
#import "MSCellAccessory.h"

@interface PERListaDeTarefasViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSManagedObjectContext *context;
@property NSMutableArray *data;

@property NSError *error;
@property NSFetchRequest *fetchRequest;
@property NSEntityDescription *entity;
@property NSArray *fetchedObjects;

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
    
    self.context = [(PERAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tarefa" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    self.data = [[NSMutableArray alloc] init];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
	for (Tarefa *task in fetchedObjects){
        [self.data addObject:task];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];

    
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
    [self performFetchTarefa];
    self.data = [[NSMutableArray alloc] init];
    for (Tarefa *task in self.fetchedObjects){
        [self.data addObject:task];
    }
    [self.tableView reloadData];
}
- (IBAction)customizeAction:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    PERAdicionarTarefasViewController *pcvc = (PERAdicionarTarefasViewController *)[storyboard instantiateViewControllerWithIdentifier:@"configuracoes"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedCustomizing) name:@"dismissConfig" object:nil];
    
    [self presentViewController:pcvc animated:YES completion:nil];
    
}

- (void)didFinishedCustomizing{
    
    if(![self.presentedViewController isBeingDismissed]){
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)logoffAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logoff" object:self];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

-(UITableViewCell *) tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] nome];
    cell.detailTextLabel.text = [[[self.data objectAtIndex:indexPath.row] daCategoria] nome];
    UIColor *cor = [[UIApplication sharedApplication] keyWindow].tintColor;
    
    NSLog(@"%@",[[self.data objectAtIndex:indexPath.row] latitude]);
    
    [cell setAccessoryView:[MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:cor]];
    
    
    
    return cell;

}

-(void)performFetchTarefa{
    NSError *error= self.error;
	self.fetchRequest = [[NSFetchRequest alloc] init];
	self.entity = [NSEntityDescription entityForName:@"Tarefa" inManagedObjectContext:self.context];
	[self.fetchRequest setEntity:self.entity];
    self.fetchedObjects = [self.context executeFetchRequest:self.fetchRequest error:&error];
    self.error = error;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"gotoMapa"]){
        
        
        PERMapViewController *pmvc = (PERMapViewController *)segue.destinationViewController;
        
        Tarefa *task = [self.data objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        
        
        NSLog(@"%@", task.nome);
        NSLog(@"%d",[self.tableView indexPathForSelectedRow].row);
        
        NSLog(@"%f",task.latitude.doubleValue);
        NSLog(@"%f",task.longitude.doubleValue);
        
        pmvc.taskLocation = CLLocationCoordinate2DMake(task.latitude.doubleValue, task.longitude.doubleValue);
        pmvc.pinTitle = task.nome;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMap) name:@"closeMap" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noLocation) name:@"noLocation" object:nil];
        
    }
    
}

-(void)closeMap{
    if(![self.presentedViewController isBeingDismissed]){
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)noLocation{
    if(![self.presentedViewController isBeingDismissed]){
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                        message: @"Não existe local para esta tarefa!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    
    }
}

-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView beginUpdates];
    
    // Busca os objetos
    [self performFetchTarefa];
	
	// Listar os objetos
   
    Tarefa *tarefa = [self.fetchedObjects objectAtIndex:indexPath.row];
    
    [self.context deleteObject:tarefa];
	
    [self performFetchTarefa];
    self.data = [[NSMutableArray alloc] initWithArray:self.fetchedObjects];
    
    NSError *error = self.error;
    if (![self.context save:&error])
	{
		NSLog(@"Erro ao salvar: %@", [error localizedDescription]);
	}
	else
	{
		NSLog(@"Salvo com sucesso!");
	}
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self removeItemAtIndexPath:indexPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
