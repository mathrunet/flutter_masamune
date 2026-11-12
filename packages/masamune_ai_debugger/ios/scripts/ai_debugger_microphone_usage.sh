#!/bin/sh
# Adds NSMicrophoneUsageDescription to the built Info.plist only for builds
# with the AI debugger voice input (MASAMUNE_AI_DEBUGGER_VOICE=YES).
#
# Add it to the Runner target as a Run Script build phase placed after
# "Copy Bundle Resources":
#
#   /bin/sh "${SRCROOT}/.symlinks/plugins/masamune_ai_debugger/ios/scripts/ai_debugger_microphone_usage.sh"
#
# Input file:  $(TARGET_BUILD_DIR)/$(INFOPLIST_PATH)
# Output file: $(DERIVED_FILE_DIR)/masamune_ai_debugger_microphone_usage.stamp
# Check "Based on dependency analysis" off (always out of date).
#
# Do not list the Info.plist as an output; Xcode reports "Multiple commands
# produce" because the Info.plist is already produced by ProcessInfoPlistFile.
#
# A usage description supplied by the app itself is never modified or removed.

set -e

PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
KEY="NSMicrophoneUsageDescription"
MESSAGE="${MASAMUNE_AI_DEBUGGER_MICROPHONE_USAGE:-The AI debugger uses the microphone to transcribe spoken debug instructions.}"
BUDDY="/usr/libexec/PlistBuddy"

if [ -z "${TARGET_BUILD_DIR}" ] || [ -z "${INFOPLIST_PATH}" ]; then
  echo "warning: masamune_ai_debugger: TARGET_BUILD_DIR or INFOPLIST_PATH is not set."
  exit 0
fi

if [ -f "${PLIST}" ]; then
  CURRENT="$("${BUDDY}" -c "Print :${KEY}" "${PLIST}" 2>/dev/null || true)"
  if [ "${MASAMUNE_AI_DEBUGGER_VOICE}" = "YES" ]; then
    if [ -z "${CURRENT}" ]; then
      "${BUDDY}" -c "Add :${KEY} string ${MESSAGE}" "${PLIST}"
    fi
  elif [ -n "${CURRENT}" ] && [ "${CURRENT}" = "${MESSAGE}" ]; then
    # Remove the value left by a previous voice build (incremental builds
    # may reuse the processed Info.plist).
    "${BUDDY}" -c "Delete :${KEY}" "${PLIST}"
  fi
else
  echo "warning: masamune_ai_debugger: ${PLIST} was not found."
fi

if [ -n "${DERIVED_FILE_DIR}" ]; then
  mkdir -p "${DERIVED_FILE_DIR}"
  touch "${DERIVED_FILE_DIR}/masamune_ai_debugger_microphone_usage.stamp"
fi
