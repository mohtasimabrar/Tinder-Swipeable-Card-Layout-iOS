//
//  CardView.swift
//  Tinder Card Animation
//
//  Created by Mohtasim Abrar Samin on 20/6/22.
//

import UIKit

import UIKit

protocol CardViewDelegate: AnyObject {
    func didTapDetailButton()
}

enum CardViewContext {
    case front, back
}

class CardView: UIView {
    
    var detailButton: UIButton = {
        $0.setTitle("Details", for: .normal)
        $0.backgroundColor = .lightGray
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        
        return $0
    }(UIButton())
    
    var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Hello World!"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return $0
    }(UILabel())
    
    var detailLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of 'de Finibus Bonorum et Malorum' (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, 'Lorem ipsum dolor sit amet..', comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from 'de Finibus Bonorum et Malorum' by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
        
        return $0
    }(UILabel())
    
    var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        
        return $0
    }(UIScrollView())
    
    private var customConstraints = [NSLayoutConstraint]()
    
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        
        scrollView.addSubview(detailLabel)
        [titleLabel, scrollView, detailButton].forEach {
            addSubview($0)
        }
        
        setupView(context: .front)
    }
    
    func setupView(context: CardViewContext){
        clearConstraints()
        switch context {
        case .front:
            backgroundColor = .darkGray
            scrollView.isHidden = true
            detailButton.setTitle("Details", for: .normal)
            titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
            titleLabel.textColor = .white
            let frontConstraints = [
                detailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                detailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                detailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                detailButton.heightAnchor.constraint(equalToConstant: 50),
                
                titleLabel.bottomAnchor.constraint(equalTo: detailButton.topAnchor, constant: -12),
                titleLabel.leadingAnchor.constraint(equalTo: detailButton.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: detailButton.trailingAnchor)
            ]
            activate(constraints: frontConstraints)
        case .back:
            backgroundColor = .darkGray
            scrollView.isHidden = false
            detailButton.setTitle("Back", for: .normal)
            titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
            titleLabel.textColor = .white
            detailLabel.textColor = .white
            let backConstraints = [
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: detailButton.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: detailButton.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 30),
                
                scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                scrollView.bottomAnchor.constraint(equalTo: detailButton.topAnchor, constant: -8),
                scrollView.leadingAnchor.constraint(equalTo: detailButton.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: detailButton.trailingAnchor),
                
                detailLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
                detailLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                detailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                detailButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
                detailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                detailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                detailButton.heightAnchor.constraint(equalToConstant: 50)
            ]
            activate(constraints: backConstraints)
        }
    }
    
    private func activate(constraints: [NSLayoutConstraint]) {
        customConstraints.append(contentsOf: constraints)
        customConstraints.forEach { $0.isActive = true }
    }

    private func clearConstraints() {
        customConstraints.forEach { $0.isActive = false }
        customConstraints.removeAll()
    }
    
    @objc func detailButtonTapped() {
        delegate?.didTapDetailButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
