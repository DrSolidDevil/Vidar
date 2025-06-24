package com.vidar.vidar

import android.content.Context
import android.database.Cursor
import androidx.core.net.toUri
import android.provider.Telephony.TextBasedSmsColumns


fun querySms(context: Context, phoneNumber: String?): ArrayList<HashMap<String, String>>? {
    val sms: Cursor?
    if (phoneNumber != null) {
        println("phoneNumber not null")
        sms = context.contentResolver.query(
            "content://sms/".toUri(),
            includedQueryData,
            "address=?",
            arrayOf(phoneNumber),
            null
        )
    } else {
        println("phoneNumber null")
        sms = context.contentResolver.query(
            "content://sms/".toUri(),
            includedQueryData,
            null,
            null,
            null
        )
    }
    if (sms == null || !sms.moveToFirst()) {
        return null
    }
    return cursorToListOfHashMap(sms)
}

private val includedQueryData: Array<String> = arrayOf(
    TextBasedSmsColumns.THREAD_ID,
    TextBasedSmsColumns.TYPE,
    TextBasedSmsColumns.ADDRESS,
    TextBasedSmsColumns.DATE, // The date the message was received.
    TextBasedSmsColumns.DATE_SENT, // The date the message was sent.
    TextBasedSmsColumns.READ,
    TextBasedSmsColumns.SEEN,
    TextBasedSmsColumns.PROTOCOL, // Messaging protocol, ex. SMS or MMS
    TextBasedSmsColumns.STATUS,
    TextBasedSmsColumns.SUBSCRIPTION_ID,
    TextBasedSmsColumns.SUBJECT,
    TextBasedSmsColumns.BODY
)


// Closes the cursor when it's done
// A list of hashmaps in kotlin is equivalent to a list of maps in dart
private fun cursorToListOfHashMap(cursor: Cursor): ArrayList<HashMap<String, String>> {
    val threadIdColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.THREAD_ID)
    val typeColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.TYPE)
    val addressColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.ADDRESS)
    val dateColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.DATE)
    val dateSentColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.DATE_SENT)
    val readColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.READ)
    val seenColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.SEEN)
    val protocolColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.PROTOCOL)
    val statusColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.STATUS)
    val subscriptionIdColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.SUBSCRIPTION_ID)
    val subjectColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.SUBJECT)
    val bodyColumnIndex: Int = cursor.getColumnIndexOrThrow(TextBasedSmsColumns.BODY)
    val hashMapList: ArrayList<HashMap<String, String>> = ArrayList<HashMap<String, String>>()

    @Suppress("ConvertTryFinallyToUseCall")
    try {
        do {
            
            val entry: MutableMap<String, String> = mutableMapOf<String, String>()
            entry[TextBasedSmsColumns.THREAD_ID] = cursor.getString(threadIdColumnIndex)
            entry[TextBasedSmsColumns.TYPE] = cursor.getString(typeColumnIndex)
            entry[TextBasedSmsColumns.ADDRESS] = cursor.getString(addressColumnIndex)
            entry[TextBasedSmsColumns.DATE] = cursor.getString(dateColumnIndex)
            entry[TextBasedSmsColumns.DATE_SENT] = cursor.getString(dateSentColumnIndex)
            entry[TextBasedSmsColumns.READ] = cursor.getString(readColumnIndex)
            entry[TextBasedSmsColumns.SEEN] = cursor.getString(seenColumnIndex)
            entry[TextBasedSmsColumns.PROTOCOL] = cursor.getString(protocolColumnIndex)
            entry[TextBasedSmsColumns.STATUS] = cursor.getString(statusColumnIndex)
            entry[TextBasedSmsColumns.SUBSCRIPTION_ID] = cursor.getString(subscriptionIdColumnIndex)
            entry[TextBasedSmsColumns.SUBJECT] = cursor.getString(subjectColumnIndex)
            entry[TextBasedSmsColumns.BODY] = cursor.getString(bodyColumnIndex)
            // Append deep read only map clone
            val newEntry = HashMap(entry)
            hashMapList.add(newEntry)
        } while (cursor.moveToNext())
    } finally {
        cursor.close();
    }

    return hashMapList
}
