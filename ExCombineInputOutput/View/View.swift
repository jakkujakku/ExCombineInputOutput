//
//  ViewController.swift
//  ExCombineInputOutput
//
//  Created by 준우의 MacBook 16 on 4/27/24.
//

import Combine
import UIKit

final class View: UIViewController {
    private let viewModel = ViewModel()
    private let input: PassthroughSubject<ViewModel.Input, Never> = .init()
    private var subscriptions = Set<AnyCancellable>()

    private var tableView = UITableView(frame: .zero, style: .plain)
    private var button = UIButton(frame: .zero)
}

// MARK: - View Life Cycle

extension View {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup View

extension View {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        addView()
        registerCell()

        bind()

        configTableView()
        configButton()
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())

        output.sink { [weak self] event in
            switch event {
            case .loadData:
                self?.tableView.reloadData()
            case .createFail(error: let error):
                print("#### \(error)")
            case .deleteFail(error: let error):
                print("#### \(error)")
            }
        }
        .store(in: &subscriptions)
    }

    private func addView() {
        [tableView, button].forEach { view.addSubview($0) }
    }
}

// MARK: - Configuration Basic View

extension View {
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemOrange

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }

    private func registerCell() {
        tableView.register(DataCell.self, forCellReuseIdentifier: DataCell.identifier)
    }

    private func configButton() {
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Add Button", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 60),
        ])

        button.addAction(UIAction(handler: { _ in
            let data = Data(title: "Hello World")
            self.input.send(.createData(data))
        }), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource

extension View: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datasCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.dataService.datas[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.identifier, for: indexPath) as? DataCell else { return UITableViewCell() }
        cell.backgroundColor = .systemPink
        cell.title.text = item.id.uuidString
        return cell
    }
}

// MARK: - UITableViewDelegate

extension View: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = viewModel.dataService.datas[indexPath.row]
        if editingStyle == .delete {
            input.send(.deleteData(item))
        }
    }
}
