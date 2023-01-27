#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart

  rlPhaseStartTest "JAVA_HOME not set - use default Java"
    rlRun -s "mvn --version"
    rlAssertGrep "Apache Maven" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "JAVA_HOME set to a directory containing dummy Java script"
    rlRun -s "JAVA_HOME=$PWD mvn --version" 42
    rlAssertGrep "DUMMY JAVA CALLED" $rlRun_LOG
    rlAssertGrep plexus-classworlds $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "JAVA_HOME set to /dev/null"
    rlRun -s "JAVA_HOME=/dev/null mvn --version" 1
    rlAssertGrep "The JAVA_HOME environment variable is not defined correctly" $rlRun_LOG
  rlPhaseEnd

rlJournalEnd
rlJournalPrintText
