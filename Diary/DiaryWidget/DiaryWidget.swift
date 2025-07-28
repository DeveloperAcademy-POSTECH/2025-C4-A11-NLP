//
//  DiaryWidget.swift
//  DiaryWidget
//
//  Created by JiJooMaeng on 7/28/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), latestDiaryDate: nil, wiseSaying: nil, resolution: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, latestDiaryDate: nil, wiseSaying: nil, resolution: nil)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let shared = UserDefaults(suiteName: "group.com.SPC4.Diary")
        let latestDiaryDate = shared?.object(forKey: "latestDiaryDate") as? Date
        let wiseSaying = shared?.string(forKey: "latestWiseSaying")
        let resolution = shared?.string(forKey: "latestResolution")

        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, configuration: configuration, latestDiaryDate: latestDiaryDate, wiseSaying: wiseSaying, resolution: resolution)
        entries.append(entry)

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let latestDiaryDate: Date?
    let wiseSaying: String?
    let resolution: String?
}

struct DiaryWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let latestDate = entry.latestDiaryDate {
                Text("🗓 최근 작성일: \(latestDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
            }
            if let saying = entry.wiseSaying {
                Text("💬 명언: \(saying)")
                    .font(.caption2)
                    .lineLimit(2)
            }
            if let resolution = entry.resolution {
                Text("🎯 다짐: \(resolution)")
                    .font(.caption2)
                    .lineLimit(1)
            }
        }
        .padding()
    }
}

struct DiaryWidget: Widget {
    let kind: String = "DiaryWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DiaryWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}

#Preview(as: .systemMedium) {
    DiaryWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent(), latestDiaryDate: nil, wiseSaying: nil, resolution: nil)
}
