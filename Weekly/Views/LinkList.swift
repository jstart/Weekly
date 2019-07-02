//
//  LinkList.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/2/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import SwiftUI

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
