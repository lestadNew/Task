//
//  File.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import SwiftKeychainWrapper

class KeychainService {

    /// The standard keychain service.
    static let standard = KeychainService()
    
    let wrapper: KeychainWrapper
    var defaultAccessibility: KeychainItemAccessibility = .alwaysThisDeviceOnly
    
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var jsonEncoder = JSONEncoder()
    
    /// Create a new instance of KeychainService.
    ///
    /// - Parameter wrapper: Custom KeychainWrapper with custom `Service Name` and optional custom `Access Group`. Default is `standard`
    init(wrapper: KeychainWrapper = .standard) {
        self.wrapper = wrapper
    }
    
    // MARK: Set
    
    /// Save a codable object to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - Parameters:
    ///   - value: The codable object to save.
    ///   - key: The key to save the object under.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    /// - Returns: Value successfuly saved if true.
    @discardableResult
    func set<Model: Codable>(_ value: Model, forKey key: Key, accessibility: KeychainItemAccessibility? = nil) -> Bool {
        do {
            let data = try self.jsonEncoder.encode(value)
            return self.wrapper.set(data, forKey: key.rawValue, withAccessibility: accessibility ?? self.defaultAccessibility)
        }
        catch {
            debugPrint(#function, "Errow while encoding model: \(type(of: value).self)")
            return false
        }
    }
    
    /// Save a codable objects array to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - Parameters:
    ///   - values: The codable object to save.
    ///   - key: The key to save the object under.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    func set<Model: Codable>(_ values: [Model], forKey key: Key, accessibility: KeychainItemAccessibility? = nil) {
        let data = NSKeyedArchiver.archivedData(withRootObject: values)
        self.wrapper.set(data, forKey: key.rawValue, withAccessibility: accessibility ?? self.defaultAccessibility)
    }
    
    // MARK: Get
    
    /// Return an object for a specified type and key
    ///
    /// - Parameters:
    ///   - type: An object model type.
    ///   - key: The key to lookup data for.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    /// - Returns: The object associated with the key if it exists. If no data exists, returns nil.
    func model<Model: Codable>(forKey key: Key, accessibility: KeychainItemAccessibility? = nil) -> Model? {
        guard let data = self.wrapper.data(forKey: key.rawValue, withAccessibility: accessibility ?? self.defaultAccessibility) else { return nil }
        do {
            return try self.jsonDecoder.decode(Model.self, from: data)
        } catch {
            debugPrint(#function, "Errow while decoding model: \(Model.self)")
            return nil
        }
    }
    
    /// Returns an objects for a specified type and key
    ///
    /// - Parameters:
    ///   - type: An object model type.
    ///   - key: The key to lookup data for.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    /// - Returns: The objects array associated with the key if it exists. If no data exists, returns nil.
    func models<Model: Codable>(type: Model.Type, forKey key: Key, accessibility: KeychainItemAccessibility? = nil) -> [Model]? {
        return self.wrapper.data(forKey: key.rawValue, withAccessibility: accessibility ?? self.defaultAccessibility).flatMap {
            NSKeyedUnarchiver.unarchiveObject(with: $0) as? [Model]
        }
    }
    
    // MARK: Remove
    
    /// Remove an object associated with a specified key.
    ///
    /// - Parameters:
    ///   - key: The key value to remove data for.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    func removeObject(forKey key: Key, accessibility: KeychainItemAccessibility? = nil) {
        self.wrapper.removeObject(forKey: key.rawValue, withAccessibility: accessibility ?? self.defaultAccessibility)
    }
    
    /// Remove objects associated with a specified keys.
    ///
    /// - Parameters:
    ///   - key: The key value to remove data for.
    ///   - accessibility: Optional accessibility level to use when looking up the keychain item. `defaultAccessibility` will use if value is `nil`
    func removeObjects(forKeys keys: Set<Key>, accessibility: KeychainItemAccessibility? = nil) {
        keys.forEach {
            self.removeObject(forKey: $0, accessibility: accessibility ?? self.defaultAccessibility)
            
        }
    }
    
    /// Remove all keychain data added through `wrapper`. This will only delete items matching the currnt ServiceName and AccessGroup if one is set.
    func removeAll() {
        self.wrapper.removeAllKeys()
    }

}

// MARK: - Models
extension KeychainService {
    
    /// Saved session token model.
    var token: UserModel? {
        get {
            return self.model(forKey: .token)
        }
        set {
            self.set(newValue, forKey: .token)
        }
    }
    
}

// MARK: - Key[enum]
extension KeychainService {
    
    enum Key: String {
        case token = "ArchiveTokenModel"
    }
    
}

