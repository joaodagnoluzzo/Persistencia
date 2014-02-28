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
#import "PERMapViewController.h"
#import <MapKit/MapKit.h>

@interface PERAdicionarTarefasViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTarefa;
@property NSArray *categorias;
@property NSString *selectedCategory;
@property NSManagedObjectContext *context;
@property CLLocationCoordinate2D location;
@property MKMapView * map;
@property MKPointAnnotation *dropPin;
@property (weak, nonatomic) IBOutlet UILabel *labelLocalizacao;
@property (weak, nonatomic) IBOutlet UISwitch *switchLocalizacao;
@property (weak, nonatomic) IBOutlet UIButton *voltarButton;
@end

@implementation PERAdicionarTarefasViewController{
    
    BOOL firstTimeRenderingMap;

}

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
    
    firstTimeRenderingMap = YES;
    self.map = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.dropPin = [[MKPointAnnotation alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.voltarButton setHidden:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.selectedCategory = [self pickerView:self.pickerView titleForRow:0 forComponent:0];
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
    
        
    newTask.latitude = [[NSNumber alloc] initWithDouble:self.dropPin.coordinate.latitude];
    newTask.longitude = [[NSNumber alloc] initWithDouble:self.dropPin.coordinate.longitude];
        
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
- (IBAction)closeMap:(UIButton *)sender {
    [self.map removeFromSuperview];
    [self.map removeAnnotation:self.dropPin];
    [self.switchLocalizacao setOn:NO];
    [self.voltarButton setHidden:YES];
}

- (IBAction)selecionarNoMapa:(id)sender {
    
    if([self.txtFieldTarefa isFirstResponder]){
        [self.txtFieldTarefa resignFirstResponder];
    }
    
    if(self.switchLocalizacao.isOn){
        [self.view addSubview:self.map];
        self.map.showsUserLocation = YES;
        self.map.delegate = self;
        [self.voltarButton setHidden:NO];
        [self.view bringSubviewToFront:self.voltarButton];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.map addGestureRecognizer:longPressGesture];
    }else {
        [self.switchLocalizacao setOn:NO animated:YES];
        
        self.dropPin.coordinate = CLLocationCoordinate2DMake(0, 0);
        [self.labelLocalizacao setText:@"Selecionar localização?"];
        
    }
    
}

- (void)handleLongPressGesture:(UIGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
    {
        [self.map removeGestureRecognizer:sender];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.map];
        CLLocationCoordinate2D locCoord = [self.map convertPoint:point toCoordinateFromView:self.map];
        
        // Then all you have to do is create the annotation and add it to the map
        
        self.dropPin.coordinate = CLLocationCoordinate2DMake(locCoord.latitude, locCoord.longitude);
        [self.map addAnnotation:self.dropPin];
        [self.map removeGestureRecognizer:sender];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirmação"
                                                        message: @"Este é o local correto?"
                                                       delegate: nil
                                              cancelButtonTitle:@"Sim"
                                              otherButtonTitles:@"Não",nil];
        [alert show];
        alert.delegate = self;
    }

}

-(void)salvaLocalizacao{
    self.location = CLLocationCoordinate2DMake(self.dropPin.coordinate.latitude, self.dropPin.coordinate.longitude);
    [self.map removeFromSuperview];
    [self.map removeAnnotation:self.dropPin];
    [self.labelLocalizacao setText:@"Localização salva!"];
}

-(void)liberaSelecao{
    [self.map removeAnnotation:self.dropPin];
    [self.map addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    if(buttonIndex == 0) [self salvaLocalizacao];
    
    switch (buttonIndex) {
        case 0:
            [self salvaLocalizacao];
            break;
        default:
            [self liberaSelecao];
            break;
    }

}



-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered{
    if(firstTimeRenderingMap){
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.map.userLocation.coordinate,1000, 1000);
        [self.map setRegion:viewRegion animated:YES];
        firstTimeRenderingMap = NO;
    }
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
