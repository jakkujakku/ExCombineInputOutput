//
//  Dependencies.swift
//  SizeFit
//
//  Created by 준우의 MacBook 16 on 4/12/24.
//

import Foundation

final class Dependencies {
    static let shared = Dependencies()

    @Provider var dataService = DataService() as DataServiceProtocol
}
