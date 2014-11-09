//
//  JLLazyImageView.h
//  TestApp
//
//  Created by Philip Blatter on 09.11.14.
//  Copyright (c) 2014 Jamit Labs GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLLazyImageView : UIImageView {    
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
}

@property (nonatomic, retain) NSURL *url;

- (void)cancelLoading;


@end
