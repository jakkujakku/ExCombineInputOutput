//
//  ViewModel.swift
//  ExCombineInputOutput
//
//  Created by 준우의 MacBook 16 on 4/27/24.
//

import Combine
import Foundation

protocol ViewModelType {
    associatedtype Input // View -> ViewModel
    associatedtype Output // ViewModel -> View

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}

final class ViewModel: ViewModelType {
    @Inject var dataService: DataServiceProtocol // 의존성 주입

    private let output: PassthroughSubject<Output, Never> = .init()
    private var subcriptions = Set<AnyCancellable>()

    // 뷰로부터 들어오는 입력
    enum Input {
        case createData(Data)
        case deleteData(Data)
    }

    // 뷰모델로부터 뷰로 나가는 출력
    enum Output {
        case loadData([Data])
        case createFail(error: Error)
        case deleteFail(error: Error)
    }

    var datasCount: Int {
        return dataService.datas.count
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .createData(let data):
                createData(data: data)
            case .deleteData(let data):
                deleteData(data: data)
            }
        }
        .store(in: &subcriptions)

        return output.eraseToAnyPublisher()
    }

    private func createData(data: Data) {
        dataService.createData(data)
            .sink { [weak self] completion in
                // 데이터 추가 실패시
                if case .failure(let error) = completion {
                    self?.output.send(.createFail(error: error))
                }
            } receiveValue: { [weak self] datas in
                self?.output.send(.loadData(datas))
            }
            .store(in: &subcriptions)
    }

    private func deleteData(data: Data) {
        dataService.deleteData(data)
            .sink { [weak self] completion in
                // 데이터 삭제 실패시
                if case .failure(let error) = completion {
                    self?.output.send(.deleteFail(error: error))
                }
            } receiveValue: { [weak self] datas in
                self?.output.send(.loadData(datas))
            }
            .store(in: &subcriptions)
    }
}
