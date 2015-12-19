//
//  AppointmentsResult.m
//  MBAPI
//
//  Created by Arrak Rukkharat on 11/4/15.
//  Copyright (c) 2015 Arrak Rukkharat. All rights reserved.
//

#import "AppointmentsResult.h"

@implementation AppointmentsResult
- (void)mapData:(NSData*)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    parentElementName = @"";
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    
    if ([element isEqualToString:@"Appointments"])
    {
        appts = [NSMutableArray new];
        parentElementName = @"Appointments";
    }
    else if ([element isEqualToString:@"Appointment"])
    {
        a = [Appointment new];
        parentElementName = @"Appointment";
    }
    else if ([element isEqualToString:@"Staff"])
    {
        staff = [Staff new];
        parentElementName = @"Staff";
    }
    else if ([element isEqualToString:@"Location"])
    {
        loc = [Location new];
        parentElementName = @"Location";
    }
    else if ([element isEqualToString:@"Program"])
    {
        prg = [ServiceCategory new];
        parentElementName = @"Program";
    }
    else if ([element isEqualToString:@"SessionType"])
    {
        sess = [SessionType new];
        parentElementName = @"SessionType";
    }
    else if ([element isEqualToString:@"ClientService"])
    {
        service = [PurchasedService new];
        parentElementName = @"ClientService";
    }
    else if ([element isEqualToString:@"Client"])
    {
        c = [Client new];
        parentElementName = @"Client";
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Result
    if ([element isEqualToString:@"Status"])
    {
        self.Status = [Utils concate:self.Status :string];
    }
    else if ([element isEqualToString:@"ErrorCode"])
    {
        self.ErrorCode = [string intValue];
    }
    else if ([element isEqualToString:@"ResultCount"])
    {
        self.ResultCount = [string intValue];
    }
    else if ([element isEqualToString:@"Message"])
    {
        self.Message = [Utils concate:self.Message :string];
    }
    
    if ([parentElementName isEqualToString:@"Appointment"])
    {
        [a mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"Client"])
    {
        [c mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"ClientService"])
    {
        [service mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"Staff"])
    {
        [staff mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"Location"])
    {
        [loc mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"SessionType"])
    {
        [sess mapElement:element with:string];
    }
    else if ([parentElementName isEqualToString:@"Program"])
    {
        [prg mapElement:element with:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Finish staff
    if ([elementName isEqualToString:@"Staff"])
    {
        [staff finish];
        a.Staff = staff;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"Client"])
    {
        [c finish];
        a.Client = c;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"Location"])
    {
        [loc finish];
        a.Location = loc;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"ClientService"])
    {
        [service finish];
        a.ClientService = service;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"Program"])
    {
        [prg finish];
        a.ServiceCategory = prg;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"SessionType"])
    {
        [sess finish];
        a.SessionType = sess;
        parentElementName = @"Appointment";
    }
    else if ([elementName isEqualToString:@"Appointment"])
    {
        [a finish];
        [appts addObject:a];
        parentElementName = @"Appointments";
    }
    else if ([elementName isEqualToString:@"Appointments"])
    {
        self.Appointments = (NSArray*)appts;
    }
}
@end
