//
//  PickerViewController.swift
//  RXSwiftPratice
//
//  Created by 하연주 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PickerViewController : UIViewController{
    let pickerView = UIPickerView()
    let simpleLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        setupPickerView()
    }
    
    
    private func setupPickerView() {
        //📍Observable
        let items = Observable.just([
            "영화", "애니메이션", "드라마", "기타"
        ])
        
        
        //📍Observe - subscribe
        //✅ picker뷰의 element들 setup
        items.bind(to: pickerView.rx.itemTitles){ index, element in
//            print("index \(index), element \(element)")
            return element
        }
        .disposed(by: disposeBag)
        
        
        
        //✅ picker뷰 선택했을 때의 이벤트
//        bindSelectedItemRow()
        bindSelectedModel()
        
    }
    
    private func bindSelectedItemRow() {
        //✅ picker뷰 선택했을 때의 이벤트
        //✅✅itemSelected - 프로퍼티
        // Reactive wrapper for `delegate` message `pickerView:didSelectRow:inComponent:`.
        pickerView.rx.itemSelected  //❤️ControlEvent<(row: Int, component: Int)> 타입의 이벤트 방출하기 때문에
            .map{String($0.row)} //❤️ map을 통해 선택한 row에 대한 값을 String으로 만들어주고
            .bind(to: simpleLabel.rx.text) //❤️ simpleLabel.rx.text에 값을 바인딩
            .disposed(by: disposeBag)
        
    }
    
    private func bindSelectedModel () {
        //✅ picker뷰 선택했을 때의 이벤트
        //✅✅modelSelected - 메서드
        //Reactive wrapper for `delegate` message `pickerView:didSelectRow:inComponent:`.
        //modelType 파라미터: Type of a Model which bound to the dataSource
        //📍Observable
        pickerView.rx.modelSelected(String.self) //❤️ ControlEvent<[String]> 타입의 이벤트를 방출
            .map{
                print("modelSelected - $0", $0) // ["드라마"]
                print("modelSelected - $0.description", $0.description) // ["드라마"]
                return $0.first
            }
        //📍Observe - subscribe
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    private func configureUI() {
        view.addSubview(pickerView)
        view.addSubview(simpleLabel)
        
        pickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        view.backgroundColor = .white
        pickerView.backgroundColor = .brown
        simpleLabel.backgroundColor = .lightGray
        simpleLabel.text = "---"
    }
}
