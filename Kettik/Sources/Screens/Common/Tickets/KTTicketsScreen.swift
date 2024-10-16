//
//  KTTicketsScreen.swift
//  Kettik
//
//  Created by Tami on 23.02.2024.
//

import UIKit
import RxCocoa
import RxSwift

final class KTTicketsScreen: KTViewController {
    
    private let viewModel: KTTicketsViewModel = .init()
    
    private var tickets: [KTTicketAdapter] = []
    
    private let selectTicket: PublishRelay<KTTicketAdapter> = .init()
    
    private lazy var tableView: UITableView = .init().then {
        $0.register(Cell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.tableFooterView = .init()
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    override func setupViews() {
        super.setupViews()
        navigationItem.title = KTStrings.Profile.myTickets
        
        view.add(tableView, {
            $0.edges.equalToSuperview()
        })
    }
    
    override func bind() {
        super.bind()
        bindDefaultTriggers(forViewModel: viewModel)
        
        let input: KTTicketsViewModel.Input = .init(
            loadData: rx.viewWillAppear.mapToVoid(),
            selectTicket: selectTicket.asObservable()
        )
        let output: KTTicketsViewModel.Output = viewModel.transform(input: input)
        
        output.tickets
            .drive(onNext: { [weak self] tickets in
                guard let self = self else { return }
                self.tickets = tickets
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension KTTicketsScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(ticket: tickets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectTicket.accept(tickets[indexPath.row])
    }
}

fileprivate final class Cell: KTTableViewCell {
    
    private let countLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 14)
        $0.textColor = KTColors.Text.primary.color
    }
    
    private let nameLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.regular.font(size: 14)
        $0.textColor = KTColors.Text.primary.color
    }
    
    private let priceLabel: UILabel = .init().then {
        $0.font = KTFonts.SFProText.heavy.font(size: 16)
        $0.textColor = KTColors.Text.primary.color
    }
    
    override func setupViews() {
        super.setupViews()
        let ticketView: UIImageView = .init(image: KTImages.Element.ticket.image).then {
            $0.contentMode = .scaleToFill
        }
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            countLabel,
            nameLabel,
            priceLabel
        ]).then {
            $0.axis = .vertical
            $0.spacing = 4
            $0.setCustomSpacing(12, after: nameLabel)
        }
        
        contentView.add(ticketView, {
            $0.edges.equalTo(UIEdgeInsets(horizontal: 24, vertical: 8))
            $0.height.equalTo(132)
        })
        ticketView.add(stackView, {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(107)
        })
    }
    
    func set(ticket: KTTicketAdapter) {
        countLabel.text = String(ticket.count) + KTStrings.Ticket.ticket
        nameLabel.text = ticket.name
        priceLabel.text = ticket.formattedTotalPrice
    }
}

