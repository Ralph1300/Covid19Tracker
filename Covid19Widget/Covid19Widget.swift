//
//  Covid19Widget.swift
//  Covid19Widget
//
//  Created by Ralph Schnalzenberger on 16.10.20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {

    typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentInfections: 100, increasedBy: 10)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentInfections: 100, increasedBy: 10)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let userDefaults = UserDefaults(suiteName: "group.covid19")
        guard let data = userDefaults?.value(forKey: WidgetInfo.key) as? Data, let info = try? JSONDecoder().decode(WidgetInfo.self, from: data) else {
            completion(Timeline(entries: [], policy: .atEnd))
            return
        }
        let entry = Entry(date: currentDate,
                          currentInfections: info.infections,
                          increasedBy: info.increasedBy)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentInfections: Int
    let increasedBy: Int
}

struct Covid19WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text("Current Infections").font(.callout)
            Text("\(entry.currentInfections)")
                .font(.body)
            Text("+\(entry.increasedBy)").font(.body).foregroundColor(.red)
        })
    }
}

@main
struct Covid19Widget: Widget {
    let kind: String = "Covid19Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Covid19WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Covid 19 Tracker")
        .description("Current Covid19 Numbers")
        .supportedFamilies([.systemSmall])
    }
}

struct Covid19Widget_Previews: PreviewProvider {
    static var previews: some View {
        Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), currentInfections: 100, increasedBy: 10))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
