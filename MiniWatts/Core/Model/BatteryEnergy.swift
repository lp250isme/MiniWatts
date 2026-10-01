import Foundation

/// Published pack energy for the %-rate discharge estimate.
///
/// The sandbox does not hand over design capacity, so Settings starts from this
/// table. Figures are the published cell size in mAh times this app's nominal
/// 3.87 V, rounded to 0.1 Wh — the same conversion `PowerMonitor` uses when
/// IOKit does report a capacity. eSIM-only and physical-SIM versions of one
/// model share an identifier and can differ by up to about 3 Wh; the stepper
/// is how that is corrected. An identifier that is not listed falls back to
/// 15 Wh.
nonisolated enum BatteryEnergy {
    static func wattHours(forModelIdentifier identifier: String) -> Double? {
        let machine = identifier.split(separator: " ").first.map(String.init) ?? identifier
        return ratings[machine]
    }

    // Identifiers follow the public device list (iPhone11,8 through iPhone19,7).
    // iPhone 18 Pro Max is iPhone19,3 in the US and iPhone19,7 elsewhere; the
    // cells differ, so those two keys are not the same number.
    private static let ratings: [String: Double] = [
        "iPhone11,2": 10.3, // XS
        "iPhone11,4": 12.3, // XS Max
        "iPhone11,6": 12.3, // XS Max
        "iPhone11,8": 11.4, // XR
        "iPhone12,1": 12.0, // 11
        "iPhone12,3": 11.8, // 11 Pro
        "iPhone12,5": 15.4, // 11 Pro Max
        "iPhone12,8": 7.0,  // SE (2nd)
        "iPhone13,1": 8.6,  // 12 mini
        "iPhone13,2": 10.9, // 12
        "iPhone13,3": 10.9, // 12 Pro
        "iPhone13,4": 14.3, // 12 Pro Max
        "iPhone14,2": 12.0, // 13 Pro
        "iPhone14,3": 16.8, // 13 Pro Max
        "iPhone14,4": 9.3,  // 13 mini
        "iPhone14,5": 12.5, // 13
        "iPhone14,6": 7.8,  // SE (3rd)
        "iPhone14,7": 12.7, // 14
        "iPhone14,8": 16.7, // 14 Plus
        "iPhone15,2": 12.4, // 14 Pro
        "iPhone15,3": 16.7, // 14 Pro Max
        "iPhone15,4": 13.0, // 15
        "iPhone15,5": 17.0, // 15 Plus
        "iPhone16,1": 12.7, // 15 Pro
        "iPhone16,2": 17.1, // 15 Pro Max
        "iPhone17,1": 13.9, // 16 Pro
        "iPhone17,2": 18.1, // 16 Pro Max
        "iPhone17,3": 13.8, // 16
        "iPhone17,4": 18.1, // 16 Plus
        "iPhone17,5": 15.3, // 16e
        "iPhone18,1": 16.5, // 17 Pro, eSIM cell; physical SIM is about 15.4
        "iPhone18,2": 19.7, // 17 Pro Max, eSIM cell; physical SIM is about 18.7
        "iPhone18,3": 14.3, // 17
        "iPhone18,4": 12.2, // Air
        "iPhone18,5": 15.5, // 17e
        "iPhone19,2": 16.6, // 18 Pro, eSIM cell; physical SIM is about 15.7
        "iPhone19,3": 21.5, // 18 Pro Max, US eSIM
        "iPhone19,7": 20.9, // 18 Pro Max, other regions
    ]
}
