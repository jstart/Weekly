//
//  SafariView.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/2/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI
import WebKit
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SafariView>) {
    }
    
}

struct WebView: UIViewRepresentable {
    
    let URL: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL))
    }
    
}
