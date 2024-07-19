import SwiftUI
import Charts

struct BarChartViewWrapper: UIViewRepresentable {
    var entries: [BarChartDataEntry]
    var unit: String

    func makeUIView(context: Context) -> BarChartView {
        let barChartView = BarChartView()
        barChartView.animate(xAxisDuration: 0.5)
        return barChartView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries, label: "Activity Data")
        dataSet.colors = [.blue, .red, .green, .orange, .purple, .cyan]
        dataSet.valueColors = [.white]

        let data = BarChartData(dataSet: dataSet)
        uiView.data = data

        uiView.chartDescription.text = "Activity (\(unit))"
        uiView.xAxis.labelPosition = .bottom
        uiView.rightAxis.enabled = false
        uiView.animate(yAxisDuration: 1.5)
    }
}
