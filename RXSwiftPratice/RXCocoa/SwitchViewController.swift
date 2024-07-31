//
//  SwitchViewController.swift
//  RXSwiftPratice
//
//  Created by 하연주 on 7/31/24.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SwitchViewController : UIViewController{
    let switchView = UISwitch()
    let switchStatusLabel = UILabel()
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindIsOnToLabel()
    }
    
    private func bindIsOnToLabel(){
        switchView.rx.isOn
            .bind(with: self) { owner, isOn in
                owner.switchStatusLabel.text = String(isOn)
            }
            .disposed(by: disposeBag)
            
    }
    
    
    private func configureUI () {
        view.addSubview(switchView)
        view.addSubview(switchStatusLabel)
        
        switchView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        switchStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(switchView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        view.backgroundColor = .white
        switchStatusLabel.backgroundColor = .brown
    }
}
