package com.vidar.vidar

import android.provider.Telephony.TextBasedSmsColumns

public val smsConstants: HashMap<String, String> = hashMapOf(
    "MESSAGE_TYPE_ALL" to TextBasedSmsColumns.MESSAGE_TYPE_ALL.toString(),
    "MESSAGE_TYPE_DRAFT" to TextBasedSmsColumns.MESSAGE_TYPE_DRAFT.toString(),
    "MESSAGE_TYPE_SENT" to TextBasedSmsColumns.MESSAGE_TYPE_SENT.toString(),
    "MESSAGE_TYPE_INBOX" to TextBasedSmsColumns.MESSAGE_TYPE_INBOX.toString(),
    "MESSAGE_TYPE_FAILED" to TextBasedSmsColumns.MESSAGE_TYPE_FAILED.toString(),
    "MESSAGE_TYPE_OUTBOX" to TextBasedSmsColumns.MESSAGE_TYPE_OUTBOX.toString(),
    "MESSAGE_TYPE_QUEUED" to TextBasedSmsColumns.MESSAGE_TYPE_QUEUED.toString(),
    "STATUS_NONE" to TextBasedSmsColumns.STATUS_NONE.toString(),
    "STATUS_FAILED" to TextBasedSmsColumns.STATUS_FAILED.toString(),
    "STATUS_PENDING" to TextBasedSmsColumns.STATUS_PENDING.toString(),
    "STATUS_COMPLETE" to TextBasedSmsColumns.STATUS_COMPLETE.toString(),
    "THREAD_ID" to TextBasedSmsColumns.THREAD_ID,
    "TYPE" to TextBasedSmsColumns.TYPE,
    "ADDRESS" to TextBasedSmsColumns.ADDRESS,
    "DATE" to TextBasedSmsColumns.DATE, 
    "DATE_SENT" to TextBasedSmsColumns.DATE_SENT,
    "READ" to TextBasedSmsColumns.READ,
    "SEEN" to TextBasedSmsColumns.SEEN,
    "PROTOCOL" to TextBasedSmsColumns.PROTOCOL,
    "STATUS" to TextBasedSmsColumns.STATUS,
    "SUBSCRIPTION_ID" to TextBasedSmsColumns.SUBSCRIPTION_ID,
    "SUBJECT" to TextBasedSmsColumns.SUBJECT,
    "BODY" to TextBasedSmsColumns.BODY
)
