//
//  ViewController.swift
//  RXSwiftPratice
//
//  Created by 하연주 on 7/31/24.
//

import UIKit

enum RXPractice : String, CaseIterable{
    case pickerView
    case tableView
    case switchView
    case textField
    
    var vc : UIViewController {
        switch self {
        case .pickerView:
            return PickerViewController()
        case .tableView:
            return TableViewController()
        case .switchView:
            return SwitchViewController()
        case .textField:
            return TextFieldViewController()
        }
    }
}


class ViewController: UIViewController {
    lazy var listCollectionView = {
        //Layout
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return cv
    }()
    
    private let sectionList = RXPractice.allCases
    private var dataSource : UICollectionViewDiffableDataSource<Int, RXPractice>!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCollectionView.delegate = self
//        listCollectionView.dataSource = self
        configureView()
        configureDataSource()
        updateSnapshot()
    }
    
    
    
    
    
    
    
    private func configureView() {
        view.addSubview(listCollectionView)
        
        listCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        view.backgroundColor = .white
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .clear

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
        
    }
    
    func configureDataSource() {
        // Presentation

        let cellRegistration = makeCellRegistration()

        
        dataSource = UICollectionViewDiffableDataSource(collectionView: listCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })

    }
    private func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, RXPractice> {
        //각 셀에 들어갈 데이터가 itemIdentifier 파라미터로 들어온다
        let cellRegistration : UICollectionView.CellRegistration<UICollectionViewListCell, RXPractice> = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in

            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.rawValue
            content.textProperties.font = .systemFont(ofSize: 13)
            content.textProperties.color = .black
            
            var backgroundCongfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundCongfig.backgroundColor = .clear
            
            
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundCongfig
        }
        
        return cellRegistration
    }

    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RXPractice>()
        let items = RXPractice.allCases
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        
        // reloadData(X)
        //snapshot(📍14+) (O)
        dataSource.apply(snapshot)
    }

}



extension ViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = dataSource.itemIdentifier(for: indexPath) else{return }

        let vc = data.vc
        print("vc -> ", vc)
        navigationController?.pushViewController(vc, animated: true)
//        todo.remove(at: indexPath.item)
//        updateSnapshot()
    }
}
