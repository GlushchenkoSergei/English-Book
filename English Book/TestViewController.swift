//
//  TestViewController.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

class TestViewController: UIViewController {
    
    private let viewCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.5
        view.layer.borderWidth = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        return imageView
    }()
    
    private let labelWord: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTest: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
English book предлагает пройти тест,
состоящий из выученных слов.
Если знаешь слово - свайп влево,
забыл - свайп вправо.
Нажатием на карточку можешь посмотреть перевод!
"""
        return label
    }()
    
    private let myProgress: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Вы выучили 0 cл."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var iKnowWords: [WordIKnow] = []
    
    private var learnTheseWords: [LearnWord] = []
    
    private var wordRu = ""
    private var wordEn = "" {
        didSet {
            wordRu = TranslateManager.translate(word: wordEn) ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(viewCard)
        view.addSubview(descriptionTest)
        view.addSubview(myProgress)
        view.addSubview(resultImageView)
        viewCard.addSubview(labelWord)
        
        let gestureForViewCard = UITapGestureRecognizer(target: self, action: #selector(flipViewCard(sender: )))
        viewCard.addGestureRecognizer(gestureForViewCard)
        
        let gestureForSwipe = UIPanGestureRecognizer(target: self, action: #selector(gestureForSwipeAction))
        viewCard.addGestureRecognizer(gestureForSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iKnowWords = StorageManager.shared.fetchWordsIKnow() ?? []
        learnTheseWords = StorageManager.shared.fetchLearnWords() ?? []
        labelWord.text = iKnowWords.randomElement()?.word
        wordEn = labelWord.text ?? ""
        myProgress.text = "Вы выучили \(iKnowWords.count) сл."
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstrains()
    }
    
    @objc private func flipViewCard(sender: UILongPressGestureRecognizer) {
        let radians = CGFloat(200 * Double.pi / 180)
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(changeTextLabelWord), userInfo: nil, repeats: false)
        
        let rotation = CATransform3DMakeRotation(radians, 0, radians, 0)
        UIView.animate(withDuration: 0.4) {
            self.viewCard.layer.transform = rotation
        } completion: { _ in
            self.labelWord.transform = .identity
            self.viewCard.transform = .identity
        }

    }
    
       @objc private func changeTextLabelWord() {
           labelWord.text = labelWord.text == wordEn ? wordRu : wordEn
           let radians = CGFloat(200 * Double.pi / 180)
           let rotation = CATransform3DMakeRotation(radians, 0, radians, 0)
           labelWord.layer.transform = rotation
       }
    
    @objc private func gestureForSwipeAction(sender: UIPanGestureRecognizer) {
        guard let fileView = sender.view else { return }
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            fileView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y)
            sender.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if fileView.center.x < 145 {
                swipeViewCardLeading()
            } else if fileView.center.x > 245 {
                swipeViewCardTrailing()
            } else {
                viewCard.center.x = view.center.x
            }
        default:
            break
        }
    }
    
    // MARK: - Swipe view card trailing
    private func swipeViewCardTrailing() {
        animateResultView(imageName: "multiply", color: .red)
        
        let _ = StorageManager.shared.appendLearnWord(title: self.wordEn)
        
        for iKnowWord in iKnowWords {
            if iKnowWord.word == wordEn {
                StorageManager.shared.delete(iKnowWord)
                let indexFind = iKnowWords.firstIndex(of: iKnowWord)
                iKnowWords.remove(at: indexFind ?? 0)
                break
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.viewCard.frame.origin = CGPoint(x: 570, y: self.viewCard.frame.origin.y)
        } completion: { _ in
            self.labelWord.text = self.iKnowWords.randomElement()?.word
            self.wordEn = self.labelWord.text ?? ""
            self.myProgress.text = "Вы выучили \(self.iKnowWords.count) сл."
            self.setPositionViewWithAnimate()
        }
    }
    
    // MARK: - Swipe view card leading
    @objc private func swipeViewCardLeading() {
        animateResultView(imageName: "chevron.down.circle", color: .green)
        
        UIView.animate(withDuration: 0.2,
                      animations: {
            self.viewCard.frame.origin = CGPoint(x: -370, y: self.viewCard.frame.origin.y)
        },
                      completion: { _ in
            self.labelWord.text = self.iKnowWords.randomElement()?.word
            self.wordEn = self.labelWord.text ?? ""
            
            self.setPositionViewWithAnimate()
        })
    }
    
    private func setPositionViewWithAnimate() {
        viewCard.isHidden = true
        viewCard.center.x = view.center.x
        viewCard.frame.origin = CGPoint(x: 370, y: viewCard.frame.origin.y)
        viewCard.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.viewCard.frame.origin = CGPoint(x: self.view.center.x - self.viewCard.frame.width / 2,
                                                 y: self.viewCard.frame.origin.y)
        }
    }
    


    
    private func animateResultView(imageName: String, color: UIColor) {
        resultImageView.image = UIImage(systemName: imageName)
        resultImageView.tintColor = color
        resultImageView.isHidden = false
        
        self.resultImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.1) {
            self.resultImageView.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.resultImageView.alpha = 0
            } completion: { _ in
                self.resultImageView.isHidden = true
                self.resultImageView.alpha = 1
            }
        }
    }
    
}

// MARK: - Set Constrains
extension TestViewController {
    private func setConstrains() {
        NSLayoutConstraint.activate([
            viewCard.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3 ),
            viewCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewCard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            viewCard.heightAnchor.constraint(equalToConstant: view.bounds.height / 4)
        ])
        
        NSLayoutConstraint.activate([
            labelWord.centerXAnchor.constraint(equalTo: viewCard.centerXAnchor),
            labelWord.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            labelWord.widthAnchor.constraint(equalTo: viewCard.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTest.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                constant: -(tabBarController?.tabBar.frame.height ?? 0) - 20),
            descriptionTest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTest.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
        ])
        
        NSLayoutConstraint.activate([
            myProgress.bottomAnchor.constraint(equalTo: descriptionTest.topAnchor, constant: -10) ,
            myProgress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            resultImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 200),
            resultImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}


