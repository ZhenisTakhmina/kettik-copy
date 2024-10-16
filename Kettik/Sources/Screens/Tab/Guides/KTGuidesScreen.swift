//
//  KTGuidesScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import SwiftUI
import RxCocoa
import RxSwift

final class KTGuidesScreen: KTViewController {
    
    private let viewModel: KTGuidesViewModel = .init()
    
    private var guides: [KTGuideAdapter] = []
    
    private let selectGuide: PublishRelay<KTGuideAdapter> = .init()
    
    private lazy var tableView: UITableView = .init().then {
        $0.contentInset.top = 12
        $0.register(Cell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
 
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Tab.guides
        view.add(tableView, {
            $0.edges.equalToSuperview()
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTGuidesViewModel.Input = .init(
            loadData: rx.viewWillAppear.take(1).mapToVoid(),
            selectGuide: selectGuide.asObservable()
        )
        let output: KTGuidesViewModel.Output = viewModel.transform(input: input)
        
        output.guides
            .drive(onNext: { [weak self] guides in
                guard let self = self else { return }
                self.guides = guides
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTGuidesScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(guide: guides[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectGuide.accept(guides[indexPath.row])
    }
}

fileprivate final class Cell: KTTableViewCell {
    
    private let photoView: UIImageView = .init().then {
        $0.backgroundColor = KTColors.Surface.secondary.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.bold.font(size: 20)
        $0.textColor = KTColors.Text.primary.color
    }
    
    private let roleLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 16)
        $0.textColor = KTColors.Text.secondary.color
    }
    
    override func setupViews() {
        super.setupViews()
        addShadow()
        layer.shadowOffset = .init(width: 0, height: 12)
        
        let containerView: KTView = .init(backgroundColor: KTColors.Surface.primary.color).then {
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            photoView,
            UIStackView(arrangedSubviews: [
                nameLabel,
                roleLabel
            ]).then {
                $0.axis = .vertical
                $0.spacing = 4
            }
        ]).then {
            $0.alignment = .center
            $0.spacing = 24
        }
        
        contentView.add(containerView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 18, vertical: 6))
        })
        containerView.add(stackView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 14, vertical: 12))
        })
        photoView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 80))
        }
    }
    
    func set(guide: KTGuideAdapter) {
        photoView.setImage(with: guide.photoURL)
        nameLabel.text = guide.name
        roleLabel.text = guide.role
    }
}

