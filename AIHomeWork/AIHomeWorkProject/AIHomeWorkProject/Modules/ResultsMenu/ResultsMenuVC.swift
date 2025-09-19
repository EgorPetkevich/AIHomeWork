//
//  ResultsMenuVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit
import SnapKit

protocol ResultsMenuAdapterProtocol {
    var actions: [ResultsMenuVC.Action] { get set }
    var tableView: UITableView { get }
    var contentHeight: CGFloat { get }
    var didSelectAction: ((ResultsMenuVC.Action) -> Void)? { get set }
}

protocol ResultsMenuDelegate: AnyObject {
    func didSelect(action: ResultsMenuVC.Action)
}

final class ResultsMenuVC: UIViewController {
    
    private enum Const {
        static let contentWidth: CGFloat = 228.0
    }
    
    enum Action: ResultsMenuItem {
        
        case edit
        case askExpert
        case delete
        case rename
        
        var title: String {
            switch self {
            case .edit: return "Edit"
            case .rename: return "Rename"
            case .askExpert: return "Ask an Expert"
            case .delete: return "Delete"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .edit: return .AppIcon.editImage
            case .rename: return .AppIcon.renameImage
            case .askExpert: return .AppIcon.editSparkImage
            case .delete: return .AppIcon.binImage
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .delete: return .appRed
            default: return .appBlack
            }
        }
        
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .popover }
        set {}
    }
    
    private var adapter: ResultsMenuAdapterProtocol
    
    private lazy var tableView: UITableView = adapter.tableView
    
    private weak var delegate: ResultsMenuDelegate?
    
    init(adapter: ResultsMenuAdapterProtocol,
         delegate: ResultsMenuDelegate,
         sourceView: UIView) {
        self.adapter = adapter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        setupPopover(sourceView: sourceView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupUI()
        setupConstrains()
    }
    
    private func bind() {
        adapter.didSelectAction = { [weak self] action in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.delegate?.didSelect(action: action)
            })
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .appWhite
        view.addSubview(tableView)
    }
    
    private func setupConstrains() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(
                self.view.safeAreaLayoutGuide.snp.verticalEdges)

        }
    }
    
    private func setupPopover(sourceView: UIView) {
        preferredContentSize = CGSize(width: Const.contentWidth,
                                      height: adapter.contentHeight)
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceRect = 
        CGRect(x: .zero,
               y: sourceView.bounds.maxY + CGFloat(30 * adapter.actions.count),
        width: .zero,
        height: .zero)
    }
    
}

extension ResultsMenuVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return .none
    }
    
}
