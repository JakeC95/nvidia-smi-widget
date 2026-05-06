import QtQuick 2.12
import QtQuick.Layouts 1.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    readonly property bool inPanel: [
        PlasmaCore.Types.TopEdge,
        PlasmaCore.Types.RightEdge,
        PlasmaCore.Types.BottomEdge,
        PlasmaCore.Types.LeftEdge
    ].indexOf(Plasmoid.location) !== -1
    readonly property int panelExtent: PlasmaCore.Units.iconSizeHints.panel

    Layout.minimumWidth: PlasmaCore.Units.iconSizes.small
    Layout.minimumHeight: PlasmaCore.Units.iconSizes.small
    Layout.preferredWidth: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 2.4
    Layout.preferredHeight: inPanel ? panelExtent : PlasmaCore.Units.gridUnit * 2.4
    Layout.maximumWidth: inPanel ? panelExtent : -1
    Layout.maximumHeight: inPanel ? panelExtent : -1
    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight

    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.title: "NVIDIA VRAM"
    Plasmoid.toolTipSubText: "VRAM widget render test"

    Canvas {
        id: ring
        anchors.fill: parent
        antialiasing: true

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            var size = Math.min(width, height);
            ctx.clearRect(0, 0, width, height);
            if (size < 4) {
                return;
            }
            var centerX = width / 2;
            var centerY = height / 2;
            var stroke = Math.max(3, size * 0.08);
            var radius = (size - stroke) / 2 - 1;
            var start = Math.PI * 0.72;
            var sweep = Math.PI * 1.56;

            ctx.lineCap = "round";
            ctx.lineWidth = stroke;
            ctx.beginPath();
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.14);
            ctx.arc(centerX, centerY, radius, start, start + sweep, false);
            ctx.stroke();
            ctx.beginPath();
            ctx.strokeStyle = "#20aeea";
            ctx.arc(centerX, centerY, radius, start, start + sweep * 0.73, false);
            ctx.stroke();
        }
    }

    Text {
        anchors.centerIn: parent
        width: parent.width * 0.82
        text: "73%"
        color: "#f4f7f9"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.pixelSize: Math.max(8, Math.min(parent.width, parent.height) * 0.23)
    }
}
