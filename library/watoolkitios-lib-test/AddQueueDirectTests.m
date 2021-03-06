/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "AddQueueDirectTests.h"
#import "WAToolkit.h"

@implementation AddQueueDirectTests

#ifdef INTEGRATION_DIRECT

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [directClient deleteQueueNamed:randomQueueNameString withCompletionHandler:^(NSError *error) {
        STAssertNil(error, @"Error returned from deleteQueue: %@",[error localizedDescription]);
        [directDelegate markAsComplete];
    }];
    [directDelegate waitForResponse];
    
    [super tearDown];
}

-(void)testShouldAddQueueWithCompletionHandlerDirect
{   
    [directClient addQueueNamed:randomQueueNameString withCompletionHandler:^(NSError *error) {
        STAssertNil(error, @"Error returned from addQueue: %@",[error localizedDescription]);
        [directDelegate markAsComplete];
    }];
    [directDelegate waitForResponse];
    
    [directClient fetchQueuesWithCompletionHandler:^(NSArray *queues, NSError *error) {
        __block BOOL foundQueue = NO;
        [queues enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
            WAQueue *queue = (WAQueue*)object;
            if ([queue.queueName isEqualToString:randomQueueNameString]) {
                foundQueue = YES;
                *stop = YES;
            }
        }];
        STAssertTrue(foundQueue, @"Did not find the queue that was just added.");
         
        [directDelegate markAsComplete];
    }];
    [directDelegate waitForResponse];
}

#endif

@end
