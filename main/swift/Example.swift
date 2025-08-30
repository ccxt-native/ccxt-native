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
        // "password": ""
    ]

    private var orderId = "1"
    private var cancelOrderId = "1"
    private var spotSymbol: String = "XRP/USDT"
    private var futuresSymbol: String = "XRP/USDT:USDT"
    private var exchange: Exchange
    private var xrpPrice = 2.0591

    init () {
        self.exchange = Binance(config: configJson)!
        self.setup()
    }
    
    func setup () {
        Task {
            try? self.exchange.setSandboxMode(enabled: true)
            try? await self.exchange.loadMarkets()
        }
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
                    // Button("fetchDepositWithdrawFees"){
                    //     Task {
                    //         await fetchDepositWithdrawFees()
                    //     }
                    // }
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
                    Button("unWatchOrderBook"){
                        Task {
                            await unWatchOrderBook()
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
                    Button("unWatchOrders"){
                        Task {
                            await unWatchOrders()
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
                    // Button("unWatchTicker"){
                    //     Task {
                    //         await unWatchTicker()
                    //     }
                    // }
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
                    Button("unWatchTrades"){
                        Task {
                            await unWatchTrades()
                        }
                    }
                    Button("watchTradesForSymbols"){
                        Task {
                            await watchTradesForSymbols()
                        }
                    }
                    Button("withdraw (WARNING: Actually withdraws 0.0001 LTC)"){
                        Task {
                            await withdraw()
                        }
                    }
                    Button("getAccountsById"){
                        Task {
                            getAccountsById()
                        }
                    }
                    Button("getAlias"){
                        Task {
                            getAlias()
                        }
                    }
                    Button("getApi"){
                        Task {
                            getApi()
                        }
                    }
                    Button("getBalance"){
                        Task {
                            getBalance()
                        }
                    }
                    Button("getBaseCurrencies"){
                        Task {
                            getBaseCurrencies()
                        }
                    }
                    Button("getBidsasks"){
                        Task {
                            getBidsasks()
                        }
                    }
                    Button("getClients"){
                        Task {
                            getClients()
                        }
                    }
                    Button("getCodes"){
                        Task {
                            getCodes()
                        }
                    }
                    Button("getCommonCurrencies"){
                        Task {
                            getCommonCurrencies()
                        }
                    }
                    Button("getCurrencies_by_id"){
                        Task {
                            getCurrencies_by_id()
                        }
                    }
                    Button("getCurrencies"){
                        Task {
                            getCurrencies()
                        }
                    }
                    Button("getExceptions"){
                        Task {
                            getExceptions()
                        }
                    }
                    Button("getFeatures"){
                        Task {
                            getFeatures()
                        }
                    }
                    Button("getFees"){
                        Task {
                            getFees()
                        }
                    }
                    Button("getFundingRates"){
                        Task {
                            getFundingRates()
                        }
                    }
                    Button("getHas"){
                        Task {
                            getHas()
                        }
                    }
                    Button("getHostname"){
                        Task {
                            getHostname()
                        }
                    }
                    Button("getHttpExceptions"){
                        Task {
                            getHttpExceptions()
                        }
                    }
                    Button("getHttpProxyAgentModule"){
                        Task {
                            getHttpProxyAgentModule()
                        }
                    }
                    Button("getHttpsProxyAgentModule"){
                        Task {
                            getHttpsProxyAgentModule()
                        }
                    }
                    Button("getId"){
                        Task {
                            getId()
                        }
                    }
                    Button("getIds"){
                        Task {
                            getIds()
                        }
                    }
                    Button("getIsSandboxModeEnabled"){
                        Task {
                            getIsSandboxModeEnabled()
                        }
                    }
                    Button("getLast_http_response"){
                        Task {
                            getLast_http_response()
                        }
                    }
                    Button("getLast_request_body"){
                        Task {
                            getLast_request_body()
                        }
                    }
                    Button("getLast_request_headers"){
                        Task {
                            getLast_request_headers()
                        }
                    }
                    Button("getLast_request_url"){
                        Task {
                            getLast_request_url()
                        }
                    }
                    Button("getLimits"){
                        Task {
                            getLimits()
                        }
                    }
                    Button("getLiquidations"){
                        Task {
                            getLiquidations()
                        }
                    }
                    Button("getLogin"){
                        Task {
                            getLogin()
                        }
                    }
                    Button("getMarkets_by_id"){
                        Task {
                            getMarkets_by_id()
                        }
                    }
                    Button("getMarkets"){
                        Task {
                            getMarkets()
                        }
                    }
                    Button("getMAX_VALUE"){
                        Task {
                            getMAX_VALUE()
                        }
                    }
                    Button("getMyLiquidations"){
                        Task {
                            getMyLiquidations()
                        }
                    }
                    Button("getMyTrades"){
                        Task {
                            getMyTrades()
                        }
                    }
                    Button("getName"){
                        Task {
                            getName()
                        }
                    }
                    Button("getNewUpdates"){
                        Task {
                            getNewUpdates()
                        }
                    }
                    Button("getOhlcvs"){
                        Task {
                            getOhlcvs()
                        }
                    }
                    Button("getOptions"){
                        Task {
                            getOptions()
                        }
                    }
                    Button("getOrderbooks"){
                        Task {
                            getOrderbooks()
                        }
                    }
                    Button("getOrders"){
                        Task {
                            getOrders()
                        }
                    }
                    Button("getPositions"){
                        Task {
                            getPositions()
                        }
                    }
                    Button("getPrecision"){
                        Task {
                            getPrecision()
                        }
                    }
                    Button("getProxyDictionaries"){
                        Task {
                            getProxyDictionaries()
                        }
                    }
                    Button("getQuoteCurrencies"){
                        Task {
                            getQuoteCurrencies()
                        }
                    }
                    Button("getRateLimit"){
                        Task {
                            getRateLimit()
                        }
                    }
                    Button("getReduceFees"){
                        Task {
                            getReduceFees()
                        }
                    }
                    Button("getRequiredCredentials"){
                        Task {
                            getRequiredCredentials()
                        }
                    }
                    Button("getReturnResponseHeaders"){
                        Task {
                            getReturnResponseHeaders()
                        }
                    }
                    Button("getSocksProxyAgentModule"){
                        Task {
                            getSocksProxyAgentModule()
                        }
                    }
                    Button("getSocksProxyAgentModuleChecked"){
                        Task {
                            getSocksProxyAgentModuleChecked()
                        }
                    }
                    Button("getSubstituteCommonCurrencyCodes"){
                        Task {
                            getSubstituteCommonCurrencyCodes()
                        }
                    }
                    Button("getSymbols"){
                        Task {
                            getSymbols()
                        }
                    }
                    Button("getThrottler"){
                        Task {
                            getThrottler()
                        }
                    }
                    Button("getTickers"){
                        Task {
                            getTickers()
                        }
                    }
                    Button("getTimeframes"){
                        Task {
                            getTimeframes()
                        }
                    }
                    Button("getToken"){
                        Task {
                            getToken()
                        }
                    }
                    Button("getTokenBucket"){
                        Task {
                            getTokenBucket()
                        }
                    }
                    Button("getTrades"){
                        Task {
                            getTrades()
                        }
                    }
                    Button("getTransactions"){
                        Task {
                            getTransactions()
                        }
                    }
                    Button("getTriggerOrders"){
                        Task {
                            getTriggerOrders()
                        }
                    }
                    Button("getUrls"){
                        Task {
                            getUrls()
                        }
                    }
                    Button("getUserAgent"){
                        Task {
                            getUserAgent()
                        }
                    }
                    Button("getUserAgents"){
                        Task {
                            getUserAgents()
                        }
                    }
                    Button("getVersion"){
                        Task {
                            getVersion()
                        }
                    }
                    Button("setApiKey"){
                        Task {
                            setApiKey()
                        }
                    }
                    Button("setSecret"){
                        Task {
                            setSecret()
                        }
                    }
                    Button("setTimeout"){
                        Task {
                            setTimeout()
                        }
                    }
                    Button("setTwofa"){
                        Task {
                            setTwofa()
                        }
                    }
                    Button("setUid"){
                        Task {
                            setUid()
                        }
                    }
                    Button("setVerbose"){
                        Task {
                            setVerbose()
                        }
                    }
                    Button("setWalletAddress"){
                        Task {
                            setWalletAddress()
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
                }.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
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
            let tickers = try await self.exchange.fetchTickers(symbols: [futuresSymbol, futuresSymbol])
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
                symbol: futuresSymbol,
            )
            print(request)
        } catch {
            print(error.localizedDescription)
        }
    }

    func createOrder() async {
        do {
            let order = try await self.exchange.createOrder(
                symbol: futuresSymbol,
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
             let response = try await self.exchange.addMargin(symbol: futuresSymbol, amount: 1)
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
             let response = try await self.exchange.borrowIsolatedMargin(symbol: futuresSymbol, code: "USDT", amount: 1)
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
             let response = try await self.exchange.closePosition(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createLimitOrder() async {
         do {
             let response = try await self.exchange.createLimitOrder(symbol: futuresSymbol, side: "buy", amount: 1, price: xrpPrice)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createMarketBuyOrderWithCost() async {
         do {
             let response = try await self.exchange.createMarketBuyOrderWithCost(symbol: futuresSymbol, cost: 2)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func createMarketOrder() async {
         do {
             let response = try await self.exchange.createMarketOrder(symbol: futuresSymbol, side: "buy", amount: 1)
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
             let response = try await self.exchange.fetchClosedOrders(symbol: futuresSymbol)
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
    // func fetchDepositWithdrawFees() async {
    //      do {
    //          let response = try await self.exchange.fetchDepositWithdrawFees(codes: ["XRP"])
    //          print(response)
    //      } catch {
    //          print(error.localizedDescription)
    //      }
    // }
    func fetchFundingHistory() async {
         do {
             let response = try await self.exchange.fetchFundingHistory(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingRate() async {
         do {
             let response = try await self.exchange.fetchFundingRate(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingRateHistory() async {
         do {
             let response = try await self.exchange.fetchFundingRateHistory(symbol: futuresSymbol, limit: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchFundingInterval() async {
         do {
             let response = try await self.exchange.fetchFundingInterval(symbol: futuresSymbol)
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
             let response = try await self.exchange.fetchIsolatedBorrowRate(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchL2OrderBook() async {
         do {
             let response = try await self.exchange.fetchL2OrderBook(symbol: futuresSymbol)
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
             let response = try await self.exchange.fetchLeverage(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchLongShortRatioHistory() async {
         do {
             let response = try await self.exchange.fetchLongShortRatioHistory(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMarginMode() async {
         do {
             let response = try await self.exchange.fetchMarginMode(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchMarketLeverageTiers() async {
         do {
             let response = try await self.exchange.fetchMarketLeverageTiers(symbol: futuresSymbol)
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
             let response = try await self.exchange.fetchMyTrades(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOHLCV() async {
         do {
             let response = try await self.exchange.fetchOHLCV(symbol: futuresSymbol, timeframe: "1h", since: 1748736000000, limit: 1)
             let markResponse = try await self.exchange.fetchOHLCV(symbol: futuresSymbol, timeframe: "1h", since: 1748736000000, limit: 1, params: ["price": "mark"])
             print(response)
             print(markResponse)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOpenInterest() async {
         do {
             let response = try await self.exchange.fetchOpenInterest(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchOpenOrders() async {
         do {
             let response = try await self.exchange.fetchOpenOrders(symbol: futuresSymbol)
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
             let response = try await self.exchange.fetchOrderBook(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPosition() async {
         do {
             let response = try await self.exchange.fetchPosition(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositionHistory() async {
         do {
             let response = try await self.exchange.fetchPositionHistory(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositionsHistory() async {
         do {
             let response = try await self.exchange.fetchPositionsHistory(symbols: [futuresSymbol])
             print(response)
             _ = try await self.exchange.fetchPositionsHistory()
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchPositions() async {
         do {
             let response = try await self.exchange.fetchPositions(symbols: [futuresSymbol])
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTicker() async {
         do {
             let response = try await self.exchange.fetchTicker(symbol: futuresSymbol)
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
             let response = try await self.exchange.fetchTrades(symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func fetchTradingFee() async {
         do {
             let response = try await self.exchange.fetchTradingFee(symbol: futuresSymbol)
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
             let response = try await self.exchange.reduceMargin(symbol: futuresSymbol, amount: 1)
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
             let response = try await self.exchange.repayIsolatedMargin(symbol: futuresSymbol, code: "USDT", amount: 1)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func setMarginMode() async {
         do {
             let response = try await self.exchange.setMarginMode(marginMode: "isolated", symbol: futuresSymbol)
             print(response)
         } catch {
             print(error.localizedDescription)
         }
    }
    func setPositionMode() async {
         do {
             let response = try await self.exchange.setPositionMode(hedged: true, symbol: futuresSymbol)
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
        while true {
            do {
                let balance = try await self.exchange.watchBalance()
                print(balance)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchMyTrades() async {
        while true {
            do {
                let response = try await self.exchange.watchMyTrades()
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchOHLCV() async {
        while true {
            do {
                let response = try await self.exchange.watchOHLCV(symbol: futuresSymbol)
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchOrderBook() async {
        while true {
            do {
                let response = try await self.exchange.watchOrderBook(symbol: futuresSymbol)
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchBidsAsks() async {
        while true {
            do {
                let response = try await self.exchange.watchBidsAsks()
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchOrderBookForSymbols() async {
        while true {
            do {
                let response = try await self.exchange.watchOrderBookForSymbols(symbols: [futuresSymbol]) 
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchOrders() async {
        while true {
            do {
                let response = try await self.exchange.watchOrders()
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchPositions() async {
        while true {
            do {
                let response = try await self.exchange.watchPositions()
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchTicker() async {
        while true {
            do {
                let response = try await self.exchange.watchTicker(symbol: futuresSymbol)
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchTickers() async {
        while true {
            do {
                let response = try await self.exchange.watchTickers(symbols: [futuresSymbol]) 
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchTrades() async {
        while true {
            do {
                let response = try await self.exchange.watchTrades(symbol: futuresSymbol)
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func watchTradesForSymbols() async {
        while true {
            do {
                let response = try await self.exchange.watchTradesForSymbols(symbols: [futuresSymbol]) 
                print(response)
            } catch {
                // handle errors
                print("Error watching order book: \(error)")
            }
        }
    }
    func unWatchOrderBook() async {
        do {
            let response = try await self.exchange.unWatchOrderBook (symbol: futuresSymbol)
            print(response)
        } catch {
            print(error.localizedDescription)
        }
    }
    func unWatchOrders() async {
        do {
            let response = try await self.exchange.unWatchOrders (symbol: futuresSymbol)
            print(response)
        } catch {
            print(error.localizedDescription)
        }
    }
    // func unWatchTicker() async {
    //     do {
    //         let response = try await self.exchange.unWatchTicker (symbol: futuresSymbol)
    //         print(response)
    //     } catch {
    //         print(error.localizedDescription)
    //     }
    // }
    func unWatchTrades() async {
        do {
            let response = try await self.exchange.unWatchTrades (symbol: futuresSymbol)
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
    func getAccountsById() {
        print(self.exchange.accountsById)
    }
    func getAlias() {
        print(try self.exchange.alias)
    }
    func getApi() {
        print(try self.exchange.api)
    }
    func getBalance() {
        print(try self.exchange.balance)
    }
    func getBaseCurrencies() {
        print(try self.exchange.baseCurrencies)
    }
    func getBidsasks() {
        print(try self.exchange.bidsasks)
    }
    func getClients() {
        print(try self.exchange.clients)
    }
    func getCodes() {
        print(try self.exchange.codes)
    }
    func getCommonCurrencies() {
        print(try self.exchange.commonCurrencies)
    }
    func getCurrencies_by_id() {
        print(try self.exchange.currencies_by_id)
    }
    func getCurrencies() {
        print(try self.exchange.currencies)
    }
    func getExceptions() {
        print(try self.exchange.exceptions)
    }
    func getFeatures() {
        print(try self.exchange.features)
    }
    func getFees() {
        print(try self.exchange.fees)
    }
    func getFundingRates() {
        print(try self.exchange.fundingRates)
    }
    func getHas() {
        print(try self.exchange.has)
    }
    func getHostname() {
        print(try self.exchange.hostname)
    }
    func getHttpExceptions() {
        print(try self.exchange.httpExceptions)
    }
    func getHttpProxyAgentModule() {
        print(try self.exchange.httpProxyAgentModule)
    }
    func getHttpsProxyAgentModule() {
        print(try self.exchange.httpsProxyAgentModule)
    }
    func getId() {
        print(try self.exchange.id)
    }
    func getIds() {
        print(try self.exchange.ids)
    }
    func getIsSandboxModeEnabled() {
        print(try self.exchange.isSandboxModeEnabled)
    }
    func getLast_http_response() {
        print(try self.exchange.last_http_response)
    }
    func getLast_request_body() {
        print(try self.exchange.last_request_body)
    }
    func getLast_request_headers() {
        print(try self.exchange.last_request_headers)
    }
    func getLast_request_url() {
        print(try self.exchange.last_request_url)
    }
    func getLimits() {
        print(try self.exchange.limits)
    }
    func getLiquidations() {
        print(try self.exchange.liquidations)
    }
    func getLogin() {
        print(try self.exchange.login)
    }
    func getMarkets_by_id() {
        print(try self.exchange.markets_by_id)
    }
    func getMarkets() {
        print(try self.exchange.markets)
    }
    func getMAX_VALUE() {
        print(try self.exchange.MAX_VALUE)
    }
    func getMyLiquidations() {
        print(try self.exchange.myLiquidations)
    }
    func getMyTrades() {
        print(try self.exchange.myTrades)
    }
    func getName() {
        print(try self.exchange.name)
    }
    func getNewUpdates() {
        print(try self.exchange.newUpdates)
    }
    func getOhlcvs() {
        print(try self.exchange.ohlcvs)
    }
    func getOptions() {
        print(try self.exchange.options)
    }
    func getOrderbooks() {
        print(try self.exchange.orderbooks)
    }
    func getOrders() {
        print(try self.exchange.orders)
    }
    func getPositions() {
        print(try self.exchange.positions)
    }
    func getPrecision() {
        print(try self.exchange.precision)
    }
    func getProxyDictionaries() {
        print(try self.exchange.proxyDictionaries)
    }
    func getQuoteCurrencies() {
        print(try self.exchange.quoteCurrencies)
    }
    func getRateLimit() {
        print(try self.exchange.rateLimit)
    }
    func getReduceFees() {
        print(try self.exchange.reduceFees)
    }
    func getRequiredCredentials() {
        print(try self.exchange.requiredCredentials)
    }
    func getReturnResponseHeaders() {
        print(try self.exchange.returnResponseHeaders)
    }
    func getSocksProxyAgentModule() {
        print(try self.exchange.socksProxyAgentModule)
    }
    func getSocksProxyAgentModuleChecked() {
        print(try self.exchange.socksProxyAgentModuleChecked)
    }
    func getSubstituteCommonCurrencyCodes() {
        print(try self.exchange.substituteCommonCurrencyCodes)
    }
    func getSymbols() {
        print(try self.exchange.symbols)
    }
    func getThrottler() {
        print(try self.exchange.throttler)
    }
    func getTickers() {
        print(try self.exchange.tickers)
    }
    func getTimeframes() {
        print(try self.exchange.timeframes)
    }
    func getToken() {
        print(try self.exchange.token)
    }
    func getTokenBucket() {
        print(try self.exchange.tokenBucket)
    }
    func getTrades() {
        print(try self.exchange.trades)
    }
    func getTransactions() {
        print(try self.exchange.transactions)
    }
    func getTriggerOrders() {
        print(try self.exchange.triggerOrders)
    }
    func getUrls() {
        print(try self.exchange.urls)
    }
    func getUserAgent() {
        print(try self.exchange.userAgent)
    }
    func getUserAgents() {
        print(try self.exchange.userAgents)
    }
    func getVersion() {
        print(try self.exchange.version)
    }
    func setApiKey() {
        do {
            try self.exchange.setApiKey(newValue: "abc")
        } catch {
            print(error.localizedDescription)
        }
    }
    func setSecret() {
        do {
            try self.exchange.setSecret(newValue: "abc")
        } catch {
            print(error.localizedDescription)
        }
    }
    func setTimeout() {
        do {
            try self.exchange.setTimeout(newValue: 1234567890)
        } catch {
            print(error.localizedDescription)
        }
    }
    func setTwofa() {
        do {
            try self.exchange.setTwofa(newValue: "abc")
        } catch {
            print(error.localizedDescription)
        }
    }
    func setUid() {
        do {
            try self.exchange.setUid(newValue: "1234567890")
        } catch {
            print(error.localizedDescription)
        }
    }
    func setVerbose() {
        do {
            try self.exchange.setVerbose(newValue: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    func setWalletAddress() {
        do {
            try self.exchange.setWalletAddress(newValue: "0x1234567890123456789012345678901234567890")
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
//             let response = try await self.exchange.fetchMarkPrice(futuresSymbol)
//             print(response)
//         } catch {
//             print(error.localizedDescription)
//         }
//    }

}

#Preview {
    ContentView()
}
