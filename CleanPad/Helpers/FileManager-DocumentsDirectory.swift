//
//  FileManager-DocumentsDirectory.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

extension FileManager {
    /// Property for retrieving all possible documents directories for the user and sending back the first one.
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0] // Send back the first one, which ought to be the only one.
    }
}
