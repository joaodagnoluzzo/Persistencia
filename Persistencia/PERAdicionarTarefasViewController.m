//
//  PERAdicionarTarefasViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/24/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERAdicionarTarefasViewController.h"
#import "PERAppDelegate.h"
#import "Categoria.h"
#import "Tarefa.h"

@interface PERAdicionarTarefasViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTarefa;
@property NSArray *categorias;
@property NSString *selectedCategory;
@property NSManagedObjectContext *context;

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
  
    self.categorias = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categorias" ofType:@"plist"]];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
   
    [self.view addGestureRecognizer:tap];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.selectedCategory = [self pickerView:self.pickerView titleForRow:0 forComponent:0];
    NSLog(@"%@",self.selectedCategory);
}

- (IBAction)doneAction:(UIButton *)sender {
    
    
    if([[self.txtFieldTarefa text] length]==0){
        UIAlertView *alertUser = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                            message: @"Dê um nome a sua tarefa!"
                                                           delegate: nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertUser show];
    
    }else{
    
    self.context = [(PERAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Tarefa *newTask = (Tarefa *)[NSEntityDescription insertNewObjectForEntityForName:@"Tarefa"
                                                                         inManagedObjectContext:self.context];
    
    Categoria *newCategoria = (Categoria *)[NSEntityDescription insertNewObjectForEntityForName:@"Categoria" inManagedObjectContext:self.context];
    
    newCategoria.nome = self.selectedCategory;
  
    newTask.nome = [self.txtFieldTarefa text];
    newTask.daCategoria = newCategoria;
    
    
    // Salva o Contexto
	NSError *error;
    if (![self.context save:&error])
	{
		NSLog(@"Erro ao salvar: %@", [error localizedDescription]);
	}
	else
	{
		NSLog(@"Salvo com sucesso!");
	}
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaskHasBeenAdded" object:self];
    }
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
    NSLog(@"%@",self.selectedCategory);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
