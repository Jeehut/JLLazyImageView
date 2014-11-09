//
//  JLLazyImageView.m
//  TestApp
//
//  Created by Philip Blatter on 09.11.14.
//  Copyright (c) 2014 Jamit Labs GmbH. All rights reserved.
//

#import "JLLazyImageView.h"

@implementation JLLazyImageView


- (void)loadImageAtURL:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_connection start];
}

- (void)didMoveToSuperview
{
    if (!self.image && _url && !_connection)
    {
        [self loadImageAtURL:_url];
    }
}

- (void)cancelLoading
{
    [_connection cancel];
    _connection = nil;
    _receivedData = nil;
}

#pragma mark NSURL Loading

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // every time we get an response it might be a forward, so we discard what data we have
    _receivedData = nil;
    
    // does not fire for local file URLs
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (id)response;
        
        if (![[httpResponse MIMEType] hasPrefix:@"image"])
        {
            [self cancelLoading];
        }
    }
    
    _receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_receivedData)
    {
        UIImage *image = [[UIImage alloc] initWithData:_receivedData];
        
        self.image = image;
        
        _receivedData = nil;
    }
    
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load image at %@, %@", _url, [error localizedDescription]);
    
    _connection = nil;
    _receivedData = nil;
}


@end
