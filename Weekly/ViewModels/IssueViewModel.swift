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

class IssueListViewModel: BindableObject {
    let didChange = PassthroughSubject<IssueListViewModel, Never>()
    
    let session = URLSession.shared
    let fileManager = FileManager.default

    private(set) var issues: [Issue] = [Issue]() {
        didSet {
            didChange.send(self)
        }
    }
    
    private(set) var isLoading = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func load(pageIndex: Int = 1) {
        self.isLoading = true
        
        if cacheValid(pageIndex: pageIndex) {
            guard let response = FileUtility().responseFromFile(fileName: "issues-\(pageIndex)") else { return }
            guard let doc = try? HTML(html: response, encoding: .utf8)  else { return }

            let fetchedIssues = self.parseDocument(doc)
            DispatchQueue.main.async {
                self.issues.append(contentsOf: fetchedIssues)
                self.isLoading = false
            }
            
            return
        }

        session.dataTaskPublisher(for: URL(string: "https://iosdevweekly.com/issues?page=\(pageIndex)")!)
        .tryMap { String(data: $0.data, encoding: .utf8) }
        .sink(receiveValue: { response in
            guard let response = response else { return }
            if let doc = try? HTML(html: response, encoding: .utf8) {
                FileUtility().writeToFile(response, fileName: "issues-\(pageIndex)")

                let fetchedIssues = self.parseDocument(doc)
                UserDefaults.standard.set(fetchedIssues[0].date, forKey:"latest-issue-date-\(pageIndex)")
                
                DispatchQueue.main.async {
                    self.issues.append(contentsOf: fetchedIssues)
                    self.isLoading = false
                }
            }
        })
    }
    
    func parseDocument(_ doc: HTMLDocument) -> [Issue] {
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
        return fetchedIssues
    }
    
    func cacheValid(pageIndex: Int) -> Bool {
        if var dateString = UserDefaults.standard.string(forKey: "latest-issue-date-\(pageIndex)") {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            
            dateString = dateString.stringByRemoving(subStrings: ["th", "nd", "rd", "st"])
            if let date = formatter.date(from: dateString) {
                let components = Calendar.current.dateComponents([.day], from: date, to: Date())
                if let days = components.day {
                    if days < 7 {
                        return true
                    }
                }
            }
        }
        return false
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

    private(set) var links: [Link] = [Link]() {
        didSet {
            didChange.send(self)
        }
    }
    
    func load(_ issue: Issue) {
        if let response = FileUtility().responseFromFile(fileName: issue.number) {
            guard let doc = try? HTML(html: response, encoding: .utf8) else { return }
            let fetchedLinks = self.parseDocument(doc)
            DispatchQueue.main.async {
                self.links = fetchedLinks
            }
            return
        }
        session.dataTaskPublisher(for: URL(string: "https://iosdevweekly.com/issues/\(issue.number)")!)
        .tryMap { String(data: $0.data, encoding: .utf8) }
        .sink(receiveValue: { response in
            guard let response = response else { return }
            guard let doc = try? HTML(html: response, encoding: .utf8) else { return }
            FileUtility().writeToFile(response, fileName: issue.number)

            let fetchedLinks = self.parseDocument(doc)
            DispatchQueue.main.async {
                self.links = fetchedLinks
            }
        })
    }
    
    func parseDocument(_ doc: HTMLDocument) -> [Link] {
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
        return fetchedLinks
    }

}
