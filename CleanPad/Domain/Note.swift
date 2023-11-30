//
//  Note.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

/// Main model in the app defining a note structure.
struct Note: Codable, Identifiable, Equatable {
    var id = UUID()
    
    /// Property that indicates whether a note is personal (locked) or not.
    var isLocked = false
    
    var date = Date.now
    
    var noteTitle = ""
    var noteContent = ""
}

extension Note {
    /// Example note for previews and testing.
    static let example = Note(
        noteTitle: "This is an example note",
        noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna. Mauris eleifend ipsum at faucibus dictum. Phasellus quam nulla, tristique vulputate diam id, ullamcorper hendrerit felis. Vestibulum faucibus tristique rutrum. Vivamus posuere semper orci, sit amet imperdiet nulla. Phasellus ultricies eget odio in posuere.
        """
    )
    
    /// Example non-locked notes. Useful when testing the List UI.
    static let nonLockedExamples: [Note] =
    [
        Note(
            noteTitle: "Note 111",
            noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            noteTitle: "Note 122",
            noteContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            noteTitle: "Note 123",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            noteTitle: "Note 134",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            noteTitle: "Note 115",
            noteContent: """
        Hello, world! 🌍
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        )
    ]
    
    /// Example locked notes. Useful when testing the List UI.
    static let lockedExamples: [Note] =
    [
        Note(
            isLocked: true,
            noteTitle: "Locked Note 111",
            noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 122",
            noteContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 123",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 134",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 115",
            noteContent: """
        Hello, world! 🌍
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        )
    ]
}
