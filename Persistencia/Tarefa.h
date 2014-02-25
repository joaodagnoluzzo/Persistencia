//
//  Tarefa.h
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/25/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categoria;

@interface Tarefa : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) Categoria *daCategoria;

@end
