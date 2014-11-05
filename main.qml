import QtQuick 2.3
import QtQuick.Controls 1.2
import com.sysgetter 1.0
import QtQuick.LocalStorage 2.0

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

            ListView {
                id: lvCombinations
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: cbCombinations.bottom
                //anchors.fill: parent
                model: rotationModel
                delegate: rotationDelegate
                signal modelReady
                Component.onDestruction:
                {
                    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
                    console.log(db)
                    db.transaction(
                                function(tx) {
                                    // Create the database if it doesn't already exist
                                    tx.executeSql('CREATE TABLE IF NOT EXISTS ROTATIONSETS(setname TEXT, setoperation NUMBER, setfolder TEXT)');
                                    console.log(rotationModel.count)
                                    for(var i = 0; i < rotationModel.count; i++)
                                    {
                                        var exists = tx.executeSql('Select * from ROTATIONSETS where setname = ? and setoperation = ? and setfolder = ?',
                                                                   [rotationModel.get(i).text, rotationModel.get(i).addValue, rotationModel.get(i).value]);
                                        console.log(exists.rows)
                                        if(exists.rows.length === 0)
                                        {
                                            tx.executeSql('INSERT INTO ROTATIONSETS VALUES(?, ?, ?)',
                                                          [rotationModel.get(i).text, rotationModel.get(i).addValue, rotationModel.get(i).value]);
                                        }
                                    }
                                }
                                )

                }
                Component.onCompleted: {
                    function compare(a,b) {
                        if (a.addValue > b.addValue)
                            return -1;
                        return 1;
                    }
                    elements.sort(compare)

                    var db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
                    console.log(db)
                    db.transaction(
                                function(tx) {
                                    // Create the database if it doesn't already exist
                                    tx.executeSql('CREATE TABLE IF NOT EXISTS ROTATIONSETS(setname TEXT, setoperation NUMBER, setfolder TEXT)');
                                    var rs = tx.executeSql('Select * from ROTATIONSETS')
                                    for(var i = 0; i < rs.rows.length; i++)
                                    {
                                        rotationModel.append({"text": rs.rows.item(i).setname, "addValue":rs.rows.item(i).setoperation, "value":rs.rows.item(i).setfolder})
                                    }
                                }
                                )



                    lvCombinations.modelReady()
                }
            }

            ComboBox {
                id: cbCombinations
                height: btnAdd.height
                anchors.left: btnToggle.right
                anchors.top: parent.top
                editable: true
                Connections {
                    target: lvCombinations
                    onModelReady: {cbCombinations.model = rotationModel}
                }
            }

            Button {
                id: btnAdd
                text: "Add"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
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

            //            ListElement {
            //                text: "test"
            //                addValue: true
            //                value: "K:;"
            //            }
            //            ListElement {
            //                text: "test"
            //                addValue: false
            //                value: "K:;"
            //            }
            //            ListElement {
            //                text: "test"
            //                addValue: true
            //                value: "K:;"
            //            }
            Component {
                id: rotationDelegate
                Row
                {
                    spacing: 2
                    Rectangle {
                        id: indicator
                        height:20
                        width: 5
                        color: addValue ? "lightGreen" : "pink"
                    }
                    Rectangle {
                        height:20
                        //color: Qt.lighter("lightGreen")
                        //color: "lightGreen"
                        //width:txt.width
                        width: 500
                        Text {
                            id:txt
                            x:5
                            anchors.verticalCenter: parent.verticalCenter
                            text: value

                        }
                    }
                }
            }
            Component {
                id: numberDelegate

                Rectangle {
                    width: 40
                    height: 40

                    color: "lightGreen"

                    Text {
                        anchors.centerIn: parent

                        font.pixelSize: 10

                        text: index
                    }
                }
            }
        }


    }
}
