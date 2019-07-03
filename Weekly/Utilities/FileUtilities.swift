//
//  FileUtilities.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/3/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import Foundation

struct FileUtility {
    
    let fileManager = FileManager.default
    
    func writeToFile(_ response: String, fileName: String) {
        guard let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = dir.appendingPathComponent(fileName)
        do {
            try response.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    
    func responseFromFile(fileName: String) -> String? {
        guard let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = dir.appendingPathComponent(fileName)
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {/* error handling here */}
        return nil
    }
    
}
