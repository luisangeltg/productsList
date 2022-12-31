//
//  DisplayTable.swift
//  PruebaTecnicaBancoppel
//
//  Created by Luis Angel Torres G on 26/12/22.
//

import Foundation
import UIKit

class DisplayTable: UIViewController {
    private let containerView = UIView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        ItemViewModel.shared.fetch { [weak self] done in
            if done {
                self?.tableDisplay.reloadData()
            }
        }

        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupView()
        setupNavbar()
    }

    private lazy var tableDisplay: UITableView = {
        var table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CustomCell.self, forCellReuseIdentifier: "\(CustomCell.self)")
        table.rowHeight = 130.0
        table.translatesAutoresizingMaskIntoConstraints = false

        return table
    }()
    
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
        let image = UIImage(systemName: "books.vertical.circle")
//        guard let selectedID = ItemViewModel.shared.selected?.id else { return }
        
//        if selectedID != ItemViewModel.shared.products()[0].id {
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(sortItemsById))
        rightButton.title = "Order By ID"
        self.navigationItem.rightBarButtonItem = rightButton
//        }
    }
    
    
    @objc private func sortItemsById(_ sender : UIButton){
        ItemViewModel.shared.sortProductsByID()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Sorting by Id ...")
        tableDisplay.reloadData()
        self.refreshControl.endRefreshing()
        
        tableDisplay.reloadData()
//        navigationController?.popViewController(animated: true)
        
    }
}

extension DisplayTable: UITableViewDelegate, UITableViewDataSource, DisplayTableDelegate {
    func reloadTableView() {
        //delegado que recarga la tabla con el arreglo actualizado
        tableDisplay.reloadData()
    }
    
    func setupLayers() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableDisplay)
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

        //Table Constraints
        NSLayoutConstraint.activate([
            tableDisplay.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableDisplay.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableDisplay.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableDisplay.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        //tableDisplay.backgroundColor = .yellow
    }
    private func setupView() {
        //Organiza vista
        setupLayers()
        //Add refreshControl
        if #available(iOS 10.0, *) {
            tableDisplay.refreshControl = refreshControl
        } else {
            tableDisplay.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(sortItemsByTitle), for: .valueChanged)
    }

    @objc private func sortItemsByTitle(_ sender: UIButton) {
        ItemViewModel.shared.sortProductsByTitle()
        refreshControl.attributedTitle = NSAttributedString(string: "Sorting alphabetically by Title ...")
        tableDisplay.reloadData()
        self.refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return the size of the array
        return ItemViewModel.shared.products().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CustomCell.self)", for: indexPath) as? CustomCell else { return UITableViewCell() }
        let product = ItemViewModel.shared.products()[indexPath.row]
        cell.accessoryType = .detailButton
        cell.setData(product: product)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Inicializa el producto seleccionado, el delegado de la tabla para actualizarla y cambia de pantalla
        let product = ItemViewModel.shared.products()[indexPath.row]
        ItemViewModel.shared.selected = product

        let detailView = DetailView()
        detailView._producto = product
        detailView.delegate = self
        self.navigationController?.pushViewController(detailView, animated: true)
    }

}
