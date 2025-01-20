package com.pro.brainace

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class PortHomeTasksWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.port_home_tasks_widget).apply {
                val imageName = widgetData.getString("filename", null)
                setImageViewBitmap(R.id.port_home_widget_image, BitmapFactory.decodeFile(imageName))
            }


            val intent = Intent(context, ListWidgetService::class.java)
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            //views.setRemoteAdapter(R.id.plan_tasks_list, intent)

            views.setOnClickPendingIntent(R.id.port_home_tasks_widget,
                PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java),
                    PendingIntent.FLAG_IMMUTABLE)) // czy nie powinno być FLAG.MUTABLE?


            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}