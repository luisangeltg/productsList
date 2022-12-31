//
//  DetailView.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 27/12/22.
//

import Foundation
import UIKit

class DetailView: UIViewController {

    weak var delegate: DisplayTableDelegate?
    private let containerView = UIView()
    private var stackVerticalItem = UIStackView()
    public var _producto: Product?
    
    private var stackLabels1 = UIStackView()
    private var stackLabels2 = UIStackView()
    private var stackLabels3 = UIStackView()
    private var stackLabels4 = UIStackView()
    
    private var labels1 = [UILabel]()
    private var labels2 = [UILabel]()
    private var labels3 = [UILabel]()
    private var labels4 = [UILabel]()

    let urls: [URL] = ItemViewModel.shared.getUrls()
    lazy var carousel = Carousel(frame: .zero, urls: urls)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        containerView.backgroundColor = .white
        stackVerticalItem.backgroundColor = .white
        setupView()
        //setup carousel
        setupCarousel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }

    func setupNavbar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .orange

        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.title = "App Productos"
        
        initNavBarButtons()
    }

    private func initNavBarButtons () {
        let image = UIImage(systemName: "arrow.up")
        guard let selectedID = ItemViewModel.shared.selected?.id else { return }
        
        if selectedID != ItemViewModel.shared.products()[0].id {
            let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(setToTop))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    @objc private func setToTop(_ sender : UIButton){
        guard let _id = _producto?.id else { return }
        ItemViewModel.shared.putOnTop(newTopID: (_id-1))
        delegate?.reloadTableView()
        navigationController?.popViewController(animated: true)
    }
}

extension DetailView {
    private func setupView() {
        stackVerticalItem = createStackView(orientation: .vertical, views: [], distribution: .equalCentering)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackVerticalItem)
        view.addSubview(containerView)

        let marginView = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: marginView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: marginView.trailingAnchor),
        ])

        if #available(iOS 11, *) {
            //set the safeArea configuration for this view
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: guide.topAnchor),
                guide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: standardSpacing),
            ])
        }

        NSLayoutConstraint.activate([
            stackVerticalItem.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            stackVerticalItem.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            stackVerticalItem.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackVerticalItem.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])

        setupLabels(producto: _producto!)

    }
    
    func setupLabels(producto: Product) {
        //Fila 1
        labels1 = [
            LabelFactoryManager.createLabel(withFactory: BoldLabel(), titulo: "ID: \(producto.id)", size: 20),
            LabelFactoryManager.createLabel(withFactory: BoldLabel(), titulo: "Title: \(producto.title)", size: 20),
        ]
        stackLabels1 = createStackView(orientation: .horizontal, views: labels1, distribution: .fill)
        stackVerticalItem.addArrangedSubview(stackLabels1)
        //Fila 2
        labels2 = [
            LabelFactoryManager.createLabel(withFactory: LongLabel(), titulo: "Description: \(producto.productDescription)", size: 17),
        ]
        stackLabels2 = createStackView(orientation: .horizontal, views: labels2, distribution: .fill)
        stackVerticalItem.addArrangedSubview(stackLabels2)
        //Fila 3
        labels3 = [
            LabelFactoryManager.createLabel(withFactory: LongLabel(), titulo: "Price: \(ItemViewModel.priceToCurrency(price: producto.price))", size: 17),
            LabelFactoryManager.createLabel(withFactory: LongLabel(), titulo: "Discount %: \(producto.discountPercentage)", size: 17),
            LabelFactoryManager.createLabel(withFactory: LongLabel(), titulo: "Rating: \(producto.rating)", size: 17),
            LabelFactoryManager.createLabel(withFactory: LongLabel(), titulo: "Stock: \(producto.stock)", size: 17),
        ]
        stackLabels3 = createStackView(orientation: .horizontal, views: labels3, distribution: .fill)
        stackVerticalItem.addArrangedSubview(stackLabels3)
        //Fila 4
        labels4 = [
            LabelFactoryManager.createLabel(withFactory: RegularLabel(), titulo: "Brand: \(producto.brand)", size: 20),
            LabelFactoryManager.createLabel(withFactory: RegularLabel(), titulo: "Category: \(producto.category)", size: 20),
        ]
        stackLabels4 = createStackView(orientation: .horizontal, views: labels4, distribution: .fill)
        stackVerticalItem.addArrangedSubview(stackLabels4)
    }

    func createLabel(titulo: String, size: CGFloat, _weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = titulo
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: size, weight: _weight)

        return label
    }

    //Vertical es parado, horizontal es acostado
    func createStackView(orientation: NSLayoutConstraint.Axis = .vertical, views: [UIView], distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5

        return stackView
    }

}

extension DetailView {


    func setupCarousel() {
        stackVerticalItem.addArrangedSubview(carousel)

        carousel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            carousel.topAnchor.constraint(equalTo: stackVerticalItem.topAnchor),
//            carousel.bottomAnchor.constraint(equalTo: stackVerticalItem.bottomAnchor),
//            carousel.leadingAnchor.constraint(equalTo: stackVerticalItem.leadingAnchor),
//            carousel.trailingAnchor.constraint(equalTo: stackVerticalItem.trailingAnchor),
            carousel.widthAnchor.constraint(equalToConstant: 80),
            carousel.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
