//
//  CustomCell.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 26/12/22.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupItems()
        //self.backgroundColor = .purple
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }
    private let tituloLabel = LabelFactoryManager.createLabel(withFactory: BoldLabel(), titulo: "Título: ", size: 18)
    private let idLabel = LabelFactoryManager.createLabel(withFactory: BoldLabel(), titulo: "ID: ", size: 20)
    private let marcaLabel = LabelFactoryManager.createLabel(withFactory: RegularLabel(), titulo: "Marca: ", size: 15)
    private let precioLabel = LabelFactoryManager.createLabel(withFactory: RegularLabel(), titulo: "Precio: ", size: 15)

    private let productoImageV: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()


}

extension CustomCell {

    private func setupItems() {
        let stackLabels = UIStackView(arrangedSubviews: [idLabel, tituloLabel, marcaLabel, precioLabel])
        stackLabels.axis = .vertical
        stackLabels.distribution = .equalSpacing
        stackLabels.translatesAutoresizingMaskIntoConstraints = false

//        let containerStackView = UIStackView(arrangedSubviews: [productoImageV, stackLabels])
//        containerStackView.axis = .horizontal
//        containerStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(containerStackView)

        addSubview(productoImageV)
        addSubview(stackLabels)

        NSLayoutConstraint.activate([
            //Image constraints
            productoImageV.widthAnchor.constraint(equalToConstant: 70),
            productoImageV.heightAnchor.constraint(equalToConstant: 70),
            productoImageV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            productoImageV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            productoImageV.topAnchor.constraint(equalTo: topAnchor),
            productoImageV.bottomAnchor.constraint(equalTo: bottomAnchor),

            //StackView constraints
            stackLabels.leadingAnchor.constraint(equalTo: productoImageV.trailingAnchor, constant: 10),
            stackLabels.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            stackLabels.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackLabels.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

        ])
    }

    //titulo, marca, precio e imagen
    func setData(product: Product) {

        let imageURL = URL(string: product.thumbnail)!
        // Load image data asyncronouslly
        URLSession.shared.dataTask(with: imageURL) { [weak self] _data, _, _ in
            guard let _data = _data else { return }
            DispatchQueue.main.async {
                self?.productoImageV.image = UIImage(data: _data)
            }
        }.resume()

        idLabel.text = "ID: \(product.id)"
        self.tituloLabel.text = "Title: \(product.title)"
        self.marcaLabel.text = "Brand: \(product.brand)"
        self.precioLabel.text = "Price: \(ItemViewModel.priceToCurrency(price: product.price))"
    }
}
