package com.pro.brainace

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class TodoHomeScreenWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            //updateAppWidget(context, appWidgetManager, appWidgetId)
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.todo_home_screen_widget)
            val title = widgetData.getString("plan_title", null)
            val plan = widgetData.getString("plan_tasks", null)
            views.setTextViewText(R.id.plan_title, title)
            //views.setTextViewText(R.id.plan_tasks, plan)


            val sharedPreferences = context.getSharedPreferences("WidgetPrefs", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()

            // Modify the data here (e.g., new list items)

            if (plan != null) {
                var plan_items = mutableListOf<String>()
                plan_items.addAll(plan.split(","))

                var items = mutableListOf<String>()
                var checks = mutableListOf<String>()
                for (plan_item in plan_items) {
                    if (plan_item.split(":").size < 2) {
                        continue
                    }
                    checks.add(plan_item.split(":")[0])
                    items.add(plan_item.split(":")[1])
                }

                // Save the items as a string (for simplicity)
                //editor.putString("items", items.joinToString(","))
                editor.putString("items", items.joinToString(","))
                editor.putString("checks", checks.joinToString(","))
                editor.apply()
            }

            val intent = Intent(context, ListWidgetService::class.java)
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            views.setRemoteAdapter(R.id.plan_tasks_list, intent)

            views.setOnClickPendingIntent(R.id.todo_home_screen_widget,
                PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_IMMUTABLE)) // czy nie powinno być FLAG.MUTABLE?

            appWidgetManager.updateAppWidget(appWidgetId, views)
            AppWidgetManager.getInstance(context).notifyAppWidgetViewDataChanged(appWidgetId, R.id.plan_tasks_list)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created


    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.todo_home_screen_widget)
    views.setTextViewText(R.id.plan_title, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}