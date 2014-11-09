import QtQuick 2.3
import QtQuick.Controls 1.2
import com.sysgetter 1.0
import QtQuick.LocalStorage 2.0
import "qrc:/logic.js" as Logic
import QtQml.Models 2.1
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
        x: 720
        text: qsTr("Save PATH")
        anchors.right: parent.right
        anchors.rightMargin: 0
        z: 1
//        height:90
//        width:90
        iconSource: "qrc:/save.png"
        anchors.top: parent.top
        anchors.topMargin: 0
        onClicked: {
            accessor.set_environment(Logic.createNewEnvironment());
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

            ListView {
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
                }
                id: lvPath
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                model: visualModel
                spacing: 2
                clip:true
                //delegate: pathDelegate
                Component.onCompleted: {
                    Logic.collectPATH()
                }
            }
            //            TextArea {
            //                id: pathEdit
            //                text: accessor.get_environment()
            //                anchors.right: parent.right
            //                anchors.rightMargin: 0
            //                anchors.bottom: parent.bottom
            //                anchors.bottomMargin: 0
            //                anchors.left: parent.left
            //                anchors.leftMargin: 0
            //                anchors.top: parent.top
            //                anchors.topMargin: 0
            //                z: 0
            //                font.pixelSize: 12
            //                wrapMode: TextEdit.WordWrap
            //                textFormat: TextEdit.RichText
            //                property bool marking
            //                y: 0

            //                onTextChanged: {
            //                    if(!marking)
            //                    {
            //                        marking = true;
            //                        var pos = cursorPosition;
            //                        text = accessor.markup(textDocument);
            //                        cursorPosition = pos;
            //                        marking = false;
            //                    }
            //                }
            //            }
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
            Component {
                id: highlight
                Rectangle {
                    width: 180; height: 40
                    color: "lightsteelblue"; radius: 5
                    y: lvCombinations.currentItem.y
                    Behavior on y {
                        SpringAnimation {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
            }
            ListView {
                id: lvCombinations
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: cbCombinations.bottom
                model: rotationModel
                spacing: 2
                focus: true
                delegate: rotationDelegate
//                delegate: Rectangle{
//                    border.color: "black"
//                    width:80
//                    height:20
//                    anchors.left: parent.left
//                }
                signal modelReady
//                highlight: highlight
//                highlightFollowsCurrentItem: true
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
                anchors.left: btnRemove.right
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
                id: btnPass
                //text: "Apply group"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                iconSource: "qrc:/up.png"
                onClicked: Logic.applyCurrentGroup()
            }
            Button {
                id: btnAdd
                //text: "Add New Item"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: btnPass.right
                anchors.leftMargin: 0
                iconSource: "qrc:/plus.png"
                onClicked: rotationModel.append({text: cbCombinations.currentText,
                                                    addValue:1,
                                                    value: ""})
            }

            Button {
                id: btnRemove
                x: 0
                //text: "Remove item"
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: btnAdd.right
                iconSource: "qrc:/delete.png"
                activeFocusOnPress: true
                onClicked: {
                    //console.log("Selected: ",lvCombinations.currentIndex)
                    rotationModel.remove(lvCombinations.currentIndex)
                }
            }

//            Button {
//                id: btnToggle
//                x: 0
//                text: "Toggle"
//                anchors.top: parent.top
//                anchors.topMargin: 0
//                anchors.left: btnRemove.right
//                anchors.leftMargin: 0
//            }
            ListModel {
                id: rotationModel
            }
            ListModel {
                id: pathModel
            }
            DelegateModel{
                id:visualModel
                model: pathModel
                delegate: MouseArea {
                    id: delegateRoot
                    z:0
                    property int visualIndex: DelegateModel.itemsIndex
                    width: parent.width; height: 20
                    drag.target: icon

                    Rectangle {
                        id: icon
                        width: 20; height: 20
                        border.color: Qt.darker(color)
                        anchors.left: parent.left
                        color: "gray"
                        radius: 3

                        Drag.active: delegateRoot.drag.active
                        Drag.source: delegateRoot
                        Drag.hotSpot.x: width/2
                        Drag.hotSpot.y: height/2
                        anchors.verticalCenter: parent.verticalCenter
                        states: [
                            State {
                                when: icon.Drag.active
                                ParentChange {
                                    target: icon
                                    parent: lvPath
                                }

                                AnchorChanges {
                                    target: icon;
                                    anchors.horizontalCenter: undefined;
                                    anchors.verticalCenter: undefined
                                }
                            }
                        ]
                    }
                Rectangle{
                    anchors{
                        right:parent.right
                        left:icon.right
                        bottom:parent.bottom
                        top:parent.top
                    }
                    height: txt1.height

                    TextEdit {
                    id:txt1
                    anchors.fill:parent
                    text: value
                    property bool markup: false
                    color: "black"
                    //width: parent.width
                    textFormat: TextEdit.AutoText
                    //anchors.verticalCenter: parent.verticalCenter
                    onTextChanged:
                    {
                        if(!markup)
                        {
                            markup = true;
                            var pos = cursorPosition;
                            text = accessor.markup(txt1.textDocument);
                            cursorPosition = pos;
                            markup = false;
                        }
                    }
                    onCursorPositionChanged: lvPath.currentIndex=index

                 }
                }

                DropArea {
                    anchors { fill: parent; margins: 1 }
                    onEntered: visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
                }
                }
            }
        }


    }

    Button {
        id: btnAddPathToken
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 0
        iconSource: "qrc:/plus.png"
        onClicked: pathModel.insert(0,{value: "replace me"})

    }
    Button {
        id: btnDeletePathToken
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.left: btnAddPathToken.right
        anchors.leftMargin: 0
        iconSource: "qrc:/delete.png"
        onClicked: pathModel.remove(lvPath.currentIndex)

    }
}
