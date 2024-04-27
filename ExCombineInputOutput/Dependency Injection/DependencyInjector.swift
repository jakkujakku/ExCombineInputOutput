//
//  DependencyInjector.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Foundation

struct DependencyInjector {
    private static var dependencyList: [String: Any] = [:]

    static func resolve<T>() -> T {
        guard let t = dependencyList[String(describing: T.self)] as? T else {
            fatalError("#### No provider registered for type: \(T.self)")
        }
        return t
    }

    static func register<T>(dependency: T) {
        dependencyList[String(describing: T.self)] = dependency
    }
}

// MARK: - 의존성 주입

@propertyWrapper struct Inject<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = DependencyInjector.resolve()
        print("#### Injected: \(wrappedValue)")
    }
}

// MARK: - 의존성 등록

@propertyWrapper struct Provider<T> {
    var wrappedValue: T

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.register(dependency: wrappedValue)
        print("#### Provided: \(wrappedValue)")
    }
}
