import SwiftUI

struct LetterGroup: View {
    @Binding var letters: [Letter]
    var tileColor: Color = .mint
    var onRearrangeLetters: ([Letter]) -> Void

    @State var boxSize = CGSize.zero
    @State var startCellIndex: Int? = nil
    @State var blankCellIndex: Int? = nil
    @State var pointerIndex: Float? = nil
    @State var dragOffset = CGPoint.zero
    @State var draggedLetter: Letter? = nil
    @State var startPointerPosition = CGPoint.zero
    @GestureState var what = false

    var body: some View {
        ZStack {
            let letterSize = min(80, (UIScreen.main.bounds.width - 32) / CGFloat(max(letters.count, 1)))

            if let draggedLetter {
                BigLetter(letter: draggedLetter, size: letterSize, tileColor: tileColor)
                    .offset(x: dragOffset.x + startPointerPosition.x - boxSize.width / 2, y: dragOffset.y)
            }

            VStack {
                HStack(spacing: 2) {
                    if letters.count > 0 {
                        ForEach(Array(self.letters.enumerated()), id: \.offset) { pos, letter in
                            BigLetter(letter: letter, size: letterSize, tileColor: tileColor)
                        }
                    } else {
                        BigLetter(letter: Letter(), size: letterSize, tileColor: tileColor)
                    }
                }
                .onGeometryChange(for: CGSize.self,
                                  of: { $0.size as CGSize},
                                  action: {
                    boxSize = $0
                })
                .gesture(DragGesture()
                    .onChanged { drag in
                        guard letters.count > 0 else { return }

                        let percentage = drag.location.x / boxSize.width
                        var index = percentage * CGFloat(letters.count)
                        startPointerPosition = drag.startLocation

                        if index < 0 {
                            index = 0
                        } else if index > CGFloat(letters.count - 1) {
                            index = CGFloat(letters.count - 1)
                        }

                        if draggedLetter == nil {
                            blankCellIndex = Int(index)
                            draggedLetter = letters[blankCellIndex!]
                            letters[blankCellIndex!] = Letter()
                        }

                        if startCellIndex == nil {
                            startCellIndex = Int(index)
                        }

                        if blankCellIndex != Int(index) {
                            letters[blankCellIndex!] = letters[Int(index)]
                            letters[Int(index)] = Letter()
                            blankCellIndex = Int(index)
                        }

                        pointerIndex = Float(index)
                        dragOffset = CGPoint(x: drag.location.x - drag.startLocation.x,
                                             y: drag.location.y - drag.startLocation.y)
                    }
                    .onEnded { _ in
                        guard letters.count > 0, blankCellIndex != nil else {
                            draggedLetter = nil
                            pointerIndex = nil
                            startCellIndex = nil
                            blankCellIndex = nil
                            startPointerPosition = CGPoint.zero
                            dragOffset = CGPoint.zero
                            return
                        }

                        letters[blankCellIndex!] = draggedLetter!
                        draggedLetter = nil
                        pointerIndex = nil
                        startCellIndex = nil
                        blankCellIndex = nil
                        startPointerPosition = CGPoint.zero
                        dragOffset = CGPoint.zero

                        self.onRearrangeLetters(letters)
                    }
                )
            }
        }
    }
}

struct BigLetter: View {
    private let ch: String
    private let pt: Int
    let size: CGFloat
    let tileColor: Color

    init(letter: Letter, size: CGFloat = 44, tileColor: Color = .mint) {
        self.ch = String(letter.text)
        self.pt = letter.point
        self.size = size
        self.tileColor = tileColor
    }

    var body: some View {
        ZStack{
            Text(self.ch)
                .font(Font.system(size: 0.8 * self.size, weight: .bold))

            if self.pt > 0 {
                VStack {
                    HStack {
                        Spacer()
                        Text("\(self.pt)")
                            .font(.system(size: 0.18 * self.size))
                            .padding(4)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: self.size, height: self.size)
        .background(self.pt == 0 ? .clear : tileColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
        )
    }
}
