#!/bin/bash
# Author: Mikolaj Izdebski <mizdebsk@redhat.com>
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart

  rlPhaseStartTest "display Maven version"
    rlRun -s "mvn --version"
    rlAssertGrep "^Apache Maven " $rlRun_LOG
    rlAssertGrep "^Maven home: " $rlRun_LOG
    rlAssertGrep "^Java version:" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "display Maven help"
    rlRun -s "mvn --help"
    rlAssertGrep "Define a system property" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "validate missing project"
    rlRun -s "mvn validate" 1
    rlAssertGrep "BUILD FAILURE" $rlRun_LOG
    rlAssertGrep "there is no POM in this directory" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "validate simple project"
    rlRun -s "mvn -f simple.pom validate"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "test-git:test" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "display compiler help"
    rlRun -s "mvn compiler:help"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "compiler:testCompile" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "display effective POM"
    rlRun -s "mvn -f simple.pom help:effective-pom"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "<name>Central Repository</name>" $rlRun_LOG
  rlPhaseEnd

rlJournalEnd

rlJournalPrintText
