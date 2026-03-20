//
//  WordRecord.swift
//  dyslexia

import Foundation

struct WordRecord: Identifiable, Hashable {
    let id: UUID = UUID()
    let word: String
    let point: Int
    let moves: Int
    let seconds: Int
}
