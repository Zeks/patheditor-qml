import QtQuick 2.0
import QtQml.Models 2.1
Component {
    id: pathDelegate
    TextEdit {
        //anchors.fill: parent
        property int visualIndex: DelegateModel.itemsIndex
        y: 2
        x:5
        id:txt1
        text: value
        property string colorKey
        property bool markup: false
        color: "black"
        width: parent.width
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
        Drag.keys: [ colorKey ]
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: 0
        Drag.hotSpot.y: 0

        MouseArea {
            DropArea {
                anchors { fill: parent; margins: 1 }
                onEntered: visualModel.items.move(drag.source.visualIndex, pathDelegate.visualIndex)
            }
            drag.target: txt1
            id: mouseArea
            anchors.fill: parent
            onReleased: parent = tile.Drag.target !== null ? tile.Drag.target : lvPath
            Rectangle {
                id: tile
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                color: "transparent"


                states: State {
                    when: mouseArea.drag.active
                    ParentChange { target: txt1; parent: lvPath }
                    AnchorChanges { target: txt1; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
                }

            }
        }
        states: [
            State {
                when: txt1.Drag.active
                ParentChange {
                    target: txt1
                    parent: lvPath
                }

                AnchorChanges {
                    target: txt1;
                    anchors.horizontalCenter: undefined;
                    anchors.verticalCenter: undefined
                }
            }
        ]
    }

}

