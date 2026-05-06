import QtQuick 2.12
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.12

Item {
    id: page

    property alias cfg_accentColor: accentColorField.text
    property alias cfg_pollIntervalSeconds: pollIntervalSpin.value
    property alias cfg_roundPercent: roundPercentCheck.checked

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12

        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 10
            Layout.fillWidth: true

            Controls.Label {
                text: "Ring color"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }

            RowLayout {
                Layout.fillWidth: true

                Rectangle {
                    width: 24
                    height: 24
                    radius: 3
                    border.width: 1
                    border.color: "#808080"
                    color: /^#[0-9A-Fa-f]{6}$/.test(accentColorField.text) ? accentColorField.text : "#76B900"
                }

                Controls.TextField {
                    id: accentColorField
                    Layout.fillWidth: true
                    placeholderText: "#76B900"
                    validator: RegExpValidator {
                        regExp: /^#[0-9A-Fa-f]{6}$/
                    }
                }
            }

            Controls.Label {
                text: "Poll every"
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }

            Controls.SpinBox {
                id: pollIntervalSpin
                from: 1
                to: 3600
                stepSize: 1
                editable: true
                textFromValue: function(value) {
                    return value + " s";
                }
                valueFromText: function(text) {
                    return Math.max(from, Math.min(to, parseInt(text, 10) || 5));
                }
            }
        }

        Controls.CheckBox {
            id: roundPercentCheck
            text: "Round percentage to whole number"
        }
    }
}
