//
//  ContentView.swift
//
//  Example ContentView for testing the CCXT Swift wrapper
//

import SwiftUI
import CCXT

struct ContentView: View {
    @State private var marketsText: String = "Loading..."
    private var configJson = [
        "apiKey": "",
        "secret": "",
        "password": ""
    ]

    private var orderId = "1"
    private var cancelOrderId = "1"
    private var spotSymbol: String = "XRP/USDT"
    private var futuresSymbol: String = "XRP/USDT:USDT"
    private var exchange: Exchange
    private var xrpPrice = 2.0591

    init () {
        self.exchange = Binance(config: [
            "enableRateLimit": true,
            "rateLimiterAlgorithm": "rollingWindow",
            "maxLimiterRequests": 5000
        ])!
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    Button("testRateLimiter"){
                        Task {
                            try await testRateLimiter()
                        }
                    }
                }.frame(maxHeight: geometry.size.height)
                    .padding()
            }
        }
        .padding()
    }
    
    func testRateLimiter() async throws {
        print("testRateLimiter")
        _ = try await self.exchange.loadMarkets()

        for times in [1, 10, 100, 1000] {
            let startTime = Date().timeIntervalSince1970 * 1000

            await withTaskGroup(of: Void.self) { group in
                for (i, _) in (0..<times).enumerated() {
                    group.addTask {
                        do {
                            let ticker = try await self.exchange.fetchTicker(symbol: "BTC/USDT")
//                            let timestamp = ticker["timestamp"] as? Int
//                            print(String(timestamp ?? 0))
                        } catch {
                            print("fetchTicker failed at iteration \(i): \(error)")
                        }
                    }
                }
                await group.waitForAll()
            }

            let endTime = Date().timeIntervalSince1970 * 1000
            let duration = endTime - startTime
            print("Parallel: \(times) requests in \(duration)ms")
        }
    }

}

#Preview {
    ContentView()
}
