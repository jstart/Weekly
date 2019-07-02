//
//  ContentView.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/1/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {
    @ObjectBinding private var issueViewModel = IssueViewModel()
    
    var body: some View {
        NavigationView {
            IssueListView()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct IssueListView: View {
    @ObjectBinding private var issueListViewModel = IssueListViewModel()

    var body: some View {
        List(issueListViewModel.issues) { issue in
            NavigationButton(destination: IssueDetailView(issue: issue)) {
                IssueListItem(issue: issue)
            }
        }
        .navigationBarTitle(Text("iOS Dev Weekly"))
        .onAppear {
            self.issueListViewModel.load()
        }
    }
}

struct IssueListItem: View {

    var issue: Issue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(issue.title)
                .font(.headline)
                .lineLimit(nil)
            Text(issue.descriptionText)
                .lineLimit(nil)
            Text(issue.date)
                .font(.caption)
                .color(.gray)
        }
    }
}

struct IssueDetailView: View {
    
    var issue: Issue
    @ObjectBinding private var issueViewModel = IssueViewModel()
    @State var isModal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Spacer()
                IssueListItem(issue: issue)
                Spacer()
            }
            Divider()
            Text("Links go here")
            List(issueViewModel.links) { link in
                Button(action: {
                    self.isModal = true
                }) {
                    LinkListItem(link: link)
                }.presentation(self.isModal ? Modal(SafariView(url: link.webURL)) : nil)
            }
        }
        .navigationBarTitle(Text(issue.title))
        .onAppear {
            self.issueViewModel.load(self.issue)
        }
    }
}

struct LinkListItem: View {
    
    var link: Link
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(link.title)
                .font(.headline)
            Text(link.descriptionText)
                .lineLimit(nil)
            Text(link.footer)
                .font(.caption)
                .color(.gray)
        }
    }
}

import SwiftUI
import WebKit
import SafariServices

struct WebView : UIViewRepresentable {
    
    let URL: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL))
    }
    
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SafariView>) {
    }
    
}
