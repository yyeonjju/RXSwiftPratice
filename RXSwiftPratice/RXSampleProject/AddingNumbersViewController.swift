//
//  AddingNumbersViewController.swift
//  RXSwiftPratice
//
//  Created by 하연주 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddingNumbersViewController : UIViewController {
    private let number1TextField = UITextField()
    private let number2TextField = UITextField()
    private let number3TextField = UITextField()
    
    private let resultLabel = UILabel()
    
    private lazy var stackView = {
        let sv = UIStackView(arrangedSubviews: [number1TextField, number2TextField, number3TextField])
        
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 5
        sv.alignment = .center
        
        return sv
    }()
    
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        rxAddNumbers()
        
    }
    
    private func rxAddNumbers() {
        let observable = Observable.combineLatest(
            number1TextField.rx.text.orEmpty, //Observable Type  - ControlProperty<String?>
            number2TextField.rx.text.orEmpty,
            number3TextField.rx.text.orEmpty
        ){ textValue1, textValue2, textValue3 in
            let sumResult = [Int(textValue1) ?? 0, Int(textValue2) ?? 0, Int(textValue3) ?? 0].reduce(0) { result, value in
                result + value
            }
            return sumResult
        }
            .map{String($0)}
//            .map{$0.description}
        
        let observe = observable
            .bind(to: resultLabel.rx.text)
        
        observe
            .disposed(by: disposeBag)
        
        
    }
    
    private func configureUI() {
        view.addSubview(stackView)
        view.addSubview(resultLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            
            make.height.equalTo(100)
        }
        number1TextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        number2TextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        number3TextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        view.backgroundColor = .white
        number1TextField.backgroundColor = .systemCyan
        number2TextField.backgroundColor = .systemPink
        number3TextField.backgroundColor = .systemYellow
        resultLabel.backgroundColor = .gray
    }
    
    
    
}
