//
//  PHSafeCollection.m
//  PHUtils
//
//  Created by Hu, Yuping on 2019/11/1.
//

#import "PHSafeCollection.h"


#pragma mark - NSArray
@implementation NSArray (PH)

- (id)ph_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    
    return self[index];
}

+ (id)ph_arrayWithObjects:(const id _Nonnull [ _Nonnull]) objects count:(NSUInteger)cnt{
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objects[i])
        {
            validObjects[count] = objects[i];
            count++;
        }
    }
    
    return [self arrayWithObjects:validObjects count:count];
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (PH)

- (id)ph_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return nil;
    }
    
    return self[index];
}

- (void)ph_addObject:(id)anObject
{
    if (!anObject)
    {
        return;
    }
    [self addObject:anObject];
}

- (void)ph_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count)
    {
        return;
    }
    
    if (!anObject)
    {
        return;
    }
    self[index] = anObject;
}

- (void)ph_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > self.count)
    {
        return;
    }
    
    if (!anObject)
    {
        return;
    }
    
    [self insertObject:anObject atIndex:index];
}

@end

#pragma mark - NSDictionary

@implementation NSDictionary (PH)
+ (instancetype)ph_dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys{
    if (objects && keys) {
        return [self dictionaryWithObject:objects forKey:keys];
    }
    
    return nil;
}

+ (instancetype)ph_dicObjs:(const id [])objs keys:(const id<NSCopying> [])keys cnt:(NSUInteger)cnt
{
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objs[i] && keys[i])
        {
            validObjects[count] = objs[i];
            validKeys[count] = keys[i];
            count ++;
        }
    }
    
    return [self dictionaryWithObjects:validObjects forKeys:validKeys count:count];
}

@end

#pragma mark - NSMutableDictionary

@implementation NSMutableDictionary (PH)

- (void)ph_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!aKey || [self isEmptyStr:aKey])
    {
        return;
    }
    if (!anObject)
    {
        return;
    }
    self[aKey] = anObject;
}

- (BOOL)isEmptyStr:(id)obj {
    if ([obj isKindOfClass:[NSString class]]
        && [self isEmpty:(NSString *)obj]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEmpty:(NSString *)str
{
    return [self isEmptyIgnoringWhitespace:YES str:str];
}

- (BOOL)isEmptyIgnoringWhitespace:(BOOL)ignoreWhitespace str:(NSString *)str
{
    NSString *toCheck = (ignoreWhitespace) ? [self stringByTrimmingWhitespace:str] : str;
    return [toCheck isEqualToString:@""];
}

- (NSString *)stringByTrimmingWhitespace:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

@implementation PHSafeCollection

@end
