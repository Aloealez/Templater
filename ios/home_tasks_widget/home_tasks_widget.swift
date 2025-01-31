import WidgetKit
import SwiftUI
import Intents
import UIKit

func getSmallWidgetPixelSize() -> CGSize {
    let scale = UIScreen.main.scale
    let smallWidgetSize = CGSize(width: 120, height: 120) // in points
    return CGSize(width: smallWidgetSize.width * scale, height: smallWidgetSize.height * scale)
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), filename: "No screenshot available", displaySize: context.displaySize)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.brainace_home_tasks_widget")
        let filename = userDefaults?.string(forKey: "filename") ?? "No screenshot available"
        let entry = SimpleEntry(date: Date(), filename: filename, displaySize: context.displaySize)
        completion(entry)
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let filename: String
    let displaySize: CGSize
}

struct home_tasks_widgetEntryView : View {
    var entry: Provider.Entry
    var CustomImage: some View {
        if let uiImage = UIImage(contentsOfFile: entry.filename) {
            let image = Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
            let targetSize = getSmallWidgetPixelSize()
            print("Small widget pixel size: \(targetSize.width) x \(targetSize.height)")
            //let targetSize = CGSize(width: 350, height: 350)
            let widthScaleRatio = targetSize.width / uiImage.size.width
            let heightScaleRatio = targetSize.height / uiImage.size.height
            let scaleRatio = min(widthScaleRatio, heightScaleRatio)
            let scaledImageSize = CGSize(
                width: uiImage.size.width * scaleRatio,
                height: uiImage.size.height * scaleRatio
                )
            let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
            let scaledImage = renderer.image { _ in
                uiImage.draw(in: CGRect(origin: .zero, size: scaledImageSize))
            }
            let simage = Image(uiImage: scaledImage).aspectRatio(contentMode: .fill)
            return AnyView(simage)
        }
        print("The image file could not be loaded")
        return AnyView(EmptyView())
    }
    var body: some View {
        CustomImage
            .scaledToFill()
            .padding(0)
    }
}

struct home_tasks_widget: Widget {
    let kind: String = "home_tasks_widget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            home_tasks_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Home Tasks Widget")
        .description("BrainAce Tasks")
//         .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .supportedFamilies([.systemSmall])
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

//#Preview(as: .systemSmall) {
//    home_tasks_widget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
