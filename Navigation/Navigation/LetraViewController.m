//
//  LetraViewController.m
//  Navigation
//
//  Created by Isabela Mayumi R. Suitsu  on 25/02/14.
//  Copyright (c) 2014 Vinicius Miana. All rights reserved.
//

#import "LetraViewController.h"
#import "Dicionario.h"

@interface LetraViewController ()

@end

@implementation LetraViewController
@synthesize imageView, botPalavra, letra;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithLetra:(char )l{
    self= [super init];
    if (self){
        letra= l;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //casting de char para String
    NSString *l= [NSString stringWithFormat:@"%c", letra];
    
    //titulo da view
    self.title= l;
    
    if (![l isEqualToString:@"A"]){ //na primeira letra não aparece o botão voltar
        UIBarButtonItem *back= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backView:)];
        self.navigationItem.leftBarButtonItem= back;
    } else { //se for A coloca um botao nulo
        //
        UIBarButtonItem *teste = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setLeftBarButtonItem:teste];
    }
    
    if (![l isEqualToString:@"Z"]){ //na última letra nao aparece o botao next
        //botao proximo
        UIBarButtonItem *next= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextView:)];
        self.navigationItem.rightBarButtonItem= next;
    }
    
    Letra *obj= [[[Dicionario sharedInstance]letrasDicionario]objectForKey:l];
    [botPalavra setTitle:obj.palavra forState:UIControlStateNormal];
    [imageView setImage:obj.imagem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextView:(id)sender{
    letra++;
    
    LetraViewController *proximo= [[LetraViewController alloc]initWithLetra:letra];
    [self.navigationController pushViewController:proximo animated:YES];
}

-(void)backView:(id)sender{
//    letra--;
    
    NSArray *viewControllers = [self.navigationController viewControllers]; //array com todas as views abertas
    LetraViewController *anterior = nil;
    
    //if ([viewControllers count]>1) { //se tiver mais de uma view aberta
        anterior = [viewControllers objectAtIndex:[viewControllers count]-2]; //-2 é a view anterior
        anterior.letra--;
    //}
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)botPalavra:(id)sender {
    NSString *l= [NSString stringWithFormat:@"%c", letra];
    Letra *obj= [[[Dicionario sharedInstance]letrasDicionario]objectForKey:l];

    AVSpeechUtterance *som= [[AVSpeechUtterance alloc]initWithString:obj.palavra]; //inicia com a palavra que vai ser lida
    som.rate= AVSpeechUtteranceMinimumSpeechRate; //velocidade
    som.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"pt-br"]; //idioma (ingles: @"en-au")
    AVSpeechSynthesizer *fala= [[AVSpeechSynthesizer alloc]init];
    [fala speakUtterance:som];
}

@end
