#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart

  rlPhaseStartTest
    rlRun -s "mvn -B clean"
    rlAssertNotExists target
    rlRun -s "mvn -B verify"
    rlAssertExists target/hello-1.0.0.jar
    rlRun -s "java -cp target/hello-1.0.0.jar test.hello.Hello"
    rlAssertGrep "^HELLO WORLD$" $rlRun_LOG
    rlAssertNotGrep "BUILD SUCCESS" $rlRun_LOG
    rlRun -s "mvn -B exec:java -Dexec.mainClass=test.hello.Hello"
    rlAssertGrep "^HELLO WORLD$" $rlRun_LOG
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
  rlPhaseEnd

rlJournalEnd

rlJournalPrintText
