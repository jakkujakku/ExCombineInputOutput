//
//  Data.swift
//  ExCombineInputOutput
//
//  Created by 준우의 MacBook 16 on 4/27/24.
//

import Foundation

struct Data {
    var id: UUID
    var title: String

    init(id: UUID = .init(), title: String) {
        self.id = id
        self.title = title
    }
}
