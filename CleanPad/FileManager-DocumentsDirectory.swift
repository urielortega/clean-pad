//
//  FileManager-DocumentsDirectory.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        // Find all possible documents directories for this user.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // Send back the first one, which ought to be the only one.
        return paths[0]
    }
}
