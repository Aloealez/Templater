package com.pro.brainace

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService

class ListWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return ListRemoteViewsFactory(this.applicationContext)
    }
}

class ListRemoteViewsFactory(private val context: Context) : RemoteViewsService.RemoteViewsFactory {

    private val items = mutableListOf<String>()
    private val checks = mutableListOf<String>()

    override fun onCreate() {
        // Initialize data here (e.g., from a database or API)
        //items.addAll(listOf("Item 1", "Item 2", "Item 3", "Item 4"))
        loadDataFromPreferences()
    }

    override fun getCount(): Int {
        return items.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.plan_task_item)
        views.setTextViewText(R.id.plan_task_list_item, items[position])
        views.setTextViewText(R.id.plan_task_item_check, checks[position])


        val intent = Intent(context, MainActivity::class.java)
        intent.putExtra("item_position", position)
        // Optionally set an intent to handle item clicks
        val fillInIntent = PendingIntent.getActivity(context, position, intent, PendingIntent.FLAG_IMMUTABLE)
        views.setOnClickPendingIntent(R.id.plan_task_list_item, fillInIntent)
        views.setOnClickPendingIntent(R.id.plan_task_item_check, fillInIntent)

        return views
    }

    private fun loadDataFromPreferences() {
        val sharedPreferences = context.getSharedPreferences("WidgetPrefs", Context.MODE_PRIVATE)
        val itemsString = sharedPreferences.getString("items", "") ?: ""
        val checksString = sharedPreferences.getString("checks", "") ?: ""
        items.clear()
        checks.clear()
        if (itemsString.isNotEmpty()) {
            items.addAll(itemsString.split(","))
            checks.addAll(checksString.split(","))
        }
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun onDataSetChanged() {
        loadDataFromPreferences()
    }

    override fun onDestroy() {
        items.clear()
        checks.clear()
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }
}
