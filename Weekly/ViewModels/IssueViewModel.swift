//
//  IssueViewModel.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/1/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Kanna

struct Issue: Identifiable {
    let id: String
    
    let title: String
    let number: String
    let descriptionText: String
    let date: String
}

public class IssueListViewModel: BindableObject {
    public let didChange = PassthroughSubject<IssueListViewModel, Never>()
    
    let session = URLSession.shared

    var issues: [Issue] = [Issue]() {
        didSet {
            didChange.send(self)
        }
    }
    
    func load() {
        session.dataTaskPublisher(for: URL(string: "https://iosdevweekly.com/issues")!)
        .tryMap { String(data: $0.data, encoding: .utf8) }
        .sink(receiveValue: { response in
            DispatchQueue.main.async {
                if let doc = try? HTML(html: response!, encoding: .utf8) {

                    var fetchedIssues = [Issue]()
                    for link in doc.css(".issues a") {
                        guard let title = link.css("h2").first?.text else { continue }
                        guard let description = link.css("p").first?.text else { continue }
                        guard let date = link.css("time").first?.text else { continue }
                        fetchedIssues.append(
                            Issue(id: title,
                                  title: title,
                                  number: title.replacingOccurrences(of: "Issue ", with: ""),
                                  descriptionText: description,
                                  date: date)
                        )
                    }

                    self.issues = fetchedIssues
                }
            }
        })
    }
    
}

struct Link: Identifiable {
    let id: String
    
    let title: String
    let webURL: URL
    let descriptionText: String
    let footer: String
}

public class IssueViewModel: BindableObject {
    public let didChange = PassthroughSubject<IssueViewModel, Never>()
    
    let session = URLSession.shared
    
    var links: [Link] = [Link]() {
        didSet {
            didChange.send(self)
        }
    }
    
    func load(_ issue: Issue) {
        session.dataTaskPublisher(for: URL(string: "https://iosdevweekly.com/issues/\(issue.number)")!)
        .tryMap { String(data: $0.data, encoding: .utf8) }
        .sink(receiveValue: { response in
            DispatchQueue.main.async {
                if let doc = try? HTML(html: response!, encoding: .utf8) {

                    var fetchedLinks = [Link]()
                    for link in doc.css(".item.item--issue.item--link") {
                        guard let title = link.css("h3").first?.text else { continue }
                        guard let linkURL = link.css("a[href*=cur.at]").first!["href"] else { continue }
                        guard let description = link.css("p").first?.text else { continue }
                        guard let footer = link.css(".item__footer").first?.text else { continue }

                        fetchedLinks.append(
                            Link(id: title,
                                  title: title,
                                  webURL: URL(string:linkURL)!,
                                  descriptionText: description,
                                  footer: footer
                            )
                        )
                    }
                    
                    self.links = fetchedLinks
                }
            }
        })
    }
    
}
