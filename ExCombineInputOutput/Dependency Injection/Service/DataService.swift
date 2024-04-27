//
//  DataService.swift
//  ExCombineInputOutput
//
//  Created by 준우의 MacBook 16 on 4/27/24.
//

import Combine
import Foundation

protocol DataServiceProtocol {
    var datas: [Data] { get }
    func createData(_ data: Data) -> AnyPublisher<[Data], Error>
    func deleteData(_ data: Data) -> AnyPublisher<[Data], Error>
}

final class DataService: DataServiceProtocol {
    var datas: [Data]

    init(datas: [Data] = []) {
        self.datas = datas
    }

    /// 데이터가 추가된 Data 배열 값  발행
    func createData(_ data: Data) -> AnyPublisher<[Data], Error> {
        return Future<[Data], Error> { [weak self] promise in
            guard let self = self else { return }
            datas.append(data)
            promise(.success(datas))
        }
        .eraseToAnyPublisher()
    }

    /// 특정 데이터 삭제된 후 Data 배열 값  발행
    func deleteData(_ data: Data) -> AnyPublisher<[Data], Error> {
        return Future<[Data], Error> { [weak self] promise in
            guard let self = self else { return }
            if let index = self.datas.firstIndex(where: { $0.id == data.id }) {
                datas.remove(at: index)
                promise(.success(datas))
            }
        }
        .eraseToAnyPublisher()
    }
}
