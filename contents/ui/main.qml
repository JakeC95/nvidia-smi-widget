import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    readonly property color accentColor: "#76B900"
    readonly property string command: "nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0"
    readonly property bool inPanel: [
        PlasmaCore.Types.TopEdge,
        PlasmaCore.Types.RightEdge,
        PlasmaCore.Types.BottomEdge,
        PlasmaCore.Types.LeftEdge
    ].indexOf(Plasmoid.location) !== -1
    readonly property int panelExtent: PlasmaCore.Units.iconSizeHints.panel
    property real percent: 0
    property int usedMiB: 0
    property int totalMiB: 0
    property bool hasReading: false
    property string errorText: ""
    property bool polling: false

    Layout.minimumWidth: PlasmaCore.Units.iconSizes.small
    Layout.minimumHeight: PlasmaCore.Units.iconSizes.small
    Layout.preferredWidth: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 2.4
    Layout.preferredHeight: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 2.4
    Layout.maximumWidth: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 8
    Layout.maximumHeight: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 8
    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.title: "NVIDIA VRAM"
    Plasmoid.toolTipSubText: root.tooltipText()

    function tooltipText() {
        if (!hasReading) {
            return errorText.length > 0 ? errorText : "Waiting for nvidia-smi";
        }
        return usedMiB + " MiB / " + totalMiB + " MiB";
    }

    function parseReading(stdout, stderr, exitCode) {
        var code = parseInt(exitCode, 10);
        if (!isFinite(code)) {
            code = 0;
        }
        if (code !== 0) {
            hasReading = false;
            errorText = stderr && stderr.length > 0 ? stderr.trim() : "nvidia-smi failed";
            percent = 0;
            return;
        }

        var match = stdout.match(/^\s*([0-9]+)\s*,\s*([0-9]+)\s*$/m);
        if (!match) {
            hasReading = false;
            errorText = "Unexpected nvidia-smi output";
            percent = 0;
            return;
        }

        usedMiB = parseInt(match[1], 10);
        totalMiB = parseInt(match[2], 10);
        if (!isFinite(usedMiB) || !isFinite(totalMiB) || totalMiB <= 0) {
            hasReading = false;
            errorText = "Invalid nvidia-smi memory values";
            percent = 0;
            return;
        }

        hasReading = true;
        errorText = "";
        percent = Math.max(0, Math.min(100, usedMiB * 100 / totalMiB));
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"

        onNewData: {
            root.polling = false;
            root.parseReading(data["stdout"] || "", data["stderr"] || "", data["exit code"]);
            disconnectSource(sourceName);
        }

        function run() {
            if (root.polling) {
                return;
            }
            root.polling = true;
            connectSource(root.command);
        }
    }

    Timer {
        id: refreshTimer
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: executable.run()
    }

    Item {
        id: ring
        anchors.fill: parent

        readonly property real size: Math.min(width, height)
        readonly property real stroke: Math.max(5, size * 0.14)
        readonly property real radius: (size - stroke) / 2 - 1

        Shape {
            anchors.fill: parent
            visible: ring.radius > 0
            layer.enabled: true
            layer.samples: 4

            ShapePath {
                fillColor: "transparent"
                strokeColor: Qt.rgba(1, 1, 1, 0.14)
                strokeWidth: ring.stroke
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: ring.width / 2
                    centerY: ring.height / 2
                    radiusX: ring.radius
                    radiusY: ring.radius
                    startAngle: 130
                    sweepAngle: 280
                }
            }

            ShapePath {
                fillColor: "transparent"
                strokeColor: root.accentColor
                strokeWidth: ring.stroke
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: ring.width / 2
                    centerY: ring.height / 2
                    radiusX: ring.radius
                    radiusY: ring.radius
                    startAngle: 130
                    sweepAngle: root.hasReading ? 280 * root.percent / 100 : 0
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        width: parent.width * 0.82
        text: root.hasReading ? root.percent.toFixed(1) + "%" : "--%"
        color: "#f4f7f9"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: Math.max(8, Math.min(parent.width, parent.height) * 0.23)
        font.bold: false
    }

}
