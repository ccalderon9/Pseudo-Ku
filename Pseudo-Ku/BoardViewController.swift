//
//  ViewController.swift
//  Pseudo-Ku
//
//  Created by Clarissa Calderon on 5/26/23.
//

import UIKit

class BoardViewController: UIViewController {
    
    private var subSections: [[String]] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SudokuCollectionViewCell.self, forCellWithReuseIdentifier: SudokuCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        let width = (view.frame.size.width - 40 - 16) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 8
        return collectionView
    }()
    
    private var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pseudo-Ku\nor\nSudoku?"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 33/255, green: 84/255, blue: 149/255, alpha: 1)
        button.setTitle("Validate", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 30
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        return button
    }()
    
    private let viewModel = BoardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.fetchBoard { [weak self] result in
            switch result {
            case .success(let boardNumbers):
                self?.subSections = boardNumbers
            case .failure(let error):
                print("Error fetching board: \(error)")
            }
        }
    }
    
    @objc private func validateBoard() {
        if viewModel.isValid() {
            answerLabel.text = "✅ Sudoku!"
            answerLabel.textColor = .green
        } else {
            answerLabel.text = "❌ Pseudo-Ku"
            answerLabel.textColor = .red
        }
    }
    
    private func configure() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red: 69/255, green: 155/255, blue: 182/255, alpha: 1).cgColor, UIColor(red: 169/255, green: 241/255, blue: 209/255, alpha: 1).cgColor]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
        
        view.addSubview(collectionView)
        view.addSubview(answerLabel)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(validateBoard), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 48),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SudokuCollectionViewCell.reuseIdentifier, for: indexPath) as? SudokuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: subSections[indexPath.item])
        
        return cell
    }
}
