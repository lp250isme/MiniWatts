import Foundation

nonisolated enum Formatting {
    static func temperature(_ celsius: Double) -> String {
        String(format: "%.1f °C", celsius)
    }

    static func watts(_ value: Double) -> String {
        String(format: abs(value) < 10 ? "%.2f" : "%.1f", value)
    }

    static func volts(_ value: Double) -> String {
        String(format: "%.2f V", value)
    }

    static func amps(_ value: Double) -> String {
        String(format: "%.2f A", value)
    }

    static func wattHours(_ value: Double) -> String {
        String(format: value < 1 ? "%.3f Wh" : "%.2f Wh", value)
    }

    static func milliAmpHours(_ value: Double) -> String {
        String(format: "%.0f mAh", value)
    }

    static func percent(_ value: Double, decimals: Int = 0) -> String {
        String(format: "%.\(decimals)f %%", value)
    }

    /// Follows the locale: "1h 4m" in English, "1時4分" in 正體中文.
    /// Abbreviated stays short enough for a chart axis.
    static func duration(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "—" }
        let total = Int(seconds.rounded())
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        if total >= 3_600 {
            formatter.allowedUnits = [.hour, .minute]
        } else if total >= 60 {
            formatter.allowedUnits = [.minute, .second]
        } else {
            formatter.allowedUnits = [.second]
        }
        var calendar = Calendar.current
        calendar.locale = .current
        formatter.calendar = calendar
        return formatter.string(from: TimeInterval(total)) ?? "—"
    }

    static func minutesRemaining(_ minutes: Int) -> String {
        duration(TimeInterval(minutes) * 60)
    }

    static func timestamp(_ date: Date) -> String {
        date.formatted(.dateTime.month(.abbreviated).day().hour().minute())
    }

    static func clock(_ date: Date) -> String {
        date.formatted(.dateTime.hour().minute().second())
    }
}
