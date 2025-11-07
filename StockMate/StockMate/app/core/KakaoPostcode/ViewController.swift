//
//  ViewController.swift
//  StockMate
//
//  Created by Admin on 11/5/25.
//


import UIKit

class ViewController: UIViewController {

    // MARK: - UI Components
    let button = UIButton(type: .system)
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        [label, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        label.text = "주소를 선택하세요"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center

        button.setTitle("주소 검색", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30)
        ])
    }

    @objc
    private func handleButton(_ sender: UIButton) {
        let vc = KakaoZipCodeVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
