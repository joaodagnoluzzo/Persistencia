//
//  Tarefa.h
//  Persistencia
//
//  Created by Admin on 25/02/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categoria;

@interface Tarefa : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * nomeCategoria;
@property (nonatomic, retain) Categoria *tarefaCategoria;

@end
