//
//  Categoria.h
//  Persistencia
//
//  Created by João Pedro Cappelletto D'Agnoluzzo on 2/25/14.
//  Copyright (c) 2014 João Pedro Cappelletto D'Agnoluzzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tarefa;

@interface Categoria : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *tarefa;
@end

@interface Categoria (CoreDataGeneratedAccessors)

- (void)addTarefaObject:(Tarefa *)value;
- (void)removeTarefaObject:(Tarefa *)value;
- (void)addTarefa:(NSSet *)values;
- (void)removeTarefa:(NSSet *)values;

@end
