//
//  ViewController.swift
//  Milestone X
//
//  Created by Maks Vogtman on 19/04/2023.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var titleLabel: UILabel!
    var buttons = [UIButton]()
    var selectedButtons = [UIButton]()
    var currentIndex = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var pairs = [
        Pair(country: "France", capital: "Paris"),
        Pair(country: "England", capital: "London"),
        Pair(country: "Poland", capital: "Warsaw"),
        Pair(country: "USA", capital: "Washington"),
        Pair(country: "China", capital: "Beijing"),
        Pair(country: "Japan", capital: "Tokio"),
        Pair(country: "Germany", capital: "Berlin"),
        Pair(country: "Spain", capital: "Madrid"),
        Pair(country: "Portugal", capital: "Lisbon"),
        Pair(country: "Brazil", capital: "Brasilia"),
        Pair(country: "Argentina", capital: "Buenos Aires"),
        Pair(country: "Egipt", capital: "Cairo"),
        Pair(country: "Australia", capital: "Canberra"),
        Pair(country: "Kenya", capital: "Nairobi"),
        Pair(country: "New Zeland", capital: "Wellington")
    ]
    
    let tags = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29].shuffled()
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(scoreLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Match a country with its capital"
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(titleLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            titleLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 910),
            buttonsView.heightAnchor.constraint(equalToConstant: 530),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 180
        let height = 90
        
        for row in 0 ..< 6 {
            for column in 0 ..< 5 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.setTitle("Memo", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                button.frame = frame
                
                buttonsView.addSubview(button)
                buttons.append(button)
            }
        }
        
        for i in 0 ..< buttons.count {
            buttons[i].tag = tags[i]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @objc func buttonTapped(_ sender: UIButton) {
        let pairIndex = sender.tag / 2
        let selectedPair = pairs[pairIndex]
        sender.setTitle(sender.tag % 2 == 0 ? selectedPair.country : selectedPair.capital, for: .normal)
        
        selectedButtons.append(sender)
        
        if selectedButtons.count == 2 {
            let titles = selectedButtons.map { $0.title(for: .normal) ?? "" }
            let matchingPair = pairs.first { $0.country == titles[0] && $0.capital == titles[1] } ?? pairs.first { $0.capital == titles[0] && $0.country == titles[1] }
            
            buttons.forEach { $0.isEnabled = false }
            
            if matchingPair != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
                    self?.removeButtons()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.buttons.forEach { $0.isEnabled = true }
                    }
                }
                
                score += 1
                
                if score == 15 {
                    endGame()
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.faceDownButtons()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.buttons.forEach { $0.isEnabled = true }
                    }
                }
            }
        }
    }
    
    
    func faceDownButtons() {
        selectedButtons.forEach { $0.setTitle("Memo", for: .normal) }
        selectedButtons.removeAll()
    }
    
    
    func removeButtons() {
        selectedButtons.forEach { $0.removeFromSuperview() }
        selectedButtons.removeAll()
    }
    
    
    func endGame() {
        let ac = UIAlertController(title: "You win!", message: "Congrats! You matched all the countries with their capitals.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: playAgain))
        present(ac, animated: true)
    }
    
    
    func playAgain(action: UIAlertAction! = nil) {
        score = 0
        buttons.forEach { $0.isEnabled = true }
        buttons.forEach { $0.setTitle("Memo", for: .normal)}
        pairs.shuffle()
        selectedButtons.removeAll()
        buttons.removeAll()
        loadView()
    }
}

