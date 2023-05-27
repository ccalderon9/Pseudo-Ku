//
//  ViewController.swift
//  Pseudo-Ku
//
//  Created by Clarissa Calderon on 5/26/23.
//

import UIKit

class BoardViewController: UIViewController {
    
    var numbers: [String] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(SudokuCollectionViewCell.self, forCellWithReuseIdentifier: SudokuCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        let width = (view.frame.size.width - 32 - 8) / 9
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        return collectionView
    }()
    
    var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pseudo-Ku\nor\nSudoku?"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Validate", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()
    
    let viewModel = BoardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.fetchBoard { [weak self] result in
            switch result {
            case .success(let board):
                self?.numbers = board.board.flatMap { $0 }
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching board: \(error)")
            }
        }
    }
    
    @objc func validateBoard() {
        answerLabel.text = viewModel.isValid() ? "Sudoku!" : "Pseudo-Ku!"
    }
    
    func configure() {
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            answerLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 50),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SudokuCollectionViewCell.reuseIdentifier, for: indexPath) as? SudokuCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.label.text = numbers[indexPath.item]
        
        return cell
    }
    
    
}
