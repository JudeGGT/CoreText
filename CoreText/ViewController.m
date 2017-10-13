//
//  ViewController.m
//  CoreText
//
//  Created by ggt on 2017/8/11.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "ViewController.h"
#import "GPLabel.h"
#import "GPFrameParserConfig.h"
#import "GPFrameParser.h"

@interface ViewController ()

@property (nonatomic, strong) GPLabel *label; /**< Label */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPLabel *label = [[GPLabel alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200)];
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    self.label = label;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self setImageText];
    [self.label setNeedsDisplay];
}

- (void)setString {
    
    GPFrameParserConfig *config = [[GPFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.view.bounds.size.width;
    GPCoreTextData *data = [GPFrameParser parseContent:@" 按照以上原则，我们将`GPDisplayView`中的部分内容拆开。对于上面的情况，如果我们使用 CoreText 来作为 TableViewCell 的内容，那么就必须在每个 Cell 绘制之前，就知道其需要的绘制高度，否则 UITableView 将无法正常工作。" config:config];
    self.label.coreTextData = data;
    self.label.frame = CGRectMake(0, 100, config.width, data.height);
}

- (void)setAttributedString {
    
    NSString *string = @"按照以上原则，我们将`GPDisplayView`中的部分内容拆开。对于上面的情况，如果我们使用 CoreText 来作为 TableViewCell 的内容，那么就必须在每个 Cell 绘制之前，就知道其需要的绘制高度，否则 UITableView 将无法正常工作。";
    
    GPFrameParserConfig *config = [[GPFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.view.bounds.size.width;
    config.lineSpace = 10;
    
    NSDictionary *dict = [GPFrameParser attributesWithConfig:config];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:string attributes:dict];
    [contentString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, 7)];
    [contentString addAttributes:@{(id)kCTForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:30.0f]} range:NSMakeRange(0, 7)];
    GPCoreTextData *data = [GPFrameParser parseAttributedContent:contentString config:config];
    self.label.coreTextData = data;
    self.label.frame = CGRectMake(0, 100, config.width, data.height);
}

- (void)setImageText {
    
    GPFrameParserConfig *config = [[GPFrameParserConfig alloc] init];
    config.textColor = [UIColor blackColor];
    config.width = self.view.bounds.size.width;
    config.fontSize = 14;
    GPCoreTextData *data = [GPFrameParser parseImageTextContent:@" 按照以上原则，[A8][鄙视]我们将`GPDisplayView`中的部分内容拆开。对于上面的情况，如果我们使用 CoreText 来作为 TableViewCell 的内容，那么就必须在每个 Cell 绘制之前，就知道其需要的绘制高度，否则 UITableView 将无法正常工作。" config:config];
    self.label.coreTextData = data;
    self.label.frame = CGRectMake(0, 100, config.width, data.height);
}


@end
