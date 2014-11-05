import QtQuick 2.3
import QtQuick.Controls 1.2
import com.sysgetter 1.0
import QtQuick.LocalStorage 2.0
import "qrc:/logic.js" as Logic

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 800
    height: 600
    title: qsTr("Hello World")

    SystemAccessor {
        id: accessor
    }

    Button {
        id: buttonSavePath
        text: qsTr("Save PATH")
        z: 1
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        onClicked: {
            accessor.set_environment(pathEdit.textDocument);
        }

    }

    SplitView {
        id: splitView1
        y: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: buttonSavePath.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        orientation: Qt.Vertical

        Rectangle{
            id: rectangle1
            width: 570
            height: 344

            color: "white"
            anchors.top: parent.top
            anchors.topMargin: 0
            z: 3
            border.color: "black"

            TextArea {
                id: pathEdit
                text: accessor.get_environment()
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                z: 0
                font.pixelSize: 12
                wrapMode: TextEdit.WordWrap
                textFormat: TextEdit.RichText
                property bool marking
                y: 0
                function cutPath(fullEnvironment){
                    var rxStart = /\n(PATH=[\w\d\\\.:;\s\(\)-]+\n)/;
                    var matchStart = rxStart.exec(fullEnvironment);
                    return matchStart[0].replace(/;/g, ";\n");
                }
                onTextChanged: {
                    if(!marking)
                    {
                        marking = true;
                        var pos = cursorPosition;
                        text = accessor.markup(textDocument);
                        cursorPosition = pos;
                        marking = false;
                    }
                }
            }
        }

        Rectangle {
            id: rectangle2
            y: 0
            width: 200
            color: "#ffffff"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            clip: false
            z: 0
            anchors.top: rectangle1.bottom
            anchors.topMargin: 1

            RotationC
            {
                id:rotationDelegate
            }

            ListView {
                id: lvCombinations
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: cbCombinations.bottom
                model: rotationModel
                spacing: 2
                delegate: rotationDelegate
                signal modelReady
                Component.onDestruction:
                {
                    Logic.saveItems(rotationModel)
                }
                Component.onCompleted: {
                    function compare(a,b) {
                        if (a.addValue > b.addValue)
                            return -1;
                        return 1;
                    }
                    lvCombinations.modelReady()
                }

            }

            ComboBox {
                id: cbCombinations
                height: btnAdd.height
                anchors.left: btnToggle.right
                anchors.top: parent.top
                editable: true
                onCurrentTextChanged:
                {
                    Logic.setGroup()
                }
                Component.onCompleted: {
                    Logic.loadItems()
                }
            }

            Button {
                id: btnAdd
                text: "Add"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                onClicked: rotationModel.append({text: cbCombinations.currentText,
                                                    addValue:1,
                                                    value: ""})
            }

            Button {
                id: btnRemove
                x: 0
                text: "Remove"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: btnAdd.right
                activeFocusOnPress: true
            }

            Button {
                id: btnToggle
                x: 0
                text: "Toggle"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: btnRemove.right
                anchors.leftMargin: 0
            }
            ListModel {
                id: rotationModel
            }
        }


    }
}
