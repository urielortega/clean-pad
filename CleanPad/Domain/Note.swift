//
//  Note.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

/// Model representing a note in the app, defining its structure and properties.
/// A note includes a title, content, category, creation date, and a flag indicating whether it is locked (private).
struct Note: Codable, Identifiable, Equatable {
    var id = UUID()
    
    /// Property that indicates whether a note is private (locked) or not.
    var isLocked = false
    
    var date = Date.now
    
    var noteTitle = ""
    var noteContent = ""
    
    var category: Category?
    
    var unwrappedCategoryName: String {
        category?.name ?? "No category"
    }
}

#if DEBUG
extension Note {
    /// Example note for previews and testing.
    static let example = Note(
        noteTitle: "This is an example note",
        noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna. Mauris eleifend ipsum at faucibus dictum. Phasellus quam nulla, tristique vulputate diam id, ullamcorper hendrerit felis. Vestibulum faucibus tristique rutrum. Vivamus posuere semper orci, sit amet imperdiet nulla. Phasellus ultricies eget odio in posuere.
        """,
        category: .thoughts
    )
    
    /// Example non-locked notes for UI testing of the List UI.
    static let nonLockedExamples: [Note] =
    [
        Note(
            noteTitle: "Note 111",
            noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .business
        ),
        Note(
            noteTitle: "Note 122",
            noteContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .cleanPad
        ),
        Note(
            noteTitle: "Note 123",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .health
        ),
        Note(
            noteTitle: "Note 134",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .personal
        ),
        Note(
            noteTitle: "Note 115",
            noteContent: """
        Hello, world! 🌍
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .professional
        )
    ]
    
    /// Example locked notes for UI testing of the List UI.
    static let lockedExamples: [Note] =
    [
        Note(
            isLocked: true,
            noteTitle: "Locked Note 111",
            noteContent: """
        Hello, world! 🌎
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .business
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 122",
            noteContent: """
        Hello, world! 🗺️
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .cleanPad
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 123",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .health
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 134",
            noteContent: """
        Hello, world! 🌏
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .personal
        ),
        Note(
            isLocked: true,
            noteTitle: "Locked Note 115",
            noteContent: """
        Hello, world! 🌍
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent volutpat dui eget metus porttitor dapibus. Nunc sed arcu gravida, ornare eros vitae, finibus orci. Aenean ac augue faucibus, gravida lectus nec, lobortis magna.
        """,
            category: .professional
        )
    ]
    
    /// Example notes for UI testing screenshots.
    static let screenshotsExamples: [Note] =
    [
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 11, hour: 11, minute: 11))!,
            noteTitle: "CleanPad 2.0 Features 📒",
            noteContent: """
            - Organize with Categories 🗂️
              Group your notes by category for a cleaner experience.
            
            - Revamped UI/UX 🎨
              A smoother, comfier experience all around!
            
            - Accessible Screens 👓
              Improved accessibility for everyone.
            
            - New About & Feedback Sections 💬
              Learn about CleanPad and share your thoughts.
            """,
            category: .cleanPad
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 22, hour: 6, minute: 30))!,
            noteTitle: "My favorite quote",
            noteContent: """
        "Here's to the crazy ones. The misfits, the rebels, the troublemakers, the round pegs in the square holes, the ones who see things differently. They're not fond of rules, and they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things"
        """,
            category: .thoughts
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 9, day: 1, hour: 11, minute: 11))!,
            noteTitle: "Hello, World! 🤖",
            noteContent: "🦅🔥🍎",
            category: .cleanPad
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 26, hour: 18, minute: 26))!,
            noteTitle: "A happy day! 😃",
            noteContent: "This day was amazing! My first app was released on the App Store and I couldn't be more excited!",
            category: .personal
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 25, hour: 20, minute: 23))!,
            noteTitle: "New projects ✨",
            noteContent: "1. Candy Shop Opening 🍬 \n 2. Math school \n 3. ...",
            category: .business
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 24, hour: 20, minute: 23))!,
            noteTitle: "A difficult day...",
            noteContent: "😓",
            category: .thoughts
        ),
        Note(isLocked: true, noteTitle: "A very private note... 🤫", noteContent: "Here's to the gossip ones...", category: .thoughts),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 15, hour: 14, minute: 45))!,
            noteTitle: "Dream Vacation",
            noteContent: "Planning a trip to Bali! 🌴✈️",
            category: .personal
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 6, day: 10, hour: 9, minute: 30))!,
            noteTitle: "Ideas for Novel",
            noteContent: """
                1. Main character introduction.
                2. Plot twist in the middle.
                3. Unexpected ending.
                """,
            category: .thoughts
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5, hour: 17, minute: 30))!,
            noteTitle: "Healthy Recipes 🥗",
            noteContent: "1. Quinoa Salad \n2. Avocado Smoothie \n3. Baked Salmon",
            category: .health
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1, hour: 20, minute: 0))!,
            noteTitle: "Coding Ideas 💻",
            noteContent: "1. Learn SwiftUI animations \n2. Build a to-do app \n3. Contribute to an open-source project",
            category: .professional
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 11, day: 11, hour: 11, minute: 11))!,
            noteTitle: "Gratitude Journal",
            noteContent: "1. Family and friends 💖 \n2. Good health 🌿 \n3. Opportunities for growth 🚀",
            category: .personal
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3, hour: 12, minute: 0))!,
            noteTitle: "Fitness Goals",
            noteContent: "1. Morning jog three times a week \n2. Yoga every Saturday \n3. Drink more water 💧",
            category: .health
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 18, hour: 16, minute: 0))!,
            noteTitle: "Book Recommendations 📚",
            noteContent: "1. 'The Alchemist' by Paulo Coelho \n2. 'Atomic Habits' by James Clear \n3. 'The Silent Patient' by Alex Michaelides",
            category: .personal
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 28, hour: 19, minute: 15))!,
            noteTitle: "Random Thoughts",
            noteContent: "1. Why do we yawn? \n2. Are we alone in the universe? 👽 \n3. The meaning of dreams 🌙",
            category: .thoughts
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 22, hour: 10, minute: 45))!,
            noteTitle: "Tech Wishlist",
            noteContent: "1. Upgraded MacBook Pro 💻  \n2. Apple Vision Pro 🥽 \n3. AirPods Max 🎧",
            category: .professional
        ),
        Note(
            date: Calendar.current.date(from: DateComponents(year: 2022, month: 7, day: 7, hour: 7, minute: 7))!,
            noteTitle: "Lucky Numbers",
            noteContent: "7 is my lucky number today! 🍀",
            category: .thoughts
        )
    ]
}
#endif
