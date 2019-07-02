//
//  IssueList.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/2/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI

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
