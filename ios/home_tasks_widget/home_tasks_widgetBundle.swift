//
//  home_tasks_widgetBundle.swift
//  home_tasks_widget
//
//  Created by Weronika Sioda on 17/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct home_tasks_widgetBundle: WidgetBundle {
    var body: some Widget {
        home_tasks_widget()
        //home_tasks_widgetControl()
        home_tasks_widgetLiveActivity()
    }
}
