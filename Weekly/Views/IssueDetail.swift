//
//  IssueDetail.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/2/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI

struct IssueDetailView: View {
    
    var issue: Issue
    @ObjectBinding private var issueViewModel = IssueViewModel()
    @State var isModal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            IssueHeaderView(issue: issue)
            Divider()
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

struct IssueHeaderView: View {
    
    var issue: Issue
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                Text(issue.descriptionText)
                    .lineLimit(nil)
                Text(issue.date)
                    .font(.caption)
                    .color(.gray)
            }
            Spacer()
        }
    }
}
