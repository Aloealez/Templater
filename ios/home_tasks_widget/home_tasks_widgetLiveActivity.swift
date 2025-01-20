//
//  home_tasks_widgetLiveActivity.swift
//  home_tasks_widget
//
//  Created by Weronika Sioda on 17/10/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct home_tasks_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct home_tasks_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: home_tasks_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct home_tasks_widgetLiveActivity_Previews: PreviewProvider {
    static let attributes = home_tasks_widgetAttributes(name: "Me")
    static let contentState = home_tasks_widgetAttributes.ContentState(value: 3)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

//extension home_tasks_widgetAttributes {
//    fileprivate static var preview: home_tasks_widgetAttributes {
//        home_tasks_widgetAttributes(name: "World")
//    }
//}

//extension home_tasks_widgetAttributes.ContentState {
//    fileprivate static var smiley: home_tasks_widgetAttributes.ContentState {
//        home_tasks_widgetAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: home_tasks_widgetAttributes.ContentState {
//         home_tasks_widgetAttributes.ContentState(emoji: "🤩")
//     }
//}

//#Preview("Notification", as: .content, using: home_tasks_widgetAttributes.preview) {
//   home_tasks_widgetLiveActivity()
//} contentStates: {
//    home_tasks_widgetAttributes.ContentState.smiley
//    home_tasks_widgetAttributes.ContentState.starEyes
//}
