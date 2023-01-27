#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart

  rlPhaseStartTest "mvn clean - ensure clean environment"
    rlRun -s "mvn -B clean"
    rlAssertNotExists target
  rlPhaseEnd

  rlPhaseStartTest "mvn verify - compile Java code and package JAR"
    rlRun -s "mvn -B verify"
    rlAssertExists target/hello-1.0.0.jar
  rlPhaseEnd

  rlPhaseStartTest "run hello with java command"
    rlRun -s "java -cp target/hello-1.0.0.jar test.hello.Hello"
    rlAssertGrep "^HELLO WORLD$" $rlRun_LOG
    rlAssertNotGrep "BUILD SUCCESS" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "mvn exec:java - run hello through Maven"
    rlRun -s "mvn -B exec:java -Dexec.mainClass=test.hello.Hello"
    rlAssertGrep "^HELLO WORLD$" $rlRun_LOG
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
  rlPhaseEnd

rlJournalEnd

rlJournalPrintText
