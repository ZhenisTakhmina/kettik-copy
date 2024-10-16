//
//  KTExtensions.swift
//  Kettik
//
//  Created by Tami on 10.03.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Kingfisher

extension Int {
    
    var kztFormatted: String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₸"
        formatter.maximumFractionDigits = 0

        return formatter.string(from: self as NSNumber) ?? "\(self) ₸"
    }
}

extension Reactive where Base: UIView {
    
    var observableTap: Observable<Void> {
        return tapGesture().when(.recognized).mapToVoid()
    }
}

extension UIImageView{
    
    func setImage(with url: URL?) {
        guard let url = url else { return }
        
        kf.setImage(with: url, placeholder: nil, options: [.backgroundDecode]) { [weak self] result in
            switch result {
            case .success:
                self?.contentMode = .scaleAspectFill
            case .failure:
                self?.image = nil
            }
        }
    }
}


extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return .empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
    }
}

extension UIEdgeInsets {
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as! T
    }
}

extension UIView {
    
    func add(_ subview: UIView, _ closure: ((_ make: ConstraintMaker) -> Void)) {
        self.addSubview(subview)
        subview.snp.makeConstraints(closure)
    }
}

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

protocol KTReusableViewProtocol: AnyObject {
    
    static var defaultReuseIdentifier: String { get }
}

extension KTReusableViewProtocol where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionReusableView: KTReusableViewProtocol { }
extension UITableViewCell: KTReusableViewProtocol { }
extension UITableViewHeaderFooterView: KTReusableViewProtocol { }

