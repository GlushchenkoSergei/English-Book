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
Инкапсуляция (англ. encapsulation, от лат. in capsula) — в информатике, процесс разделения элементов абстракций, определяющих ее структуру (данные) и поведение (методы); инкапсуляция предназначена для изоляции контрактных обязательств абстракции (протокол/интерфейс) от их реализации. На практике это означает, что класс должен состоять из двух частей: интерфейса и реализации. В реализации большинства языков программирования (C++, C#, Java и другие) обеспечивается механизм сокрытия, позволяющий разграничивать доступ к различным частям компонента.

Инкапсуляция зачастую рассматривается как понятие, присущее исключительно объектно-ориентированному программированию (ООП), но в действительности обширно встречается и в других (см. подтипизация на записях и полиморфизм записей и вариантов). В ООП инкапсуляция тесно связана с принципом абстракции данных (не путать с абстрактными типами данных, реализации которых предоставляют возможность инкапсуляции, но имеют иную природу). Это, в частности, влечёт за собой различия в терминологии в разных источниках. В сообществе C++ или Java принято рассматривать инкапсуляцию без сокрытия как неполноценную. Однако, некоторые языки (например, Smalltalk, Python) реализуют инкапсуляцию, но не предусматривают возможности сокрытия в принципе. Другие (Standard ML, OCaml) жёстко разделяют эти понятия как ортогональные и предоставляют их в семантически различном виде (см. сокрытие в языке модулей ML).
"""
    
    let oneLine: [String] = ["процесс ", "разделения ", "элементов ", "абстракций, "]
    
    
   lazy var componentsOfText = divisionIntoParts(this: testText)
    
    let testWord = "как"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(WordCollectionViewCell.self, forCellWithReuseIdentifier: WordCollectionViewCell.identifier)
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let componentsOfText = divisionIntoParts(this: testText)
//        print(componentsOfText)
//        print("________")
        
        print(countCharactersOf(this: oneLine))
        let mergeText = mergePartsText(components: componentsOfText)
//        print(mergeText)
    }
    
    private func countCharactersOf(this array: [String]) -> Int {
        var count = 0
        
        for x in array {
            count += x.count
        }
        return count
    }
    
    
    private func mergePartsText(components: [String]) -> String {
        var text = ""
        for part in components {
            text += part
        }
        return text
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
        print(componentsOfText[indexPath.row])
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
    
    private func currentCounterCharacter(indexPath: IndexPath) {
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberCharacterOfLine = 41
        var counter = 0
        
        if
            
        counter += indexPath.row
        
        
        
        
        
        
        if componentsOfText[indexPath.row].count < 3 {
            return CGSize(width: (view.frame.size.width / 30) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 4 {
            return CGSize(width: (view.frame.size.width / 13) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 5 {
            return CGSize(width: (view.frame.size.width / 10) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 7 {
            return CGSize(width: (view.frame.size.width / 7) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 8 {
            return CGSize(width: (view.frame.size.width / 6) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 9 {
            return CGSize(width: (view.frame.size.width / 5) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 10 {
            return CGSize(width: (view.frame.size.width / 4.4) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 11 {
            return CGSize(width: (view.frame.size.width / 4.25) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 12 {
            return CGSize(width: (view.frame.size.width / 3.9) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 13 {
            return CGSize(width: (view.frame.size.width / 3.4) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 15 {
            return CGSize(width: (view.frame.size.width / 3.1) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 16 {
            return CGSize(width: (view.frame.size.width / 2.9) , height: 30)
            
        } else if componentsOfText[indexPath.row].count < 18 {
            return CGSize(width: (view.frame.size.width / 2.4) , height: 30)
        
        } else if componentsOfText[indexPath.row].count < 19 {
            return CGSize(width: (view.frame.size.width / 2.2) , height: 30)
        }
        
        return CGSize(width: (view.frame.size.width / 1) , height: 30)
    }
}

