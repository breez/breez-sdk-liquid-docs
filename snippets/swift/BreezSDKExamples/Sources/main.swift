// The Swift Programming Language
// https://docs.swift.org/swift-book

print("Hello, tester!")
if let sdk = try gettingStarted() {
    if let fiatRates = getCurrentRates(sdk: sdk) {
        for rate in fiatRates {
            print("rate \(rate)\n")
            print("------------------------")
        }
    }
}
