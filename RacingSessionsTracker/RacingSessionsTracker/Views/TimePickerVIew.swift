import SwiftUI

struct TimePickerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        HStack {
            Picker("Минуты", selection: $minutes) {
                ForEach(0..<60, id: \.self) { minute in
                    Text("\(minute) мин")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
            
            Picker("Секунды", selection: $seconds) {
                ForEach(0..<60, id: \.self) { second in
                    Text("\(second) сек")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
    }
}
