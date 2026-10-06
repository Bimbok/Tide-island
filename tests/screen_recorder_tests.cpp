#include <QTest>
#include <QSignalSpy>
#include "ScreenRecorderController.h"

class ScreenRecorderTests : public QObject {
    Q_OBJECT

private slots:
    void initTestCase();
    void testInitialState();
    void testTimeFormatting();
    void testPropertySetters();
};

void ScreenRecorderTests::initTestCase() {
}

void ScreenRecorderTests::testInitialState() {
    ScreenRecorderController controller;
    QCOMPARE(ScreenRecorderController::instance(), &controller);
    QCOMPARE(controller.isRecording(), false);
    QCOMPARE(controller.isPaused(), false);
    QCOMPARE(controller.isReplayActive(), false);
    QCOMPARE(controller.recordingSeconds(), 0);
    QCOMPARE(controller.recordingTimeFormatted(), QStringLiteral("00:00"));
    QCOMPARE(controller.fps(), 60);
    QCOMPARE(controller.replaySeconds(), 60);
}

void ScreenRecorderTests::testTimeFormatting() {
    ScreenRecorderController controller;
    // Test through QObject properties / methods
    QCOMPARE(controller.recordingTimeFormatted(), QStringLiteral("00:00"));

    // We can verify recordingTimeFormatted logic
    // 65 seconds -> 01:05
    // 3600 seconds -> 60:00
}

void ScreenRecorderTests::testPropertySetters() {
    ScreenRecorderController controller;

    QSignalSpy micSpy(&controller, &ScreenRecorderController::micEnabledChanged);
    controller.setMicEnabled(true);
    QCOMPARE(controller.micEnabled(), true);
    QCOMPARE(micSpy.count(), 1);

    QSignalSpy fpsSpy(&controller, &ScreenRecorderController::fpsChanged);
    controller.setFps(120);
    QCOMPARE(controller.fps(), 120);
    QCOMPARE(fpsSpy.count(), 1);

    QSignalSpy replaySpy(&controller, &ScreenRecorderController::replaySecondsChanged);
    controller.setReplaySeconds(30);
    QCOMPARE(controller.replaySeconds(), 30);
    QCOMPARE(replaySpy.count(), 1);

    QSignalSpy screenSpy(&controller, &ScreenRecorderController::screenNameChanged);
    controller.setScreenName(QStringLiteral("DP-1"));
    QCOMPARE(controller.screenName(), QStringLiteral("DP-1"));
    QCOMPARE(screenSpy.count(), 1);
}

QTEST_MAIN(ScreenRecorderTests)
#include "screen_recorder_tests.moc"
