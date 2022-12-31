//
//  LabelFactory.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 27/12/22.
//

import Foundation
import UIKit

protocol LabelFactory {
    func createLabel(titulo: String, size : CGFloat) -> UILabel
}

class RegularLabel : LabelFactory {
    func createLabel(titulo: String, size : CGFloat) -> UILabel {
        let label = UILabel()
        label.text = titulo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        return label
    }
}

class BoldLabel : LabelFactory {
    func createLabel(titulo: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = titulo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: size, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        return label
    }
}

class LongLabel : LabelFactory {
    func createLabel(titulo: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = titulo
        label.font = UIFont.systemFont(ofSize: size, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}

class LabelFactoryManager {
    static func createLabel(withFactory factory: LabelFactory, titulo: String, size: CGFloat) -> UILabel{
        return factory.createLabel(titulo: titulo, size: size)
    }
}
