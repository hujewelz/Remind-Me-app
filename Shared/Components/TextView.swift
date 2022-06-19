//
//  TextView.swift
//  TODO
//
//  Created by huluobo on 2022/1/26.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    let prompt: String?
    @Binding var text: String
    
    private var foregroundColor: Color?
    private var backgroundColor: Color?
    private var placeholderColor: Color?
    private var font: Font?
    
    init(text: Binding<String>, prompt: String? = nil) {
        _text = text
        self.prompt = prompt
    }
    
    func makeUIView(context: Context) -> PromptTextView {
        let textView = PromptTextView()
        textView.text = text
        textView.prompt = prompt
        textView.delegate = context.coordinator
        if let foregroundColor = foregroundColor {
            textView.textColor = UIColor(foregroundColor)
        }
        if let backgroundColor = backgroundColor {
            textView.backgroundColor = UIColor(backgroundColor)
        }
        if let placeholderColor = placeholderColor {
            textView.placeholderColor = UIColor(placeholderColor)
        }
        if let font = font {
            textView.font = .preferredFont(from: font)
        }
        return textView
    }
    
    func updateUIView(_ uiView: PromptTextView, context: Context) {
        uiView.text = text
        uiView.prompt = prompt
        if let foregroundColor = foregroundColor {
            uiView.textColor = UIColor(foregroundColor)
        }
        if let placeholderColor = placeholderColor {
            uiView.placeholderColor = UIColor(placeholderColor)
        }
        if let font = font {
            uiView.font = .preferredFont(from: font)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.setNeedsDisplay()
        }
        
        func textViewDidChange(_ textView: UITextView) {
            textView.setNeedsDisplay()
        }
    }
}

class PromptTextView: UITextView {
    var prompt: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var placeholderColor: UIColor = .systemGray2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if !text.isEmpty { return }
        
        guard let prompt = prompt else {
            return
        }

        var attrs: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor]
        if let font = self.font {
            attrs[.font] = font
        }
        let textRect = CGRect(x: 4, y: 8, width: rect.width - 8, height: rect.height)
        NSString(string: prompt).draw(in: textRect, withAttributes: attrs)
    }
}

extension TextView {
    func placeholderColor(_ color: Color) -> TextView {
        var view = self
        view.placeholderColor = color
        return view
    }
    
    func foregroundColor(_ color: Color) -> TextView {
        var view = self
        view.foregroundColor = color
        return view
    }
    
    func backgroundColor(_ color: Color) -> TextView {
        var view = self
        view.backgroundColor = color
        return view
    }
    
    func font(_ font: Font) -> TextView {
        var view = self
        view.font = font
        return view
    }
}

extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let uiFont: UIFont
        
        switch font {
        case .largeTitle:
            uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            uiFont = UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            uiFont = UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            uiFont = UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            uiFont = UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            uiFont = UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            uiFont = UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            uiFont = UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            uiFont = UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            fallthrough
        default:
            uiFont = UIFont.preferredFont(forTextStyle: .body)
        }
        
        return uiFont
    }
}
