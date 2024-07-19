import SwiftUI
import Charts

struct ActivityChartView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var healthManager: HealthManager
    var activity: ActivityModel
    @State private var isBarChart = true
    @State private var selectedDate = Date()
    @State private var dataPoints: [(String, Double)] = []
    @Binding var selectedActivity: ActivityModel?

    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    selectedActivity = nil
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.top,60)
            .padding(.leading,20)
            Text(activity.title)
                .font(.largeTitle)
                .padding()

            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newDate in
                    fetchDataForSelectedDate()
                }

            Picker("Chart Type", selection: $isBarChart) {
                Text("Bar Chart").tag(true)
                Text("Pie Chart").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onAppear {
                   UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.PrimaryColor)
                   let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
                               let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
                               
                               UISegmentedControl.appearance().setTitleTextAttributes(normalTextAttributes, for: .selected)
                               UISegmentedControl.appearance().setTitleTextAttributes(selectedTextAttributes, for: .normal)
                   }
            
            if !isFutureDate {
                if isBarChart {
                    BarChartViewWrapper(entries: getBarChartData(), unit: activity.unit)
                        .frame(height: 400)
                } else {
                    PieChartViewWrapper(entries: getPieChartData(), unit: activity.unit)
                        .frame(height: 400)
                }
            } else {
                Text("No data available for this date")
                    .padding()
            }

        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear(perform: fetchDataForSelectedDate)
    }

    private var isFutureDate: Bool {
        Calendar.current.compare(selectedDate, to: Date(), toGranularity: .day) == .orderedDescending
    }

    private func fetchDataForSelectedDate() {
        if isFutureDate {
            self.dataPoints = []
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)

        healthManager.fetchDataForDate(dateString) { fetchedData in
            guard let fetchedData = fetchedData else {
                self.dataPoints = []
                return
            }
            self.dataPoints = self.parseFetchedData(fetchedData, for: self.activity)
        }
    }

    private func getBarChartData() -> [BarChartDataEntry] {
        var entries: [BarChartDataEntry] = []
        for (index, dataPoint) in dataPoints.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: dataPoint.1))
        }
        return entries
    }

    private func getPieChartData() -> [PieChartDataEntry] {
        var entries: [PieChartDataEntry] = []
        for dataPoint in dataPoints {
            entries.append(PieChartDataEntry(value: dataPoint.1, label: dataPoint.0))
        }
        return entries
    }

    private func parseFetchedData(_ data: [String: Any], for activity: ActivityModel) -> [(String, Double)] {
        switch activity.title {
            
        case "Walk", "Calories", "Heart", "Water", "Training","Sleep":
            return data.map { ($0.key, ($0.value as? Double) ?? 0.0) }
        default:
            return []
        }
    }
}
    

   

