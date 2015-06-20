//
//  ViewController.m
//  text_to_speech
//
//  Created by Anudeep Perasani on 6/18/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//  Author: Sarath

#import "ViewController.h"
#import "Google_TTS_BySham.h"
#import "AFHTTPRequestOperationManager.h"


@interface ViewController ()

@property  NSArray* tableData;//for table view
@property (nonatomic, strong) NSURLConnection *UNIRest;//for rest connection


@property (nonatomic,strong)Google_TTS_BySham *google_TTS_BySham;//for text to speech


@property (nonatomic, strong) NSArray *gpe;
@property (nonatomic, strong) NSArray *location;
@property (nonatomic, strong) NSArray *measure;
@property (nonatomic, strong) NSArray *noun;
@property (nonatomic, strong) NSArray *verb;


@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
//    _responseTableView.delegate = self;
//    _responseTableView.dataSource = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//speak functionality
- (IBAction)touchToSpeak:(id)sender {
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    [self.google_TTS_BySham speak:@"This is a text to speech sample application by sub group 19"];
}

//processing the text from api
- (IBAction)sentimentApi:(id)sender {
    
    [_sentenceTextField resignFirstResponder];  //To hide the keyboard
    NSString *val1 = self.sentenceTextField.text ;//text input to api
    
    NSLog(@"input:%@",val1);
    
    NSString* classURL = [NSString  stringWithFormat: @"https://japerk-text-processing.p.mashape.com/phrases/"];//api url call
    NSURL* url = [NSURL URLWithString:classURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //api initial start
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Qc4vfevoBPmshIBVOgdZ0ZvlaCfap1fQ2sNjsnNvMvqyQs0CiR" forHTTPHeaderField:@"X-Mashape-Key"];//api key
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];//api headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //NSString *postString = @"text=california is nice!";
    NSString *postString = [NSString stringWithFormat:@"text=%@",val1];//api input parameters
    
    NSLog(@"parameter:%@",postString);
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    

    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    self.google_TTS_BySham = [[Google_TTS_BySham alloc] init];
    __block NSDictionary *json;
    NSError *error;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               json = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                               
     NSLog(@"Async JSON: %@", json);
                               if(!json)
                               {
                                   NSLog(@"Error: %@", error);
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:[error description]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"Ok"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                               else{
                              
                              
                               _gpe = [json objectForKey:@"gpe"];
                               _location = [json objectForKey:@"location"];
                               _measure = [json objectForKey:@"measure"];
                               _noun = [json objectForKey:@"np"];
                               _verb = [json objectForKey:@"vp"];
                                   
                               
                                   if([json objectForKey:@"NP"])
                                   {
                                       AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Hi! my name is Robome"];
                                       [utterance setRate:AVSpeechUtteranceMaximumSpeechRate/2];
                                       [utterance setRate:0.5f];
                                       [synthesizer speakUtterance:utterance];
                                       //[self.google_TTS_BySham speak:@"Hi! my name is Robo. Me"];
                                   }
                                   else if([json objectForKey:@"PER"])
                                   {
                                       NSString *ouputSpeech = [NSString stringWithFormat:@"Your noun phrase is %@",_noun];
                                       AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:ouputSpeech];
                                       [utterance setRate:0.5f];
                                       [synthesizer speakUtterance:utterance];
                                       
                                       //[self.google_TTS_BySham speak:@"Hi! your noun phrase is"];
                                       //[self.google_TTS_BySham speak:@"%@",val1];
                                       //[_responseTableView reloadData];
                                   }

                               }
                          }];
                         
}

//#pragma mark - UITableView Datasource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [_gpe count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if(cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"GPE:%@", [_gpe objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"Location:%@", [_location objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"Measure:%@", [_measure objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"Noun Phrase:%@", [_noun objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [NSString stringWithFormat:@"Verb Phrase:%@", [_verb objectAtIndex:indexPath.row]];
//    return cell;
//}
//
//#pragma mark - UITableView Delegate methods
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    //Used to handle the tap on a Table view row.
//}
//

@end
