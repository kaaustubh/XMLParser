

#import "XMLParser.h"
#import <dispatch/dispatch.h>

#define kXMLReaderTextNodeKey @"_value_"

@interface XMLParser()
{
    NSXMLParser *parser;
    NSMutableString *currentNodeContent;
    NSString *responseType;
    NSMutableDictionary *childDictionary;
    NSMutableArray *childrenArray;
    BOOL isChildList;
    NSMutableArray *stack;
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    dispatch_queue_t backgroundQueue;
}

@end

@implementation XMLParser


@synthesize returnDictionary=_returnDictionary;


-(id)init
{
    if (self=[super init]) {
        backgroundQueue = dispatch_queue_create("com.vw.xmlparser", NULL);    
    }
    
    return self;
}

-(void) parseData:(NSData *)data completionBlock:(void(^)(id returnDictionary, NSError *error))completionBlock
{
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^
    {
        BOOL success=[parser parse];
        self.returnDictionary=nil;
        if (success)
        {
            self.returnDictionary = [dictionaryStack objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(self.returnDictionary, nil);
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(nil, parser.parserError);
                }
            });
            
        }
    });
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];
        textInProgress = [[NSMutableString alloc] init];
        // Reset the text
    }
    else
    {
        [dictInProgress setObject:@"" forKey:kXMLReaderTextNodeKey];
        textInProgress = [[NSMutableString alloc] init];
    }
    
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}



@end
