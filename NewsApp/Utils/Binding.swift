//
//  Bindings.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            listeners.forEach ({
                $0(value)
            })
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    func bind(_ listener: @escaping((T?) -> Void)) {
        listener(value)
        self.listeners.append(listener)
    }
}
