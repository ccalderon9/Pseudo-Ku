//
//  SudokuCollectionViewCell.swift
//  Pseudo-Ku
//
//  Created by Clarissa Calderon on 5/26/23.
//

import UIKit

class SudokuCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Cell"
    
    private lazy var stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var stackView3: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var parentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with numbers: [String]) {
        let newNumbers = numbers.map { $0 == "." ? "•" : $0 }
        
        newNumbers[0...2].forEach {
            generateLabel(for: $0, in: stackView1)
        }
        
        newNumbers[3...5].forEach {
            generateLabel(for: $0, in: stackView2)
        }
        
        newNumbers[6...8].forEach {
            generateLabel(for: $0, in: stackView3)
        }
        
        parentStackView.addArrangedSubview(stackView1)
        parentStackView.addArrangedSubview(stackView2)
        parentStackView.addArrangedSubview(stackView3)
    }
    
    private func generateLabel(for element: String, in stackView: UIStackView) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = element
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: element == "•" ? 28 : 24, weight: .regular)
        label.textColor = element == "•" ? UIColor(red: 250/255, green: 113/255, blue: 106/255, alpha: 1) : UIColor(red: 81/255, green: 85/255, blue: 88/255, alpha: 1)
        stackView.addArrangedSubview(label)
    }
    
    private func setupUI() {
        backgroundColor = .white.withAlphaComponent(0.9)
        clipsToBounds = false
        
        layer.cornerRadius = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        
        contentView.addSubview(parentStackView)
        
        let padding: CGFloat = 14
        
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            parentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            parentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            parentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
}
