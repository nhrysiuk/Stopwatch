import SwiftUI
import ComposableArchitecture

struct StopwatchView: View {
    
    let store: StoreOf<StopwatchFeature>
    
    var body: some View {
        VStack {
            Text(String(store.timerString))
                .font(.system(size: 90, weight: .thin, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .monospacedDigit()
            
            HStack {
                Button {
                    store.send(.lapResetButtonTapped)
                } label: {
                    Text(store.isTimerRunning ? "Lap" : "Reset")
                        .frame(width: 90, height: 90)
                        .background(.gray.opacity(0.3))
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                }
                .disabled(!store.isTimerRunning && store.timerValue == 0)
                .opacity((!store.isTimerRunning && store.timerValue == 0) ? 0.5 : 1)
                
                Spacer()
                
                Button {
                    store.send(.stopStartButtonTapped)
                } label: {
                    Text(store.isTimerRunning ? "Stop" : "Start")
                        .frame(width: 90, height: 90)
                        .background(store.isTimerRunning ? .red.opacity(0.2) : .green.opacity(0.2))
                        .clipShape((Circle()))
                        .foregroundStyle(store.isTimerRunning ? .red : .green)
                        .contentShape(Circle())
                }
                
            }
        }
        .padding(16)
    }
}
