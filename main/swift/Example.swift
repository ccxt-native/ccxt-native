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
        self.exchange = Bitget(config: configJson)!
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    
                    Button("Fetch Markets") {
                        Task {
                            await fetchMarkets()
                        }
                    }
                    Button("Fetch Tickers") {
                        Task {
                            await fetchTickers()
                        }
                    }
                    Button("Fetch Balance") {
                        Task {
                            await fetchBalance()
                        }
                    }
                    Button("Create Order") {
                        Task {
                            await createOrder()
                        }
                    }
                    Button("Fetch Positions History") {
                        Task {
                            await fetchPositionsHistory()
                        }
                    }
                    Button("addMargin"){
                        Task {
                            await addMargin()
                        }
                    }
                    Button("borrowCrossMargin"){
                        Task {
                            await borrowCrossMargin()
                        }
                    }
                    Button("borrowIsolatedMargin"){
                        Task {
                            await borrowIsolatedMargin()
                        }
                    }
                    Button("borrowMargin"){
                        Task {
                            await borrowMargin()
                        }
                    }
                    Button("cancelAllOrders"){
                        Task {
                            await cancelAllOrders()
                        }
                    }
                    //                Button("cancelAllOrdersWs"){
                    //                    Task {
                    //                        await cancelAllOrdersWs()
                    //                    }
                    //                }
                    Button("cancelOrder"){
                        Task {
                            await cancelOrder()
                        }
                    }
                    //                Button("cancelOrderWs"){
                    //                    Task {
                    //                        await cancelOrderWs()
                    //                    }
                    //                }
                    Button("cancelOrders"){
                        Task {
                            await cancelOrders()
                        }
                    }
                    //                Button("cancelOrdersWs"){
                    //                    Task {
                    //                        await cancelOrdersWs()
                    //                    }
                    //                }
                    Button("closeAllPositions"){
                        Task {
                            await closeAllPositions()
                        }
                    }
                    Button("closePosition"){
                        Task {
                            await closePosition()
                        }
                    }
                    Button("createLimitOrder"){
                        Task {
                            await createLimitOrder()
                        }
                    }
                    Button("createMarketBuyOrderWithCost"){
                        Task {
                            await createMarketBuyOrderWithCost()
                        }
                    }
                    Button("createMarketOrder"){
                        Task {
                            await createMarketOrder()
                        }
                    }
                    //                Button("createMarketOrderWs"){
                    //                    Task {
                    //                        await createMarketOrderWs()
                    //                    }
                    //                }
                    Button("createOrder"){
                        Task {
                            await createOrder()
                        }
                    }
                    Button("createOrders"){
                        Task {
                            await createOrders()
                        }
                    }
                    Button("createOrderWithTakeProfitAndStopLoss"){
                        Task {
                            await createOrderWithTakeProfitAndStopLoss()
                        }
                    }
                    Button("createPostOnlyOrder"){
                        Task {
                            await createPostOnlyOrder()
                        }
                    }
                    Button("createStopLimitOrder"){
                        Task {
                            await createStopLimitOrder()
                        }
                    }
                    Button("createStopLossOrder"){
                        Task {
                            await createStopLossOrder()
                        }
                    }
                    Button("createStopMarketOrder"){
                        Task {
                            await createStopMarketOrder()
                        }
                    }
                    Button("createStopOrder"){
                        Task {
                            await createStopOrder()
                        }
                    }
                    Button("createTakeProfitOrder"){
                        Task {
                            await createTakeProfitOrder()
                        }
                    }
                    Button("createTrailingPercentOrder"){
                        Task {
                            await createTrailingPercentOrder()
                        }
                    }
                    Button("createTriggerOrder"){
                        Task {
                            await createTriggerOrder()
                        }
                    }
                    Button("editOrder"){
                        Task {
                            await editOrder()
                        }
                    }
                    Button("fetchBalance"){
                        Task {
                            await fetchBalance()
                        }
                    }
                    Button("fetchBorrowInterest"){
                        Task {
                            await fetchBorrowInterest()
                        }
                    }
                    Button("fetchCanceledAndClosedOrders"){
                        Task {
                            await fetchCanceledAndClosedOrders()
                        }
                    }
                    Button("fetchCanceledOrders"){
                        Task {
                            await fetchCanceledOrders()
                        }
                    }
                    Button("fetchClosedOrders"){
                        Task {
                            await fetchClosedOrders()
                        }
                    }
                    Button("fetchConvertCurrencies"){
                        Task {
                            await fetchConvertCurrencies()
                        }
                    }
                    Button("fetchConvertQuote"){
                        Task {
                            await fetchConvertQuote()
                        }
                    }
                    Button("fetchConvertTradeHistory"){
                        Task {
                            await fetchConvertTradeHistory()
                        }
                    }
                    Button("fetchCrossBorrowRate"){
                        Task {
                            await fetchCrossBorrowRate()
                        }
                    }
                    Button("fetchCurrencies"){
                        Task {
                            await fetchCurrencies()
                        }
                    }
                    Button("fetchCurrenciesWs"){
                        Task {
                            await fetchCurrenciesWs()
                        }
                    }
                    Button("fetchDepositAddress"){
                        Task {
                            await fetchDepositAddress()
                        }
                    }
                    Button("fetchDeposits"){
                        Task {
                            await fetchDeposits()
                        }
                    }
                    Button("fetchDepositWithdrawFee"){
                        Task {
                            await fetchDepositWithdrawFee()
                        }
                    }
                    Button("fetchDepositWithdrawFees"){
                        Task {
                            await fetchDepositWithdrawFees()
                        }
                    }
                    Button("fetchFundingHistory"){
                        Task {
                            await fetchFundingHistory()
                        }
                    }
                    Button("fetchFundingRate"){
                        Task {
                            await fetchFundingRate()
                        }
                    }
                    Button("fetchFundingRateHistory"){
                        Task {
                            await fetchFundingRateHistory()
                        }
                    }
                    Button("fetchFundingInterval"){
                        Task {
                            await fetchFundingInterval()
                        }
                    }
                    Button("fetchFundingRates"){
                        Task {
                            await fetchFundingRates()
                        }
                    }
                    Button("fetchIndexOHLCV"){
                        Task {
                            await fetchIndexOHLCV()
                        }
                    }
                    Button("fetchIsolatedBorrowRate"){
                        Task {
                            await fetchIsolatedBorrowRate()
                        }
                    }
                    Button("fetchL2OrderBook"){
                        Task {
                            await fetchL2OrderBook()
                        }
                    }
                    Button("fetchLedger"){
                        Task {
                            await fetchLedger()
                        }
                    }
                    Button("fetchLeverage"){
                        Task {
                            await fetchLeverage()
                        }
                    }
                    Button("fetchLongShortRatioHistory"){
                        Task {
                            await fetchLongShortRatioHistory()
                        }
                    }
                    Button("fetchMarginMode"){
                        Task {
                            await fetchMarginMode()
                        }
                    }
                    Button("fetchMarketLeverageTiers"){
                        Task {
                            await fetchMarketLeverageTiers()
                        }
                    }
                    Button("fetchMarkets"){
                        Task {
                            await fetchMarkets()
                        }
                    }
                    Button("fetchMarkOHLCV"){
                        Task {
                            await fetchMarkOHLCV()
                        }
                    }
                    Button("fetchMyLiquidations"){
                        Task {
                            await fetchMyLiquidations()
                        }
                    }
                    Button("fetchMyTrades"){
                        Task {
                            await fetchMyTrades()
                        }
                    }
                    Button("fetchOHLCV"){
                        Task {
                            await fetchOHLCV()
                        }
                    }
                    Button("fetchOpenInterest"){
                        Task {
                            await fetchOpenInterest()
                        }
                    }
                    Button("fetchOpenOrders"){
                        Task {
                            await fetchOpenOrders()
                        }
                    }
                    Button("fetchOrder"){
                        Task {
                            await fetchOrder()
                        }
                    }
                    Button("fetchOrderBook"){
                        Task {
                            await fetchOrderBook()
                        }
                    }
                    Button("fetchPosition"){
                        Task {
                            await fetchPosition()
                        }
                    }
                    Button("fetchPositionHistory"){
                        Task {
                            await fetchPositionHistory()
                        }
                    }
                    Button("fetchPositionsHistory"){
                        Task {
                            await fetchPositionsHistory()
                        }
                    }
                    Button("fetchPositions"){
                        Task {
                            await fetchPositions()
                        }
                    }
                    Button("fetchTicker"){
                        Task {
                            await fetchTicker()
                        }
                    }
                    Button("fetchTickers"){
                        Task {
                            await fetchTickers()
                        }
                    }
                    Button("fetchTime"){
                        Task {
                            await fetchTime()
                        }
                    }
                    Button("fetchTrades"){
                        Task {
                            await fetchTrades()
                        }
                    }
                    Button("fetchTradingFee"){
                        Task {
                            await fetchTradingFee()
                        }
                    }
                    Button("fetchTradingFees"){
                        Task {
                            await fetchTradingFees()
                        }
                    }
                    Button("fetchTransfers"){
                        Task {
                            await fetchTransfers()
                        }
                    }
                    Button("fetchWithdrawals"){
                        Task {
                            await fetchWithdrawals()
                        }
                    }
                    Button("reduceMargin"){
                        Task {
                            await reduceMargin()
                        }
                    }
                    Button("repayCrossMargin"){
                        Task {
                            await repayCrossMargin()
                        }
                    }
                    Button("repayIsolatedMargin"){
                        Task {
                            await repayIsolatedMargin()
                        }
                    }
                    Button("setLeverage"){
                        Task {
                            await setLeverage()
                        }
                    }
                    Button("setMarginMode"){
                        Task {
                            await setMarginMode()
                        }
                    }
                    Button("setPositionMode"){
                        Task {
                            await setPositionMode()
                        }
                    }
                    Button("transfer"){
                        Task {
                            await transfer()
                        }
                    }
                    Button("watchBalance"){
                        Task {
                            await watchBalance()
                        }
                    }
                    Button("watchMyTrades"){
                        Task {
                            await watchMyTrades()
                        }
                    }
                    Button("watchOHLCV"){
                        Task {
                            await watchOHLCV()
                        }
                    }
                    Button("watchOrderBook"){
                        Task {
                            await watchOrderBook()
                        }
                    }
                    Button("watchBidsAsks"){
                        Task {
                            await watchBidsAsks()
                        }
                    }
                    Button("watchOrderBookForSymbols"){
                        Task {
                            await watchOrderBookForSymbols()
                        }
                    }
                    Button("watchOrders"){
                        Task {
                            await watchOrders()
                        }
                    }
                    Button("watchPositions"){
                        Task {
                            await watchPositions()
                        }
                    }
                    Button("watchTicker"){
                        Task {
                            await watchTicker()
                        }
                    }
                    Button("watchTickers"){
                        Task {
                            await watchTickers()
                        }
                    }
                    Button("watchTrades"){
                        Task {
                            await watchTrades()
                        }
                    }
                    Button("watchTradesForSymbols"){
                        Task {
                            await watchTradesForSymbols()
                        }
                    }
                    Button("withdraw"){
                        Task {
                            await withdraw()
                        }
                    }
                    //                Button("createConvertTrade"){
                    //                    Task {
                    //                        await createConvertTrade()
                    //                    }
                    //                }
                    //                Button("fetchMarkPrice"){
                    //                    Task {
                    //                        await fetchMarkPrice()
                    //                    }
                    //                }
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

    func fetchMarkets() async {
        // Call fetchMarkets() → returns JSON string
        do {
            let markets = try await self.exchange.fetchMarkets();
            print(markets[0])
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchTickers() async {
        do {
            let tickers = try await self.exchange.fetchTickers(symbols: ["XRP/USDT", "BTC/USDT"])
            print(tickers)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchBalance() async {
        do {
            let balance = try await self.exchange.fetchBalance()
            print(balance)
        } catch {
            print(error.localizedDescription)
        }
    }

    func setLeverage() async {
        do {
            let request = try await self.exchange.setLeverage(
                leverage: 10,
                symbol: "XRP/USDT:USDT",
            )
            print(request)
        } catch {
            print(error.localizedDescription)
        }
    }

    func createOrder() async {
        do {
            let order = try await self.exchange.createOrder(
                symbol: "XRP/USDT:USDT",
                type: "limit",
                side: "buy",
                amount: 5,
                price: xrpPrice * 0.9,
                params: ["postOnly": true, "tradeSide": "open"]
            )
            print(order)
        } catch {
            print(error.localizedDescription)
        }
    }

    func addMargin() async {
         do {
             let response = try await self.exchange.addMargin(symbol: "XRP/USDT:USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func borrowCrossMargin() async {
         do {
             let response = try await self.exchange.borrowCrossMargin(code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func borrowIsolatedMargin() async {
         do {
             let response = try await self.exchange.borrowIsolatedMargin(symbol: "XRP/USDT", code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func borrowMargin() async {
         do {
             let response = try await self.exchange.borrowMargin(code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func cancelAllOrders() async {
         do {
             let response = try await self.exchange.cancelAllOrders()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func cancelAllOrdersWs() async {
        // do {
        //     let response = try await self.exchange.cancelAllOrdersWs()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func cancelOrder() async {
         do {
             let response = try await self.exchange.cancelOrder(id: cancelOrderId)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func cancelOrderWs() async {
        // do {
        //     let response = try await self.exchange.cancelOrderWs()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func cancelOrders() async {
        // TODO
//         do {
//             let response = await try await self.exchange.cancelOrders()
//             print(response)
//         } catch {
//             print(error.localizedDescription)
//         }
    }
    func cancelOrdersWs() async {
        // do {
        //     let response = try await self.exchange.cancelOrdersWs()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func closeAllPositions() async {
         do {
             let response = try await self.exchange.closeAllPositions()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func closePosition() async {
         do {
             let response = try await self.exchange.closePosition(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createLimitOrder() async {
         do {
             let response = try await self.exchange.createLimitOrder(symbol: "XRP/USDT:USDT", side: "buy", amount: 1, price: xrpPrice)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createMarketBuyOrderWithCost() async {
         do {
             let response = try await self.exchange.createMarketBuyOrderWithCost(symbol: "XRP/USDT:USDT", cost: 2)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createMarketOrder() async {
         do {
             let response = try await self.exchange.createMarketOrder(symbol: "XRP/USDT:USDT", side: "buy", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createMarketOrderWs() async {
        // do {
        //     let response = try await self.exchange.createMarketOrderWs()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func createOrders() async {
        // do {
        //     let response = try await self.exchange.createOrders()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func createOrderWithTakeProfitAndStopLoss() async {
         do {
             let response = try await self.exchange.createOrderWithTakeProfitAndStopLoss(symbol: futuresSymbol, type: "limit", side: "buy", amount: 1, price: xrpPrice, takeProfit: xrpPrice * 1.1, stopLoss: xrpPrice * 0.9)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createPostOnlyOrder() async {
         do {
             let response = try await self.exchange.createPostOnlyOrder(symbol: self.futuresSymbol, type: "limit", side: "buy", amount: 3, price: xrpPrice * 0.9)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createStopLimitOrder() async {
         do {
             let response = try await self.exchange.createStopLimitOrder(symbol: futuresSymbol, side: "buy", amount: 5, price: xrpPrice * 0.85, triggerPrice: xrpPrice * 0.85, params: ["tradeSide": "open"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createStopLossOrder() async {
         do {
             let response = try await self.exchange.createStopLossOrder(symbol: futuresSymbol, type: "limit", side: "buy", amount: 3)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createStopMarketOrder() async {
         do {
             let response = try await self.exchange.createStopMarketOrder(symbol: futuresSymbol, side: "buy", amount: 5, triggerPrice: xrpPrice * 0.85, params: ["tradeSide": "open"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createStopOrder() async {
         do {
             let response = try await self.exchange.createStopOrder(symbol: futuresSymbol, type: "String", side: "buy", amount: 5, price: xrpPrice * 0.85, triggerPrice: xrpPrice * 0.85, params: ["tradeSide": "open"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createTakeProfitOrder() async {
         do {
             let response = try await self.exchange.createTakeProfitOrder(symbol: futuresSymbol, type: "buy", side: "buy", amount: 5)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createTrailingPercentOrder() async {
         do {
             let response = try await self.exchange.createTrailingPercentOrder(symbol: futuresSymbol, type: "buy", side: "buy", amount: 5)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createTriggerOrder() async {
         do {
             let response = try await self.exchange.createTriggerOrder(symbol: futuresSymbol, type: "limit", side: "buy", amount: 5, price: xrpPrice * 0.85, triggerPrice: 0.85, params: ["tradeSide": "open"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func editOrder() async {
         do {
             let response = try await self.exchange.editOrder(id: orderId, symbol: futuresSymbol, type: "limit", side: "buy", amount: 2, price: xrpPrice - 0.1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchBorrowInterest() async {
         do {
             let response = try await self.exchange.fetchBorrowInterest(code: "XRP")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchCanceledAndClosedOrders() async {
        // do {
        //     let response = try await self.exchange.fetchCanceledAndClosedOrders()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func fetchCanceledOrders() async {
//         do {
//             let response = try await self.exchange.fetchCanceledOrders()
//             print(response)
//         } catch {
//             print(error.localizedDescription)
//         }
    }
    func fetchClosedOrders() async {
         do {
             let response = try await self.exchange.fetchClosedOrders(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchConvertCurrencies() async {
         do {
             let response = try await self.exchange.fetchConvertCurrencies()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchConvertQuote() async {
         do {
             let response = try await self.exchange.fetchConvertQuote(fromCode: "USDC", toCode: "USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchConvertTradeHistory() async {
         do {
             let response = try await self.exchange.fetchConvertTradeHistory(code: "XRP")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchCrossBorrowRate() async {
         do {
             let response = try await self.exchange.fetchCrossBorrowRate(code: "XRP")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchCurrencies() async {
         do {
             let response = try await self.exchange.fetchCurrencies()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchCurrenciesWs() async {
        // do {
        //     let response = try await self.exchange.fetchCurrenciesWs()
        //     print(response)
        // } catch {
        //     print(error.localizedDescription)
        // }
    }
    func fetchDepositAddress() async {
         do {
             let response = try await self.exchange.fetchDepositAddress(code: "USDT", params: ["network": "BSC"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchDeposits() async {
         do {
             let response = try await self.exchange.fetchDeposits()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchDepositWithdrawFee() async {
         do {
             let response = try await self.exchange.fetchDepositWithdrawFee(code: "XRP")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchDepositWithdrawFees() async {
         do {
             let response = try await self.exchange.fetchDepositWithdrawFees(codes: ["XRP"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingHistory() async {
         do {
             let response = try await self.exchange.fetchFundingHistory(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingRate() async {
         do {
             let response = try await self.exchange.fetchFundingRate(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingRateHistory() async {
         do {
             let response = try await self.exchange.fetchFundingRateHistory(symbol: "XRP/USDT:USDT", limit: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingInterval() async {
         do {
             let response = try await self.exchange.fetchFundingInterval(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingRates() async {
         do {
             let response = try await self.exchange.fetchFundingRates()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchIndexOHLCV() async {
         do {
             let response = try await self.exchange.fetchIndexOHLCV(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchIsolatedBorrowRate() async {
         do {
             let response = try await self.exchange.fetchIsolatedBorrowRate(symbol: "XRP/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchL2OrderBook() async {
         do {
             let response = try await self.exchange.fetchL2OrderBook(symbol: "XRP/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchLedger() async {
         do {
             let response = try await self.exchange.fetchLedger(code: "USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchLeverage() async {
         do {
             let response = try await self.exchange.fetchLeverage(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchLongShortRatioHistory() async {
         do {
             let response = try await self.exchange.fetchLongShortRatioHistory(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMarginMode() async {
         do {
             let response = try await self.exchange.fetchMarginMode(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMarketLeverageTiers() async {
         do {
             let response = try await self.exchange.fetchMarketLeverageTiers(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMarkOHLCV() async {
         do {
             let response = try await self.exchange.fetchMarkOHLCV(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMyLiquidations() async {
         do {
             let response = try await self.exchange.fetchMyLiquidations()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMyTrades() async {
         do {
             let response = try await self.exchange.fetchMyTrades(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOHLCV() async {
         do {
             let response = try await self.exchange.fetchOHLCV(symbol: "XRP/USDT", timeframe: "1h", since: 1748736000000, limit: 1)
             let markResponse = try await self.exchange.fetchOHLCV(symbol: "XRP/USDT", timeframe: "1h", since: 1748736000000, limit: 1, params: ["price": "mark"])
             print(response)
             print(markResponse)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOpenInterest() async {
         do {
             let response = try await self.exchange.fetchOpenInterest(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOpenOrders() async {
         do {
             let response = try await self.exchange.fetchOpenOrders(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOrder() async {
         do {
             let response = try await self.exchange.fetchOrder(id: orderId)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOrderBook() async {
         do {
             let response = try await self.exchange.fetchOrderBook(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPosition() async {
         do {
             let response = try await self.exchange.fetchPosition(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositionHistory() async {
         do {
             let response = try await self.exchange.fetchPositionHistory(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositionsHistory() async {
         do {
             let response = try await self.exchange.fetchPositionsHistory(symbols: ["XRP/USDT:USDT"])
             print(response)
             _ = try await self.exchange.fetchPositionsHistory()
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositions() async {
         do {
             let response = try await self.exchange.fetchPositions(symbols: ["XRP/USDT:USDT"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTicker() async {
         do {
             let response = try await self.exchange.fetchTicker(symbol: "XRP/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTime() async {
         do {
             let response = try await self.exchange.fetchTime()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTrades() async {
         do {
             let response = try await self.exchange.fetchTrades(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTradingFee() async {
         do {
             let response = try await self.exchange.fetchTradingFee(symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTradingFees() async {
         do {
             let response = try await self.exchange.fetchTradingFees()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTransfers() async {
         do {
             let response = try await self.exchange.fetchTransfers(code: "USDC")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchWithdrawals() async {
         do {
             let response = try await self.exchange.fetchWithdrawals()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func reduceMargin() async {
         do {
             let response = try await self.exchange.reduceMargin(symbol: "XRP/USDT:USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func repayCrossMargin() async {
         do {
             let response = try await self.exchange.repayCrossMargin(code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func repayIsolatedMargin() async {
         do {
             let response = try await self.exchange.repayIsolatedMargin(symbol: "XRP/USDT:USDT", code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func setMarginMode() async {
         do {
             let response = try await self.exchange.setMarginMode(marginMode: "isolated", symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func setPositionMode() async {
         do {
             let response = try await self.exchange.setPositionMode(hedged: true, symbol: "XRP/USDT:USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func transfer() async {
         do {
             let response = try await self.exchange.transfer(code: "USDC", amount: 1, fromAccount: "spot", toAccount: "swap")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchBalance() async {
         do {
             let response = try await self.exchange.watchBalance()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchMyTrades() async {
         do {
             let response = try await self.exchange.watchMyTrades()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchOHLCV() async {
         do {
             let response = try await self.exchange.watchOHLCV(symbol: "BTC/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchOrderBook() async {
         do {
             let response = try await self.exchange.watchOrderBook(symbol: "BTC/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchBidsAsks() async {
         do {
             let response = try await self.exchange.watchBidsAsks()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchOrderBookForSymbols() async {
         do {
             let response = try await self.exchange.watchOrderBookForSymbols(symbols: ["BTC/USDT"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchOrders() async {
         do {
             let response = try await self.exchange.watchOrders()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchPositions() async {
         do {
             let response = try await self.exchange.watchPositions()
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchTicker() async {
         do {
             let response = try await self.exchange.watchTicker(symbol: "BTC/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchTickers() async {
         do {
             let response = try await self.exchange.watchTickers(symbols: ["BTC/USDT"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchTrades() async {
         do {
             let response = try await self.exchange.watchTrades(symbol: "BTC/USDT")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func watchTradesForSymbols() async {
         do {
             let response = try await self.exchange.watchTradesForSymbols(symbols: ["BTC/USDT"])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func withdraw() async {
         do {
             let response = try await self.exchange.withdraw(code: "LTC", amount: 0.001, address: "Ld4qAQtq8NQr8kNcSZ5N52FKc7h6QK9vVH")
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
//    func createConvertTrade() async {
//         do {
//             let response = try await self.exchange.createConvertTrade()
//             print(response)
//         } catch {
//             print(error.localizedDescription)
//         }
//    }
//    func fetchMarkPrice() async {
//         do {
//             let response = try await self.exchange.fetchMarkPrice("BTC/USDT")
//             print(response)
//         } catch {
//             print(error.localizedDescription)
//         }
//    }
    
    
    func appendToFile(_ text: String, at path: String) {
        let url = URL(fileURLWithPath: path)
        let data = (text + "\n").data(using: .utf8)!

        if FileManager.default.fileExists(atPath: path) {
            if let handle = try? FileHandle(forWritingTo: url) {
                handle.seekToEndOfFile()
                handle.write(data)
                handle.closeFile()
            }
        } else {
            try? data.write(to: url)
        }
    }
    
    func testRateLimiter() async throws {
        print("testRateLimiter")
        let exchange = Binance(config: [
            "enableRateLimit": true,
            "rateLimiterAlgorithm": "rollingWindow",
            "maxLimiterRequests": 5000
        ])!
        _ = try await exchange.loadMarkets()

        for times in [1, 10, 100, 1000] {
            let startTime = Date().timeIntervalSince1970 * 1000

            await withTaskGroup(of: Void.self) { group in
                for (i, _) in (0..<times).enumerated() {
                    group.addTask {
                        do {
                            let ticker = try await exchange.fetchTicker(symbol: "BTC/USDT")
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
