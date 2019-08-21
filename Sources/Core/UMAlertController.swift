//
//  UMAlertController.swift
//  UMUtils_Swift
//
//  Created by brennobemoura on 21/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import UIKit

public enum UMActionStyle {
    case `default`, cancel
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
    fileprivate let style: UMActionStyle

    required public init(title: String?, handler: ((UMAlertAction) -> Void)? = nil, style: UMActionStyle? = nil) {
        self.title = title
        self.handler = handler
        self.style = style ?? .default
    }

    func asButton() -> UIButton {
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
    open var blurEffectStyle: UIBlurEffect.Style = .light
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
    fileprivate(set) var alertView: UIView = {
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
    private var image: UIImageView? = nil

    // Do not edit imageTintColor using the image.tintColor reference.
    private var imageTintColor: UIColor? = nil {
        willSet {
            self.image?.tintColor = newValue
        }
    }

    public func setImage(tintColor: UIColor) {
        self.imageTintColor = tintColor
    }

    open var imageHeight: Float = 175 {
        willSet {
            self.image?.snp.updateConstraints { make in
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
            self.image?.removeFromSuperview()
            self.image = nil
            return
        }

        if self.image == nil {
            self.image = self.createImage(image)
        } else {
            self.image?.image = image
        }

        self.alertContainer.insertArrangedSubview(self.image!, at: 0)
    }

    // MARK: Alert Title
    private var _title: UILabel? = nil
    private var titleFont: UIFont! = {
        return UIFont(name: "HelveticaNeue-Bold", size: 18)
    }() {
        willSet {
            self._title?.font = newValue
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

    func setTitle(font: UIFont) {
        self.titleFont = font
    }

    func title(_ text: String?) {
        guard let text = text else {
            self._title?.removeFromSuperview()
            self._title = nil
            return
        }

        if self._title == nil {
            self._title = self.createTitle()
        }

        self._title?.text = text

        self.alertContainer.insertArrangedSubview(self._title!, at: self.position(for: 1))
    }

    // MARK: Alert Subtitle
    private var subtitle: UILabel? = nil
    private var subtitleFont: UIFont! = {
        return UIFont(name: "HelveticaNeue", size: 16)
    }() {
        willSet {
            subtitle?.font = newValue
        }
    }

    open func createSubtitle() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "HelveticaNeue", size: 16)
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = subtitleFont
        return lbl
    }

    func setSubtitle(font: UIFont) {
        self.subtitleFont = font
    }

    func subtitle(_ text: String?) {
        guard let text = text else {
            self.subtitle?.removeFromSuperview()
            self.subtitle = nil
            return
        }

        if self.subtitle == nil {
            self.subtitle = self.createSubtitle()
        }

        self.subtitle?.text = text

        self.alertContainer.insertArrangedSubview(self.subtitle!, at: self.position(for: 2))
    }

    // MARK: Alert Text
    private var text: UILabel? = nil
    private var textFont: UIFont! = {
        return UIFont(name: "HelveticaNeue", size: 14)
    }() {
        willSet {
            text?.font = newValue
        }
    }

    open func createText() -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = self.textFont
        lbl.minimumScaleFactor = 0.65
        lbl.textColor = UIColor(red: 0.51, green: 0.54, blue: 0.58, alpha: 1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }

    func setText(font: UIFont) {
        self.textFont = font
    }
    
    func text(_ text: String?) {
        guard let text = text else {
            self.text?.removeFromSuperview()
            self.text = nil
            return
        }

        if self.text == nil {
            self.text = self.createText()
        }

        self.text?.text = text

        self.alertContainer.insertArrangedSubview(self.text!, at: self.position(for: 3))
    }

    // MARK: Position calculate the index for alertContainer
    func position(for item: Int) -> Int {
        let array = [Any?]([
            self.image,
            self._title,
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
        self.setImage(self.image?.image)
        // Set up alertTitle
        self.title(self._title?.text)
        // Set up alertSubtitle
        self.subtitle(self.subtitle?.text)
        // Set up alertText
        self.text(self.text?.text)
        // Set up buttonsStackView
        self.alertContainer.addArrangedSubview(buttonsStackView)

        // Set up background Tap
        self.buttonsStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints { $0.height.equalTo(44) }
            $0.layer.cornerRadius = 22
        }

        setupConstraints()
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    fileprivate func setupConstraints() {
        self.alertView.snp.makeConstraints { make in
            make.width.equalTo(alertWidth)
        }

        if let imageView = self.image {
            imageView.snp.makeConstraints { make in
                make.height.equalTo(self.imageHeight)
            }
        }

        [self._title, self.subtitle, self.text].forEach {
            $0?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0?.setContentHuggingPriority(.defaultHigh, for: .vertical)

            $0?.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0?.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
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
