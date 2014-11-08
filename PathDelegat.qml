import QtQuick 2.0
import QtQml.Models 2.1
Component {
    id: pathDelegate
    TextEdit {
        //anchors.fill: parent
        property int visualIndex: DelegateModel.itemsIndex
        y: 2
        anchors{
            left:parent.left
        }
        id:txt1
        text: value
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
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: width/2
        Drag.hotSpot.y: height/2

        MouseArea {
            drag.target: txt1
            id: mouseArea
            anchors.fill: parent
        }
        DropArea {
            anchors { fill: pathDelegate;}
            onEntered: {
                console.log("entered droparea")
                visualModel.items.move(drag.source.visualIndex, pathDelegate.visualIndex)
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

