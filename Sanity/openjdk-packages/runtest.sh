#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart
rlPhaseStartTest

n=${OPENJDK_VERSION:=17}

# Headless JRE of correct version must always be installed
rlAssertRpm "java-${n}-openjdk-headless"

# JDK packages must or must not be installed, depending on test scenario
if [ -z "${OPENJDK_HEADLESS}" ]; then
    rlAssertRpm "java-${n}-openjdk"
    rlAssertRpm "java-${n}-openjdk-devel"
else
    rlAssertNotRpm "java-${n}-openjdk"
    rlAssertNotRpm "java-${n}-openjdk-devel"
fi

# Other JVM packages must not be installed
rlRun -s "rpm -qa | grep ^java- | grep -v ^java-${n}-openjdk- | sort"
rlAssertNotGrep . $rlRun_LOG

rlPhaseEnd
rlJournalEnd
rlJournalPrintText
