//
//  ViewController.h
//  text_to_speech
//
//  Created by Anudeep Perasani on 6/18/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *sentenceTextField;
//@property (strong, nonatomic) IBOutlet UITableView *responseTableView;
@end
