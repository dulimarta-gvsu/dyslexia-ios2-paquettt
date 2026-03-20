//
//  AppViewModel.swift
//  dyslexia

import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var letters: [Letter] = []

    // current word
    @Published var moves: Int = 0
    @Published var totalScore: Int = 0
    @Published var timeSpentMillis: Int = 0
    @Published var congratsMessage: String? = nil
    @Published var gameHistory: [WordRecord] = []

    // settings
    @Published var minWordLen: Int = 3
    @Published var maxWordLen: Int = 12
    @Published var tileR: Int = 210
    @Published var tileG: Int = 180
    @Published var tileB: Int = 140

    private var secretWord: String = ""
    private var wordStartTimeMillis: Int = 0

    // colors
    let wordStock: [String] = [
        "red", "blue", "green", "yellow", "orange", "purple",
        "violet", "indigo", "pink", "brown", "black", "white",
        "gray", "cyan", "magenta", "maroon", "navy", "teal",
        "lime", "olive", "gold", "silver", "beige", "coral",
        "turquoise", "lavender", "crimson", "scarlet", "amber", "bronze"
    ]

    // scrabble scoring
    let letterScore: [Character: Int] = [
        "A": 1, "B": 3, "C": 3, "D": 2, "E": 1,
        "F": 4, "G": 2, "H": 4, "I": 1, "J": 8,
        "K": 5, "L": 1, "M": 3, "N": 1, "O": 1,
        "P": 3, "Q": 10, "R": 1, "S": 1, "T": 1,
        "U": 1, "V": 4, "W": 4, "X": 8, "Y": 4,
        "Z": 10
    ]

    init () {
        self.startNewGame()
    }

    func startNewGame() {
        self.selectNewWord()
    }

    func selectNewWord() {
        // if previous word was not solved, save incomplete history
        if !self.secretWord.isEmpty && self.congratsMessage == nil {
            let elapsed = Int(Date().timeIntervalSince1970 * 1000) - self.wordStartTimeMillis
            self.gameHistory.append(
                WordRecord(
                    word: self.secretWord,
                    point: 0,
                    moves: self.moves,
                    seconds: elapsed / 1000
                )
            )
        }

        let candidates = self.wordStock.filter {
            $0.count >= self.minWordLen && $0.count <= self.maxWordLen
        }

        let newWord = (candidates.isEmpty ? self.wordStock.randomElement()! : candidates.randomElement()!).uppercased()
        self.secretWord = newWord

        self.letters.removeAll()
        self.letters.append(contentsOf:
            self.secretWord.map { ch in
                Letter(text: String(ch), point: self.letterScore[ch] ?? 1)
            }.shuffled()
        )

        self.moves = 0
        self.timeSpentMillis = 0
        self.congratsMessage = nil
        self.wordStartTimeMillis = Int(Date().timeIntervalSince1970 * 1000)
    }

    func rearrange(to arr: Array<Letter>) {
        let before = self.letters.prettyPrint()
        let after = arr.prettyPrint()

        if before != after {
            self.moves += 1
        }

        self.letters = arr
        self.checkSolved()
    }

    private func computeWordScore() -> Int {
        return self.letters.reduce(0) { total, letter in
            total + letter.point
        }
    }

    private func checkSolved() {
        if self.congratsMessage != nil {
            return
        }

        let guess = self.letters.prettyPrint()
        if guess == self.secretWord {
            let elapsedMillis = Int(Date().timeIntervalSince1970 * 1000) - self.wordStartTimeMillis
            self.timeSpentMillis = elapsedMillis

            let wordScore = self.computeWordScore()
            self.totalScore += wordScore

            self.gameHistory.append(
                WordRecord(
                    word: self.secretWord,
                    point: wordScore,
                    moves: self.moves,
                    seconds: elapsedMillis / 1000
                )
            )

            self.congratsMessage = "Correct!"
        }
    }

    func sortByWord() {
        self.gameHistory.sort { $0.word < $1.word }
    }

    func sortByPoint() {
        self.gameHistory.sort { $0.point > $1.point }
    }

    func sortByMoves() {
        self.gameHistory.sort { $0.moves < $1.moves }
    }

    func sortBySeconds() {
        self.gameHistory.sort { $0.seconds > $1.seconds }
    }

    func setWordLengthRange(min: Int, max: Int) {
        self.minWordLen = Swift.min(min, max)
        self.maxWordLen = Swift.max(min, max)
    }

    func setTileR(v: Int) {
        self.tileR = max(0, min(255, v))
    }

    func setTileG(v: Int) {
        self.tileG = max(0, min(255, v))
    }

    func setTileB(v: Int) {
        self.tileB = max(0, min(255, v))
    }
}
