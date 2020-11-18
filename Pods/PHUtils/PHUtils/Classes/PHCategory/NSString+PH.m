//
//  NSString+PH.m
//  Pods-PHToolKitsSDK_Example
//
//  Created by 耿葱 on 2019/10/23.
//

#import "NSString+PH.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sys/utsname.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#import "AESCipher.h"

@implementation NSString (PH)

//判断手机号是否有效
+ (BOOL)ph_isValidPhoneNumber:(NSString *)phoneNumber {
    NSString *MOBILE = @"^[1][0-9]{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:phoneNumber] == YES)
    {
        return YES;
    }
    return NO;
}

//判断邮箱是否有效
+ (BOOL)ph_isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否是纯数字
+ (BOOL)ph_isValidNumber:(NSString *)string {
    NSString *regex = @"[0-9]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否包含数字
+ (BOOL)ph_isContainNumber:(NSString *)string {
    NSString *regex = @".*[0-9]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否包含大写
+ (BOOL)ph_isContainUppercase:(NSString *)string {
    NSString *regex = @".*[A-Z]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否包含小写
+ (BOOL)ph_isContainLowercase:(NSString *)string {
    NSString *regex = @".*[a-z]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否包含符号
+ (BOOL)ph_isContainSymbols:(NSString *)string {
    NSString *regex=@".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？+-]+.*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//判断是否连续字符或连续相同字符超过2个(连续指大小写字母或阿拉伯数字的ascii码相连)
+ (BOOL)ph_isContinueString:(NSString *)string {
    if ([NSString ph_isNilOrEmpty:string]) {
        return  NO;
    }
    NSString *baseChars = @"abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int i = 0; i < string.length - 1; i++) {
        if (i > 0 && i+1 <= string.length - 1) {
            NSString *frontChar = [string substringWithRange:NSMakeRange(i-1, 1)];
            NSString *currentChar = [string substringWithRange:NSMakeRange(i, 1)];
            NSString *nextChar = [string substringWithRange:NSMakeRange(i+1, 1)];
            NSLog(@"currentChar is %@, nextChar is %@",currentChar,nextChar);
            if ([currentChar isEqualToString:frontChar] && [currentChar isEqualToString:nextChar]) {
                return YES;
            }
            if ([baseChars containsString:currentChar] && [baseChars containsString:nextChar] && [baseChars containsString:frontChar]) {
                int frontAsciiCode = [frontChar characterAtIndex:0];
                int currAsciiCode = [currentChar characterAtIndex:0];
                int nextAsciiCode = [nextChar characterAtIndex:0];
                NSLog(@"currentChar AscII is %d,nextChar AscIIcode is %d",currAsciiCode,nextAsciiCode);
                if (((currAsciiCode - frontAsciiCode)==1 && (nextAsciiCode - currAsciiCode)==1)
                    || ((currAsciiCode - frontAsciiCode)==-1 && (nextAsciiCode - currAsciiCode)==-1))  {
                    return YES;
                }
            }
        }
    }
    return NO;
}

//是否有汉字
+ (BOOL)ph_isChineseCharacters:(NSString *)string {
    NSString * regex        = @".*[\\u4e00-\\u9faf].*";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//是否是空字符串
+ (BOOL)ph_isNilOrEmpty:(NSString *)value {
    if (value && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSString class]]) {
        NSCharacterSet *chracter = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimValue = [value stringByTrimmingCharactersInSet:chracter];
        if (trimValue.length > 0) {
            return NO;
        }
        return YES;
    }
    return YES;
}

//字符串是否非空并且非Nil
+ (BOOL)ph_notNilAndNotEmpty:(NSString *)value {
    return ![self ph_isNilOrEmpty:value];
}

//计算一个字符串在特定区域的CGSize
+ (CGSize)ph_boundSizeWithString:(NSString *)valueStr font:(UIFont *)font size:(CGSize)originSize {
    NSString *orgStr = valueStr;
    CGSize size = originSize;
    CGSize labelsize;
    if ([orgStr respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        if (@available(iOS 7.0, *)) {
            NSStringDrawingOptions firstOpt = NSStringDrawingUsesLineFragmentOrigin;
            NSStringDrawingOptions secdOpt = NSStringDrawingUsesFontLeading;
            NSStringDrawingOptions opt = (firstOpt|secdOpt);
            NSDictionary *att = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
            CGRect lbRect = CGRectZero;
            lbRect = [orgStr boundingRectWithSize:size options:opt attributes:att context:nil];
            labelsize = lbRect.size;
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSLineBreakMode mode = NSLineBreakByWordWrapping;
        labelsize = [orgStr sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
#pragma clang diagnostic pop
    }
    
    return CGSizeMake(ceilf(labelsize.width), ceilf(labelsize.height));
}

- (NSString *)ph_md5String {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(NSString *)ph_stringValueDecode {
    NSString * result=[(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)ph_base64Decode {
    NSData * base64String = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:base64String encoding:NSUTF8StringEncoding];
}

- (NSString *)ph_base64Encode {
    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSData * nsdata = [[NSString stringWithFormat:@"%@",self] dataUsingEncoding:encoding];
    return [nsdata base64EncodedStringWithOptions:0];
}

- (NSString *)ph_stringValueEncode {
    CFAllocatorRef allocator = kCFAllocatorDefault;
    CFStringRef org = (__bridge CFStringRef)self;
    CFStringRef cha = NULL;
    CFStringRef lega = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    CFStringRef res=CFURLCreateStringByAddingPercentEscapes(allocator, org, cha, lega, encoding);
    NSString *result = (__bridge NSString *)(res);
    return result;
}

+ (NSMutableDictionary *)ph_createFontAttributedDicWtihLineSpacing:(CGFloat)lineSpacing fontSize:(CGFloat)fontSize {
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing - (fontSize*1.1933 - fontSize);
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setValue:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    return attributes;
}

- (BOOL)ph_isContainString:(NSString *)string {
    NSString * str = [string lowercaseString];
    if((str == nil) || [str isEqual:[NSNull null]]){
        return NO;
    }
    if ([[self lowercaseString] rangeOfString:str].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (CGFloat)ph_widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    CGFloat width = 0;
    if (self.length) {
        NSStringDrawingOptions opt1 = NSStringDrawingTruncatesLastVisibleLine;
        NSStringDrawingOptions opt2 = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingOptions opt3 = NSStringDrawingUsesFontLeading;
        NSStringDrawingOptions opts = opt1|opt2|opt3;
        CGSize size = CGSizeMake(MAXFLOAT, 0);
        NSDictionary *attr = attribute;
        CGRect rect = [self boundingRectWithSize:size options:opts attributes:attr context:nil];
        width = rect.size.width;
    }
    return width;
}

- (NSString *)PH_httpReplaceHttps:(NSString *)httpStr {
    if ([httpStr hasPrefix:@"http://"]) {
        return [NSString stringWithFormat:@"https%@",[httpStr substringFromIndex:4]];
    }
    return httpStr;
}

// 去除头尾空格和换行
- (NSString *)ph_stringByTrimmingWhitespaceAndNewline {
    NSCharacterSet *character = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:character];
}

// 将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)ph_htmlEntityDecode:(NSString *)oriString {
    NSString *string = oriString;
    // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return string;
}

// 将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)ph_attributedStringWithHTMLString:(NSString *)htmlString {
    NSMutableDictionary *opt = [NSMutableDictionary dictionary];
    [opt setValue:NSHTMLTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
    [opt setValue:@(NSUTF8StringEncoding) forKey:NSCharacterEncodingDocumentAttribute];
    NSData *dat = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *att = [[NSAttributedString alloc] init];
    att=[[NSAttributedString alloc] initWithData:dat options:opt documentAttributes:nil error:nil];
    return att;
}

// 去掉 HTML 字符串中的标签
+ (NSString *)ph_filterHTML:(NSString *)html {
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    NSString *resultStr = html;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        NSString *replacStr = [NSString stringWithFormat:@"%@>",text];
        resultStr = [html stringByReplacingOccurrencesOfString:replacStr withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return resultStr;
}

/** 获取当前路径下文件的大小 */
- (unsigned long long)fileSize {
    // 总大小
    unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:self isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:self];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [self stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:self error:nil].fileSize;
    }
    return size;
}

+ (NSString *)ph_convertStringSecond:(long)second {
    NSString * theLastTime = nil;
    if (second < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%.2ld", second];
    }else if(second >= 60 && second < 3600){
        theLastTime = [NSString stringWithFormat:@"%.2ld:%.2ld", second/60, second%60];
    }else if(second >= 3600){
        theLastTime = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", second/3600, second%3600/60, second%60];
    }
    return theLastTime;
}

+ (NSString *)ph_formatNumber_w:(NSInteger)count {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    formatter.maximumFractionDigits = 1;
    if (count >= 10000) {
        float wCount = count / 10000.0;
        NSNumber *number = [NSNumber numberWithFloat:wCount];
        NSString *time = [NSString stringWithFormat:@"%@w", [formatter  stringFromNumber:number]];
        if (count % 1000 == 0) {
            time = [NSString stringWithFormat:@"%.1fw",wCount];
        }
        return time;
    } else {
        formatter.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *number = [NSNumber numberWithInteger:count];
        return [formatter stringFromNumber:number];
    }
}

+ (NSString *)ph_encryptWithContent:(NSString *)content
                                key:(NSString *)key
                             vector:(NSString *)vector {
    if ([NSString ph_notNilAndNotEmpty:content] && [NSString ph_notNilAndNotEmpty:key] && [NSString ph_notNilAndNotEmpty:vector]) {
        return aesEncryptString(content, key, vector);
    }
    return @"";
}
@end
