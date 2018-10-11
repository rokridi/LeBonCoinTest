//
//  WeatherDataBaseClient.swift
//  LeBonCoinTest
//
//  Created by Mohamed Aymen Landolsi on 11/10/2018.
//  Copyright © 2018 Rokridi. All rights reserved.
//

import Foundation
import CoreData

public enum DataBaseResult<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

protocol DataBaseStorage {
    
    func fetchAll<Model: Storable>(_ type: Model.Type, completion: @escaping (DataBaseResult<[Model]>)->Void)
    func deleteAll<Model: Storable>(_ type: Model.Type, completion: @escaping(DataBaseResult<Void>)->Void)
    func save<Model: Storable>(_ models: [Model], completion: @escaping(DataBaseResult<[Model]>)->Void)
}

class WeatherCoreDataBaseClient {
    
    private let coreDataControler: CoreDataController
    
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    init(coreDataControler: CoreDataController) {
        self.coreDataControler = coreDataControler
    }
}

extension WeatherCoreDataBaseClient: DataBaseStorage {
        
    func fetchAll<Model: Storable>(_ type: Model.Type, completion: @escaping (DataBaseResult<[Model]>)->Void) {
        queue.addOperation { [weak self] in
            self?.coreDataControler.performBackgroundTask { context in
                
                do {
                    let entities = try Model.DataBaseEntity.fetchAll(in: context).map({ $0.model as! Model })
                    completion(.success(entities))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteAll<Model: Storable>(_ type: Model.Type, completion: @escaping(DataBaseResult<Void>)->Void) {
        queue.addOperation { [weak self] in
            self?.coreDataControler.performBackgroundTask { context in
                do {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Model.DataBaseEntity.entityName)
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(deleteRequest)
                    try context.save()
                    completion(.success(()))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func save<Model: Storable>(_ models: [Model], completion: @escaping(DataBaseResult<[Model]>)->Void) {
        queue.addOperation { [weak self] in
            self?.coreDataControler.performBackgroundTask { context in
                do {
                    let entities = try models.map({ model -> Model.DataBaseEntity in
                        let dbModel  = try Model.DataBaseEntity.create(with: model as! Model.DataBaseEntity.Model, in: context)
                        return dbModel
                    }).map({ $0.model as! Model})
                    try context.save()
                    completion(.success(entities))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }
    }
}
