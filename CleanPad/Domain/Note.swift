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
    
    var title = ""
    var textContent = ""
    
    /// Example note for previews and testing.
    static let example = Note(
        title: "This is an example note",
        textContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna. Mauris eleifend ipsum at faucibus dictum. Phasellus quam nulla, tristique vulputate diam id, ullamcorper hendrerit felis. Vestibulum faucibus tristique rutrum. Vivamus posuere semper orci, sit amet imperdiet nulla. Phasellus ultricies eget odio in posuere.
        """
    )
    
    /// Example non-locked notes. Useful when testing the List UI.
    static let nonLockedExamples: [Note] =
    [
        Note(
            title: "Note 111",
            textContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            title: "Note 122",
            textContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            title: "Note 123",
            textContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            title: "Note 134",
            textContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            title: "Note 115",
            textContent: """
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
            title: "Locked Note 111",
            textContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            title: "Locked Note 122",
            textContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            title: "Locked Note 123",
            textContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            title: "Locked Note 134",
            textContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        ),
        Note(
            isLocked: true,
            title: "Locked Note 115",
            textContent: """
        Hello, world! 🌍
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """
        )
    ]
}
