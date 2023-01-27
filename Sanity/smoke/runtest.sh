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
    rlRun -s "mvn -B compiler:help"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "compiler:testCompile" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "display effective POM"
    rlRun -s "mvn -B -f simple.pom help:effective-pom"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "<name>Central Repository</name>" $rlRun_LOG
  rlPhaseEnd

  rlPhaseStartTest "download remote artifact"
    rlRun "rm -rf $HOME/.m2/repository/junit/junit/4.12/"
    rlAssertNotExists $HOME/.m2/repository/junit/junit/4.12/junit-4.12.jar
    rlRun -s "mvn -B dependency:get -Dartifact=junit:junit:4.12"
    rlAssertGrep "BUILD SUCCESS" $rlRun_LOG
    rlAssertGrep "Resolving junit:junit:jar:4.12 with transitive dependencies" $rlRun_LOG
    rlAssertExists $HOME/.m2/repository/junit/junit/4.12/junit-4.12.jar
  rlPhaseEnd

rlJournalEnd

rlJournalPrintText
