import Combine

struct ReverseCode {
    func encode(_ text: String) -> String { String(text.reversed()) }
    func decode(_ text: String) -> String { String(text.reversed()) }
}

@MainActor final class ReverseViewModel: ObservableObject {
    @Published var inputText = ""
    @Published private(set) var outputText = ""
    private let code = ReverseCode()
    private var cancellables = Set<AnyCancellable>()

    init() {
        $inputText
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.outputText = self?.code.encode(text) ?? ""
            }
            .store(in: &cancellables)
    }
}
