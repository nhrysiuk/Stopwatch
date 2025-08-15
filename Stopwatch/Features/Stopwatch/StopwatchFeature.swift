import Foundation
import ComposableArchitecture

@Reducer
struct StopwatchFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var timerValue: Int = 0
        var isTimerRunning: Bool = false
        var startDate: Date?
        var accumulatedTime: TimeInterval = 0
        
        var timerString: String {
            let hours = timerValue / 360_000
            let minutes = (timerValue / 6000) % 60
            let seconds = (timerValue / 100) % 60
            let hundredths = timerValue % 100
            
            if hours > 0 {
                return String(format: "%02d:%02d:%02d,%02d", hours, minutes, seconds, hundredths)
            } else {
                return String(format: "%02d:%02d,%02d", minutes, seconds, hundredths)
            }
        }
    }
    
    enum Action {
        case stopStartButtonTapped
        case lapResetButtonTapped
        case timerTicked
    }
    
    enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .stopStartButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    if state.startDate == nil {
                        state.startDate = Date()
                    }
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .milliseconds(10))
                            await send(.timerTicked)
                        }
                    }.cancellable(id: CancelID.timer)
                } else {
                    if let start = state.startDate {
                        let elapsed = Date().timeIntervalSince(start)
                        state.accumulatedTime += elapsed
                    }
                    state.startDate = nil
                    return .cancel(id: CancelID.timer)
                }
                
            case .lapResetButtonTapped:
                if state.isTimerRunning {
                    //TODO: lap logic
                    return .none
                } else {
                    state.isTimerRunning = false
                    state.timerValue = 0
                    state.startDate = nil
                    state.accumulatedTime = 0
                    return .cancel(id: CancelID.timer)
                }
                
            case .timerTicked:
                if state.isTimerRunning, let start = state.startDate {
                    let elapsed = Date().timeIntervalSince(start)
                    state.timerValue = Int((state.accumulatedTime + elapsed) * 100)
                }
                return .none
            }
        }
    }
}
