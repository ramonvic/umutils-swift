//
//  UITextField+Masks.swift
//  SPA at home
//
//  Created by Ramon Vicente on 27/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Material

var UITextFieldDefaultCharMaskKey = 0
var UITextFieldMaskTextKey = 0
var UITextFieldDelegateKey = 0
var UITextFieldProxyDelegateKey = 0
var UITextFieldTextKey = 0

extension TextField {

    fileprivate var proxyDelegate: ProxyDelegate? {
        if let _proxy = objc_getAssociatedObject(self, &UITextFieldProxyDelegateKey) as? ProxyDelegate {
            return _proxy
        }

        let _proxy = ProxyDelegate()
        objc_setAssociatedObject(self, &UITextFieldProxyDelegateKey, _proxy, .OBJC_ASSOCIATION_RETAIN)
        return _proxy
    }

    open override var delegate: UITextFieldDelegate? {
        get {
            return objc_getAssociatedObject(self, &UITextFieldDelegateKey) as? UITextFieldDelegate
        }
        set(value) {
            objc_setAssociatedObject(self, &UITextFieldDelegateKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var maskedText: String? {
        get {
            return objc_getAssociatedObject(self, &UITextFieldTextKey) as? String
        }
        set(value) {
            objc_setAssociatedObject(self, &UITextFieldTextKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var maskText: String {
        get {
            if let _mask = objc_getAssociatedObject(self, &UITextFieldMaskTextKey) as? String {
                return _mask
            }
            return ""
        }
        set(value) {
            objc_setAssociatedObject(self, &UITextFieldMaskTextKey, value, .OBJC_ASSOCIATION_RETAIN)
            super.delegate = self.proxyDelegate
            if let _text = text, maskedText != text, !text!.isEmpty {
                self.text = _text
            }
        }
    }

    open override var text: String? {
        didSet {
            guard text != nil && maskedText != text && !maskText.isEmpty, !text!.isEmpty else {
                return
            }

            let _text = text ?? ""

            for i in (0..<_text.characters.count) {
                let _maskedText = maskedText ?? ""

                if _maskedText.characters.count == self.maskText.characters.count {
                    break
                }

                let char = _text[_text.index(_text.startIndex, offsetBy: i)]
                _ = shouldChangeCharacters(inRange: NSRange(location: _maskedText.characters.count, length: 0),
                                           replacementString: String(char),
                                           mask: maskText)
            }

            self.text = self.maskedText
        }
    }

    public var defaultCharMask: String {
        get {
            return objc_getAssociatedObject(self, &UITextFieldDefaultCharMaskKey) as? String ?? "#"
        }
        set(value) {
            objc_setAssociatedObject(self, &UITextFieldDefaultCharMaskKey, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func shouldChangeCharacters(inRange range: NSRange, replacementString string: String) -> Bool {

        defer {
            self.text = self.maskedText
            self.sendActions(for: .valueChanged)
        }

        return self.shouldChangeCharacters(inRange: range, replacementString: string, mask: self.maskText)
    }

    func shouldChangeCharacters(inRange range: NSRange, replacementString string: String, mask: String) -> Bool {

        var currentTextDigited = ((self.maskedText ?? "") as NSString?)?
            .replacingCharacters(in: range, with: string) ?? ""

        if string.isEmpty {
            while currentTextDigited.characters.count > 0 && !lastCharacterIsNumber(currentTextDigited) {
                currentTextDigited.remove(at: currentTextDigited.index(before: currentTextDigited.endIndex))
            }
            self.maskedText = currentTextDigited
            return false
        }

        if currentTextDigited.characters.count > mask.characters.count {
            return false
        }

        var finalText: String = ""
        var last = 0
        var needAppend = false

        for i in (0..<currentTextDigited.characters.count) {
            let currentCharMask = mask[mask.index(mask.startIndex, offsetBy: i)]
            let currentChar = currentTextDigited[currentTextDigited.index(currentTextDigited.startIndex, offsetBy: i)]

            if isNumber(currentChar) && currentCharMask == "#" {
                finalText.append(currentChar)
            } else {
                if currentCharMask == "#" {
                    break
                }

                if isNumber(currentChar) && currentCharMask != currentChar {
                    needAppend = true
                }

                finalText.append(currentCharMask)
            }
            last = i
        }

        last += 1

        for j in (last..<mask.characters.count) {

            let currentCharMask = mask[mask.index(mask.startIndex, offsetBy: j)]

            if currentCharMask != "#" {
                finalText.append(currentCharMask)
            } else {
                break
            }
        }

        if needAppend {
            finalText.append(string)
        }

        self.maskedText = finalText

        return false
    }

    func isNumber(_ character: Character?) -> Bool {
        guard character != nil else {
            return false
        }

        guard Int(String(describing: character!)) != nil else {
            return false
        }

        return true
    }

    func lastCharacterIsNumber(_ string: String) -> Bool {
        return isNumber(string.characters.last)
    }
}

fileprivate class ProxyDelegate: NSObject, UITextFieldDelegate {

    fileprivate func textField(_ textField: UITextField,
                               shouldChangeCharactersIn range: NSRange,
                               replacementString string: String) -> Bool {

        guard textField.delegate == nil else {
            return textField.delegate!.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }

        guard let textField = textField as? TextField else {
            return true
        }

        guard !textField.maskText.isEmpty else {
            return true
        }

        return textField.shouldChangeCharacters(inRange: range, replacementString: string)
    }
}
