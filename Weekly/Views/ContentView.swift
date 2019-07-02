//
//  ContentView.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/1/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI

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
