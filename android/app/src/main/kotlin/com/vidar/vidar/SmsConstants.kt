package com.vidar.vidar

import android.provider.Telephony.TextBasedSmsColumns

public val smsConstants: HashMap<String, String> = hashMapOf(
    "MESSAGE_TYPE_ALL" to TextBasedSmsColumns.MESSAGE_TYPE_ALL,
    "MESSAGE_TYPE_DRAFT" to TextBasedSmsColumns.MESSAGE_TYPE_DRAFT,
    "MESSAGE_TYPE_SENT" to TextBasedSmsColumns.MESSAGE_TYPE_SENT,
    "MESSAGE_TYPE_INBOX" to TextBasedSmsColumns.MESSAGE_TYPE_INBOX,
    "MESSAGE_TYPE_FAILED" to TextBasedSmsColumns.MESSAGE_TYPE_FAILED,
    "MESSAGE_TYPE_OUTBOX" to TextBasedSmsColumns.MESSAGE_TYPE_OUTBOX,
    "MESSAGE_TYPE_QUEUED" to TextBasedSmsColumns.MESSAGE_TYPE_QUEUED,
    "STATUS_NONE" to TextBasedSmsColumns.STATUS_NONE,
    "STATUS_FAILED" to TextBasedSmsColumns.STATUS_FAILED,
    "STATUS_PENDING" to TextBasedSmsColumns.STATUS_PENDING,
    "STATUS_COMPLETE" to TextBasedSmsColumns.STATUS_COMPLETE
)
