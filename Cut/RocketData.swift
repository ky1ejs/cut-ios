//
//  RocketData.swift
//  Cut
//
//  Created by Kyle McAlpine on 15/03/2018.
//  Copyright © 2018 Kyle McAlpine. All rights reserved.
//

import RocketData

extension DataModelManager {
    static let sharedInstance = DataModelManager(cacheDelegate: MockCacheDelegate())
}

extension DataProvider {
    convenience init() {
        self.init(dataModelManager: DataModelManager.sharedInstance)
    }
}

extension CollectionDataProvider {
    convenience init(cacheKey: String?) {
        self.init(dataModelManager: DataModelManager.sharedInstance)
    }
}

struct MockCacheDelegate {}
extension MockCacheDelegate: CacheDelegate {
    func modelForKey<T>(_ cacheKey: String?, context: Any?, completion: @escaping (T?, NSError?) -> ()) where T : SimpleModel {
        completion(nil, nil)
    }
    
    func setModel(_ model: SimpleModel, forKey cacheKey: String, context: Any?) {
        
    }
    
    func collectionForKey<T>(_ cacheKey: String?, context: Any?, completion: @escaping ([T]?, NSError?) -> ()) where T : SimpleModel {
        completion(nil, nil)
    }
    
    func setCollection(_ collection: [SimpleModel], forKey cacheKey: String, context: Any?) {
        
    }
    
    func deleteModel(_ model: SimpleModel, forKey cacheKey: String?, context: Any?) {
        
    }
}
