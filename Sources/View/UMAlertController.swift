//
//  UMAlertController.swift
//  UMUtils_Swift
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import UIKit
import SnapKit

public enum UMActionStyle {
    case `default`, cancel
}

public extension UMActionStyle {
    public init(_ alertStyle: UIAlertAction.Style) {
        self = {
            switch alertStyle {
            case .cancel:
                return .cancel
            case .default:
                return .default
            case .destructive:
                return .default
            @unknown default:
                return .default
            }
        }()
    }
}

fileprivate class UMAlertButton: UIButton {
    private var action: UMAlertAction? = nil

    func addAction(_ action: UMAlertAction) {
        self.action = action
        self.addTarget(self, action: #selector(self.performAction), for: .touchUpInside)
    }

    @objc func performAction() {
        guard let action = self.action else {
            return
        }

        action.handler?(action)
    }
}

open class UMAlertAction {
    
    fileprivate let title: String?
    fileprivate let handler: ((UMAlertAction) -> Void)?
    public let style: UMActionStyle

    required public init(title: String?, handler: ((UMAlertAction) -> Void)? = nil, style: UMActionStyle? = nil) {
        self.title = title
        self.handler = handler
        self.style = style ?? .default
    }

    open func asButton() -> UIButton {
        let button = UMAlertButton(frame: CGRect.zero)

        button.setTitle(self.title, for: .normal)

        switch self.style {
        case .cancel:
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.layer.borderColor = UIColor.black.cgColor
        case .default:
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.layer.borderColor = UIColor.black.cgColor
        }

        button.setTitleColor(button.titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
        button.layer.borderWidth = 1
        button.addAction(self)
        
        return button
    }
}

open class UMAlertController: UIViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }

//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    // MARK: Background Blur
    open var blurEffectStyle: UIBlurEffect.Style = .light {
        didSet {
            if oldValue != self.blurEffectStyle {
                blurView?.removeFromSuperview()
                blurView = self.createBlurView()
            }
        }
    }
    open var useBlur: Bool = false {
        willSet {
            if newValue {
                blurView = blurView ?? self.createBlurView()
            } else {
                blurView?.removeFromSuperview()
                blurView = nil
            }
        }
    }

    private var blurView: UIVisualEffectView? = nil
    private func createBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        blurEffectView.contentView.addSubview(vibrancyEffectView)

        vibrancyEffectView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(0)
        }

        return blurEffectView
    }


    // MARK: Alert Views
    public fileprivate(set) var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var alertContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = self.spacing
        return stack
    }()

    // MARK: Image Alert
    public private(set) var imageView: UIImageView? = nil
    public var image: UIImage? {
        return self.imageView?.image
    }

    // Do not edit imageTintColor using the image.tintColor reference.
    private var imageTintColor: UIColor? = nil {
        willSet {
            self.imageView?.tintColor = newValue
        }
    }

    public func setImage(tintColor: UIColor) {
        self.imageTintColor = tintColor
    }

    open var imageHeight: Float = 175 {
        willSet {
            self.imageView?.snp.updateConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }

    open func createImage(_ image: UIImage) -> UIImageView {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = self.imageTintColor
        return imgView
    }

    public func setImage(_ image: UIImage?) {
        guard let image = image else {
            self.imageView?.removeFromSuperview()
            self.imageView = nil
            return
        }

        if self.imageView == nil {
            self.imageView = self.createImage(image)
        } else {
            self.imageView?.image = image
        }

        self.alertContainer.insertArrangedSubview(self.imageView!, at: 0)
    }

    // MARK: Alert Title
    public private(set) var titleLabel: UILabel? = nil
    private var titleFont: UIFont! = {
        return UIFont(name: "HelveticaNeue-Bold", size: 18)
    }() {
        willSet {
            self.titleLabel?.font = newValue
        }
    }

    open func createTitle() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.20, green: 0.22, blue: 0.26, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = self.titleFont
        return lbl
    }

    public func setTitle(font: UIFont) {
        self.titleFont = font
    }

    public func title(_ text: String?) {
        guard let text = text else {
            self.titleLabel?.removeFromSuperview()
            self.titleLabel = nil
            return
        }

        if self.titleLabel == nil {
            self.titleLabel = self.createTitle()
        }

        self.titleLabel?.text = text

        self.alertContainer.insertArrangedSubview(self.titleLabel!, at: self.position(for: 1))
    }

    // MARK: Alert Subtitle
    private(set) var textSV: UIStackView? = nil
    private var textFont: UIFont! = {
        return UIFont(name: "HelveticaNeue", size: 16)
    }() {
        willSet {
            self.textSV?.arrangedSubviews.forEach { ($0 as? UILabel)?.font = newValue }
        }
    }

    open func createTextSV() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }
    
    open func createText() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "HelveticaNeue", size: 16)
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = textFont
        return lbl
    }

    public func setText(font: UIFont) {
        self.textFont = font
    }
    
    public func text(_ text: String?, at index: Int? = nil) {
        guard let text = text else {
            self.textSV?.removeFromSuperview()
            self.textSV = nil
            return
        }
        
        let stackView = self.textSV ?? self.createTextSV()
        let label: UILabel = {
            if let index = index, let label = stackView.arrangedSubviews[index] as? UILabel {
                return label
            }
            
            return self.createText()
        }()
        
        self.textSV = stackView
        
        if let attributed = label.attributedText {
            label.attributedText = attributed
        } else {
            label.text = text
        }
        
        if label.superview == nil {
            stackView.insertArrangedSubview(label, at: stackView.subviews.count)
        }
        
        if stackView.superview == nil {
            self.alertContainer.insertArrangedSubview(stackView, at: self.position(for: 3))
        }        
    }
    
    public final var textLabels: [UILabel] {
        return self.textSV?.arrangedSubviews.compactMap {
            $0 as? UILabel
        } ?? []
    }

    // MARK: Alert Text
    public private(set) var subtitleLabel: UILabel? = nil
    private var subtitleFont: UIFont! = {
        return UIFont(name: "HelveticaNeue", size: 14)
    }() {
        willSet {
            subtitleLabel?.font = newValue
        }
    }

    open func createSubtitle() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = self.subtitleFont
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }

    public func setSubtitle(font: UIFont) {
        self.subtitleFont = font
    }
    
    public func subtitle(_ text: String?) {
        guard let text = text else {
            self.subtitleLabel?.removeFromSuperview()
            self.subtitleLabel = nil
            return
        }

        if self.subtitleLabel == nil {
            self.subtitleLabel = self.createText()
        }

        self.subtitleLabel?.text = text

        self.alertContainer.insertArrangedSubview(self.subtitleLabel!, at: self.position(for: 2))
    }

    // MARK: Position calculate the index for alertContainer
    func position(for item: Int) -> Int {
        let array = [Any?]([
            self.image,
            self.titleLabel,
            self.subtitle,
            self.text,
            self.buttonsStackView
        ])

        let futureIndex = Array(array[0..<item]).reduce(0) { $0 + ($1 != nil ? 1 : 0) }
        return futureIndex >= self.alertContainer.arrangedSubviews.count ? self.alertContainer.arrangedSubviews.count : futureIndex
    }
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    public final var actionButtons: [UIButton] {
        return self.buttonsStackView.arrangedSubviews.compactMap {
            $0 as? UIButton
        }
    }

    // MARK: Alert layout setup
    fileprivate func setup() {
        // Clean the views
        self.view.subviews.forEach { $0.removeFromSuperview() }
        self.blurView?.removeFromSuperview()
        // Set up view
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        // Set up background image

        if let blurView = self.blurView {
            self.view.addSubview(blurView)
            blurView.snp.makeConstraints { make in
                make.top.bottom.trailing.leading.equalTo(0)
            }
        }
        // Set up the alert view
        self.view.addSubview(alertView)
        self.alertView.addSubview(alertContainer)

        alertContainer.snp.makeConstraints { make in
            make.top.leading.equalTo(self.margin)
            make.bottom.trailing.equalTo(-self.margin)
        }

        alertView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.leading.greaterThanOrEqualTo(0)
            make.bottom.trailing.lessThanOrEqualTo(0)
        }

        // Set up alertImage
        self.setImage(self.imageView?.image)
        // Set up alertTitle
        self.title(self.titleLabel?.text)
        // Set up alertSubtitle
        self.textSV?.arrangedSubviews.enumerated().forEach { index, view in
            self.text((view as? UILabel)?.text, at: index)
        }
        // Set up alertText
        self.subtitle(self.subtitleLabel?.text)
        // Set up buttonsStackView
        self.alertContainer.addArrangedSubview(buttonsStackView)

        // Set up background Tap
        self.actionButtons.forEach {
            $0.snp.makeConstraints { $0.height.equalTo(44) }
        }

        setupConstraints()
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    fileprivate func setupConstraints() {
        self.alertView.snp.makeConstraints { make in
            make.width.equalTo(alertWidth)
        }

        if let imageView = self.imageView {
            imageView.snp.makeConstraints { make in
                make.height.equalTo(self.imageHeight)
            }
        }

        [self.titleLabel, self.subtitleLabel].forEach {
            $0?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0?.setContentHuggingPriority(.defaultHigh, for: .vertical)

            $0?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0?.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        }
        
        self.textSV?.arrangedSubviews.forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        }
    }

    // MARK: Margin and padding configs
    var spacing: CGFloat {
        return 16
    }

    var margin: CGFloat {
        return spacing * 2
    }

    // MARK: Width configuration for flexible layout
    private static let defaultWidth: CGFloat = 270
    private var alertWidth: CGFloat = defaultWidth {
        willSet {
            self.alertView.snp.updateConstraints { make in
                make.width.equalTo(newValue)
            }
        }
    }

    final func flexibleWidth(_ constant: Float) {
        if constant > 1 || constant < 0 { return }

        let width = CGFloat(Float(UIScreen.main.bounds.width) * constant)
        guard width > UMAlertController.defaultWidth else {
            return
        }

        guard width <= self.view.bounds.width - (15.0*2.0) else {
            return
        }

        self.alertWidth = width
    }

    final func resetWidth() {
        self.alertWidth = UMAlertController.defaultWidth
    }

    // swiftlint:enable function_body_length
    // swiftlint:enable line_length

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !self.useBlur {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        } else {
            self.view.backgroundColor = .clear
        }
    }

    open func addAction(action: UMAlertAction) {
        let button = action.asButton()

        button.addTarget(self, action: #selector(self.tapOnAction(_:)), for: .touchUpInside)
        buttonsStackView.insertArrangedSubview(button, at: 0)
    }

    @objc private func tapOnBackground(sender: UITapGestureRecognizer) {
        guard self.buttonsStackView.arrangedSubviews.count == 0 else {
            return
        }

        if sender.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func tapOnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
