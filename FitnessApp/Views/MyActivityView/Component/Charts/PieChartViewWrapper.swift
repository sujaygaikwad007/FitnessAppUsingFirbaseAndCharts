import SwiftUI
import Charts

struct PieChartViewWrapper: UIViewRepresentable {
    var entries: [PieChartDataEntry]
    var unit: String

    func makeUIView(context: Context) -> PieChartView {
        let pieChartView = PieChartView()
        pieChartView.holeColor = UIColor.clear
        pieChartView.transparentCircleColor = UIColor.clear
        pieChartView.drawEntryLabelsEnabled = false
        return pieChartView
    }

    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries, label: "Activity Data")
        dataSet.colors = [.blue, .red, .green, .orange, .purple, .cyan,]
        dataSet.valueColors = [.black]

        let data = PieChartData(dataSet: dataSet)
        uiView.data = data
        uiView.chartDescription.text = "Weekly Activity (\(unit))"
        uiView.animate(yAxisDuration: 1.5)
    }
}
