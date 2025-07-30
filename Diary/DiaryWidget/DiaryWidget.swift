//
//  DiaryWidget.swift
//  DiaryWidget
//
//  Created by JiJooMaeng on 7/28/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), latestDiaryDate: nil, wiseSaying: nil, resolution: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), latestDiaryDate: nil, wiseSaying: nil, resolution: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        let shared = UserDefaults(suiteName: "group.com.SPC4.Diary")
        let latestDiaryDate = shared?.object(forKey: "latestDiaryDate") as? Date
        let wiseSaying = shared?.string(forKey: "latestWiseSaying")
        let resolution = shared?.string(forKey: "latestResolution")
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, latestDiaryDate: latestDiaryDate, wiseSaying: wiseSaying, resolution: resolution)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let latestDiaryDate: Date?
    let wiseSaying: String?
    let resolution: String?
}

struct DiaryWidgetEntryView : View {
    var entry: Provider.Entry
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월d일"
        return formatter
    }()
    
    static let dateFormatterForURL: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        ZStack {
            ViewThatFits {
                VStack(alignment: .leading) {
                    HStack {
                        Image("appicon_widget")
                        if let latestDate = entry.latestDiaryDate {
                            Text("\(Self.dateFormatter.string(from: latestDate)) 회고쓰기")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    HStack {
                        Text("명언")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 40, alignment: .leading)
                        
                        if let saying = entry.wiseSaying {
                            Text("\(saying)")
                                .font(.system(size: 12))
                                .lineLimit(2)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("다짐")
                                .font(.system(size: 16, weight: .semibold))
                            Text("AI 요약")
                                .font(.system(size: 13))
                        }
                        .frame(width: 40, alignment: .leading)
                        
                        if let resolution = entry.resolution {
                            Text("\(resolution)")
                                .font(.system(size: 12))
                                .lineLimit(2)
                        }
                    }
                    
                }
                
            }
        }
    }
}

struct DiaryWidget: Widget {
    let kind: String = "DiaryWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DiaryWidgetEntryView(entry: entry)
                .containerBackground(Color.white, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}


#Preview(as: .systemMedium) {
    DiaryWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        latestDiaryDate: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 20)),
        wiseSaying: "삶은 자전거 타기와 같다. 균형을 잡으려면 움직여야 한다.",
        resolution: "매일 기록하기"
    )
}
