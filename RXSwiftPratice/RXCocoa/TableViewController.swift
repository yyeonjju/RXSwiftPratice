//
//  TableViewController.swift
//  RXSwiftPratice
//
//  Created by 하연주 on 7/31/24.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct TableViewItem{
    let title : String
    let subTitle : String
}

final class TableViewController : UIViewController{
    let simpleLabel = UILabel()
    let tableView = UITableView()
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        setupTableView()
    }
    
    
    private func setupTableView() {
        //📍Observable
        let items = Observable.just([
            TableViewItem(title: "first", subTitle: "1"),
            TableViewItem(title: "second", subTitle: "2"),
            TableViewItem(title: "third", subTitle: "3"),
            TableViewItem(title: "fourth", subTitle: "4"),
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        //📍Observe - subscribe
        //✅ tableView의 element들 setup
        items
            .bind(to: tableView.rx.items){ tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = element.title
                return cell
            }
            .disposed(by: disposeBag)
        
        
        
        //📍RXCocoa
        pushPage()
//        bindSelectedItemRow()
//        bindSelectedModel()
        
    }
    
    private func pushPage() {
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                //✅
                let vc = PickerViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedItemRow() {
        //✅ picker뷰 선택했을 때의 이벤트
        //✅✅itemSelected - 프로퍼티
        //📍Observable
        tableView.rx.itemSelected //❤️ ControlEvent<IndexPath>리턴
            .map{String($0.row)}
        //📍Observable
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func bindSelectedModel () {
        //✅ picker뷰 선택했을 때의 이벤트
        //✅✅modelSelected - 메서드
        //📍Observable
        //func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T>
        tableView.rx.modelSelected(TableViewItem.self) //❤️ ControlEvent<T> 타입의 이벤트를 방출
            .map{
                print("modelSelected - $0.title", $0.title) //
                print("modelSelected - $0.subTitle", $0.subTitle) //
                return $0.title
            }
        //📍Observe - subscribe
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    private func configureUI() {
        view.addSubview(simpleLabel)
        view.addSubview(tableView)
        
        simpleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        
        view.backgroundColor = .white
        tableView.backgroundColor = .brown
        simpleLabel.backgroundColor = .lightGray
        simpleLabel.text = "---"
    }
}
