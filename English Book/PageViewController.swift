//
//  PageViewController.swift
//  English Book
//
//  Created by mac on 11.07.2022.
//

import UIKit

class PageViewController: UIViewController {

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let testText = """
Writing about oneself and personal experiences — and then rewriting your story — can lead to behavioral changes and improve happiness. (We already know that expressive writing can improve mood disorders and help reduce symptoms among cancer patients, among other health benefits.)
Some research suggests that writing in a personal journal for 15 minutes a day can lead to a boost in overall happiness and well-being, in part because it allows us to express our emotions, be mindful of our circumstances and resolve inner conflicts. Or you can take the next step and focus on one particular challenge you face, and write and rewrite that story.
We all have a personal narrative that shapes our view of the world and ourselves. But sometimes our inner voice doesn’t get it right. By writing and then editing our own stories, we can change our perceptions of ourselves and identify obstacles that stand in the way of our personal well-being. The process is similar to Socratic questioning (referenced above). Here’s a writing exercise:
"""
    
    var value = 0
    var counterOneLine = 0
    
    private var componentsOfText: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        componentsOfText = divisionIntoParts(this: testText)
        addingSpacerForLine(array: componentsOfText)
    }
    
    private func addingSpacerForLine(array: [String]) {
    
        for index in 0...componentsOfText.count - 1{
            
            value += componentsOfText[index].count
            
            if value > 36 {
                let x = 36 - counterOneLine
                for _ in 0...x {
                    componentsOfText[index - 1] += " "
                    print("добавил пробелы index \(index - 1)")
                }
                counterOneLine = 0
                value = componentsOfText[index].count
            }
            counterOneLine += componentsOfText[index].count
        }
    }
    
    private func divisionIntoParts(this text: String) -> [String] {
        var components: [String] = []
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { substring, substringRange, enclosingRange, stop in
            components.append(String(text[enclosingRange]))
        }
        return components
    }
    
}

extension PageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        componentsOfText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as? WordCollectionViewCell else { fatalError() }
        cell.configure(with: componentsOfText[indexPath.row])
        cell.backgroundColor = .systemGray3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("индекс - [\(indexPath.row)]")
        print("символов \(componentsOfText[indexPath.row].count)")
    }
    
}

extension PageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //расстояние между горизонтальными секциями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    //расстояние между вертикальными разделителями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if componentsOfText[indexPath.row].count < 3 {
            return CGSize(width: (view.frame.size.width / 28) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 4 {
            return CGSize(width: (view.frame.size.width / 14) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 5 {
            return CGSize(width: (view.frame.size.width / 9.5) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 6 {
            return CGSize(width: (view.frame.size.width / 7.6) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 7 {
            return CGSize(width: (view.frame.size.width / 6.5) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 8 {
            return CGSize(width: (view.frame.size.width / 5) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 9 {
            return CGSize(width: (view.frame.size.width / 4.8) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 10 {
            return CGSize(width: (view.frame.size.width / 4.6) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 11 {
            return CGSize(width: (view.frame.size.width / 4) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 12 {
            return CGSize(width: (view.frame.size.width / 3.6) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 13 {
            return CGSize(width: (view.frame.size.width / 3) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 14 {
            return CGSize(width: (view.frame.size.width / 2.8) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 15 {
            return CGSize(width: (view.frame.size.width / 2.7) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 16 {
            return CGSize(width: (view.frame.size.width / 2.9) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 18 {
            return CGSize(width: (view.frame.size.width / 2.4) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 19 {
            return CGSize(width: (view.frame.size.width / 2.3) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 20 {
            return CGSize(width: (view.frame.size.width / 2.1) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 21 {
            return CGSize(width: (view.frame.size.width / 2.0) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 22 {
            return CGSize(width: (view.frame.size.width / 2.0) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 23 {
            return CGSize(width: (view.frame.size.width / 2.0) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 32 {
            return CGSize(width: (view.frame.size.width / 2) , height: 30)
        }
        
        return CGSize(width: (view.frame.size.width / 1.5) , height: 30)
    }
}

