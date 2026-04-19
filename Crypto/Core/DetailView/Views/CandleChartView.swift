//
//  CandleChartView.swift
//  Crypto
//
//  Created by Nafea Elkassas on 15/04/2026.
//

import SwiftUI
import Charts

struct CandleChartView: View {
    
    let candles: [CandleModel]
    @State private var animate = false
    private var minY: Double {
        candles.map { $0.low }.min() ?? 0}
    private var maxY: Double {
        candles.map { $0.high }.max() ?? 0}
    
    var body: some View {
        VStack {
            chart
                .frame(height: 250)
                .padding(.horizontal, 8)
        }
        .onAppear {
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animate = true
            }
        }
    }
    
    private var chart: some View {
            Chart {
                let filteredCandles = candles.enumerated().compactMap { index, candle in
                    index % 2 == 0 ? candle : nil
                }
                
                ForEach(filteredCandles) { candle in
                    
                    RuleMark(
                        x: .value("Date", candle.date),
                        yStart: .value("Low", candle.low),
                        yEnd: .value("High", candle.high)
                    )
                    .foregroundStyle(Color.gray.opacity(0.6))
                    
                    RectangleMark(
                        x: .value("Date", candle.date),
                        yStart: .value("Open", candle.open),
                        yEnd: .value("Close", candle.close)
                    )
                    .foregroundStyle(
                        candle.isBullish ? Color.green : Color.red
                    )
                }
            }
            .chartYScale(domain: minY...maxY)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
}

//#Preview {
//    CandleChartView()
//}
