//
//  Categoria.h
//  Persistencia
//
//  Created by Admin on 25/02/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tarefa;

@interface Categoria : NSManagedObject

@property (nonatomic, retain) NSString * nomeCategoria;
@property (nonatomic, retain) NSSet *tarefaCategoria;
@end

@interface Categoria (CoreDataGeneratedAccessors)

- (void)addTarefaCategoriaObject:(Tarefa *)value;
- (void)removeTarefaCategoriaObject:(Tarefa *)value;
- (void)addTarefaCategoria:(NSSet *)values;
- (void)removeTarefaCategoria:(NSSet *)values;

@end
