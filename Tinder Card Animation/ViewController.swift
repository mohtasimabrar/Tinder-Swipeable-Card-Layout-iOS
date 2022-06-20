//
//  ViewController.swift
//  Tinder Card Animation
//
//  Created by Mohtasim Abrar Samin on 9/6/22.
//

import UIKit

class ViewController: UIViewController {
    
    let cardHeight: CGFloat = 500.0
    let cardWidth: CGFloat = 300.0
    let swipeThreshold: CGFloat = 100.0
    
    lazy var card: CardView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.delegate = self
        
        return $0
    }(CardView(frame: CGRect(x: (self.view.frame.width - cardWidth) / 2, y: (self.view.frame.height - cardHeight) / 2, width: cardWidth, height: cardHeight)))
    
    var cardFlipped: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(card)
        view.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        card.addGestureRecognizer(panGesture)
    }
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: nil)
            let degrees: CGFloat = translation.x / 20
            let angle = degrees * .pi / 180
            
            let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
            
            card.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
            
        case .ended:
            handleEnding(gesture)

        default:
            ()
        }
    }
    
    func handleEnding(_ gesture: UIPanGestureRecognizer) {
        let dismissDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > swipeThreshold
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            if shouldDismissCard {
                self.card.frame = CGRect(x: 600 * dismissDirection, y: (self.view.frame.height - self.cardHeight) / 2, width: self.cardWidth, height: self.cardHeight)
            } else {
                self.card.transform = .identity
            }
            
        } completion: { _ in
            if shouldDismissCard {
                self.card.setupView(context: .front)
                self.cardFlipped = false
                self.card.alpha = 0.0
                self.card.transform = .identity
                self.card.frame = CGRect(x: (self.view.frame.width - self.cardWidth) / 2, y: (self.view.frame.height - self.cardHeight) / 2, width: self.cardWidth, height: self.cardHeight)
                UIView.animate(withDuration: 0.25, delay: 0) {
                    self.card.alpha = 1.0
                }
            }
        }
    }
}

extension ViewController: CardViewDelegate {
    func didTapDetailButton() {
        if !cardFlipped {
            cardFlipped = !cardFlipped
            card.setupView(context: .back)
            UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        } else {
            cardFlipped = !cardFlipped
            card.setupView(context: .front)
            UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        
    }
}
