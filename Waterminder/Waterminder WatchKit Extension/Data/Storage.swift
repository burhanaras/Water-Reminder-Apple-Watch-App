//
//  Storage.swift
//  Waterminder WatchKit Extension
//
//  Created by Burhan Aras on 26.08.2020.
//  Copyright © 2020 Carlos Corrêa. All rights reserved.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
  
  private let key: String
  private let defaultValue: T
  
  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get{
      guard let data = UserDefaults.standard.object(forKey: key) else{
        return defaultValue
      }
      
      let value = try? JSONDecoder().decode(T.self, from: data as! Data)
      return value ?? defaultValue
      
    }
    set {
      let data = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(data, forKey: key)
    }
  }
}
