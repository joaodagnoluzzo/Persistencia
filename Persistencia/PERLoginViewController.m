//
//  PERLoginViewController.m
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/24/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import "PERLoginViewController.h"
#import "KeychainItemWrapper.h"
#import "PERListaDeTarefasViewController.h"


@interface PERLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldUsuario;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldSenha;


@end

@implementation PERLoginViewController{
 
    KeychainItemWrapper *keychain;
    
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
    
    
    
    self.txtFieldSenha.secureTextEntry = YES;
    
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LoginPersistencia" accessGroup:nil];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLogin"]){
        [self autoLogin];
    }
}


- (IBAction)registrarAction:(UIButton *)sender {
    
    if([self.txtFieldUsuario isFirstResponder]){
        [self.txtFieldUsuario resignFirstResponder];
    }
    
    if([self.txtFieldSenha isFirstResponder]){
        [self.txtFieldSenha resignFirstResponder];
    }
    
    if(self.txtFieldUsuario.text.length == 0 || self.txtFieldSenha.text.length==0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                        message: @"Você deve preencher todos os campos para efetuar o login!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else {
        
        [keychain setObject:self.txtFieldUsuario.text forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:self.txtFieldSenha.text forKey:(__bridge id)kSecValueData];
        
        UIAlertView *alertOK = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                        message: @"Usuário registrado com sucesso!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alertOK show];
        
    }
    
    
}

- (IBAction)loginAction:(UIButton *)sender {
  
    if([self.txtFieldUsuario isFirstResponder]){
        [self.txtFieldUsuario resignFirstResponder];
    }
    
    if([self.txtFieldSenha isFirstResponder]){
        [self.txtFieldSenha resignFirstResponder];
    }
    
    if(self.txtFieldUsuario.text.length == 0 || self.txtFieldSenha.text.length==0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                        message: @"Você deve preencher todos os campos para efetuar o login!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    
    }else if(![self.txtFieldUsuario.text isEqualToString:[keychain objectForKey:(__bridge id)kSecAttrAccount]] || ![self.txtFieldSenha.text isEqualToString:[keychain objectForKey:(__bridge id)kSecValueData]]){
            
            UIAlertView *alertUser = [[UIAlertView alloc] initWithTitle: @"Aviso"
                                                                message: @"Login e/ou senha incorretos!"
                                                               delegate: nil
                                                      cancelButtonTitle:@"Tentar novamente"
                                                      otherButtonTitles:nil];
            [alertUser show];
    }else{
        
        [self autoLogin];
        
    }
    

}

- (void)autoLogin{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    PERListaDeTarefasViewController *plvc = (PERListaDeTarefasViewController *)[storyboard instantiateViewControllerWithIdentifier:@"listaDeTarefas"];
    
    
    [self presentViewController:plvc animated:YES completion:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoff) name:@"Logoff" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)logoff{
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
