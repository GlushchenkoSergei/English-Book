//
//  TestViewController.swift
//  English Book
//
//  Created by mac on 23.07.2022.
//

import UIKit

final class TestViewController: UIViewController {
    
    private let viewCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.layer.shadowRadius = 15
        view.layer.shadowOpacity = 0.5
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    private let resultImageLeading: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "chevron.down.circle")
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 8)
        return imageView
    }()
    
    private let resultImageTrailing: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "multiply")
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
//        label.textColor = .black
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
                self.wordRu = TranslateManager.translate(word: self.wordEn) ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(viewCard, descriptionTest, myProgress, resultImageLeading, resultImageTrailing)
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
        guard wordEn != "" else { return }
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
        animateResultView(imageView: resultImageTrailing, color: .red)
        animateSwipe(start: 570,
                    completionAfterHide: {
            self.deleteWordFromIKnow()
        },
                    completion: {
            self.myProgress.text = "Вы выучили \( self.iKnowWords.count) сл."
            _ = StorageManager.shared.appendLearnWord(title: self.wordEn)
            self.wordEn = self.labelWord.text ?? ""
        })
        
    }
   
    private func deleteWordFromIKnow() {
        
        for iKnowWord in iKnowWords where iKnowWord.word == wordEn {
            StorageManager.shared.delete(iKnowWord)
            let indexFind = iKnowWords.firstIndex(of: iKnowWord)
            iKnowWords.remove(at: indexFind ?? 0)
            break
        }
        
    }

    // MARK: - Swipe view card leading
    @objc private func swipeViewCardLeading() {
        animateResultView(imageView: resultImageLeading, color: .green)
        animateSwipe(start: -370, completionAfterHide: {}, completion: { [self] in
            wordEn =  labelWord.text ?? ""
        })
    }
    
    private func animateSwipe(start position: CGFloat, completionAfterHide: @escaping () -> Void, completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
            self.viewCard.frame.origin = CGPoint(x: position, y: self.viewCard.frame.origin.y)
        },
                       completion: { _ in
            completionAfterHide()
            self.labelWord.text = self.iKnowWords.randomElement()?.word
            self.viewCard.frame.origin = CGPoint(x: 370, y: self.viewCard.frame.origin.y)
            
            UIImageView.animate(withDuration: 0.2) {
            self.viewCard.frame.origin = CGPoint(x: self.view.center.x - self.viewCard.frame.width / 2,
                                                  y: self.viewCard.frame.origin.y)
                completion()
            }
        })
        
    }
    
    private func animateResultView(imageView: UIImageView, color: UIColor) {
        imageView.tintColor = color
        imageView.isHidden = false
        imageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

        UIView.animate(withDuration: 0.2) {
            imageView.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                imageView.alpha = 0
            } completion: { _ in
                imageView.isHidden = true
                imageView.alpha = 1
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
            myProgress.bottomAnchor.constraint(equalTo: descriptionTest.topAnchor, constant: -10),
            myProgress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            resultImageLeading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImageLeading.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            resultImageLeading.widthAnchor.constraint(equalToConstant: 200),
            resultImageLeading.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            resultImageTrailing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImageTrailing.centerYAnchor.constraint(equalTo: viewCard.centerYAnchor),
            resultImageTrailing.widthAnchor.constraint(equalToConstant: 200),
            resultImageTrailing.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
}
