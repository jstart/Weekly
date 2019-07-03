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
    @State private var pageIndex = 1
    @State private var isLoading = false
    
    var body: some View {
        List(issueListViewModel.issues) { issue in
            NavigationButton(destination: IssueDetailView(issue: issue)) {
                IssueListItem(issue: issue)
                //TODO: This crashes as it updates the view hierarchy while it is being rendered "Modifying state during view update, this will cause undefined behavior."
//                .onAppear {
//                    if self.issueListViewModel.isLoading == false && self.isLastPage(issue) {
//                        self.issueListViewModel.load(pageIndex: self.pageIndex + 1)
//                        self.pageIndex += 1
//                    }
//                }
            }
        }
        .navigationBarTitle(Text("iOS Dev Weekly"))
        .onAppear {
            self.issueListViewModel.load()
        }
    }
    
    func isLastPage(_ issue: Issue) -> Bool {
        if issue.title == issueListViewModel.issues.last?.title {
            return true
        }
        return false
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
