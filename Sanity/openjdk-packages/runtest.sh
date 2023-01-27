#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

n=${OPENJDK_VERSION:=17}

rlJournalStart

  rlPhaseStartTest "Check for presence of headless Java $n JRE"
    rlAssertRpm "java-${n}-openjdk-headless"
  rlPhaseEnd

  if [ -z "${OPENJDK_HEADLESS}" ]; then

    rlPhaseStartTest "Check for presence of Java $n JDK"
      rlAssertRpm "java-${n}-openjdk"
      rlAssertRpm "java-${n}-openjdk-devel"
    rlPhaseEnd

  else

    rlPhaseStartTest "Check for absence of Java $n JDK"
      rlAssertNotRpm "java-${n}-openjdk"
      rlAssertNotRpm "java-${n}-openjdk-devel"
    rlPhaseEnd

  fi

  rlPhaseStartTest "Check for absence of JVMs other than OpenJDK $n"
    rlRun -s "rpm -qa | grep ^java- | grep -v ^java-${n}-openjdk- | sort"
    rlAssertNotGrep . $rlRun_LOG
  rlPhaseEnd

rlJournalEnd
rlJournalPrintText
