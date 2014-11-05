import QtQuick 2.0

    Component {
        id: rotationDelegate

        Row
        {
            spacing: 2
            Rectangle {
                id: indicator
                height:20
                width: 10
                color: addValue ? "lightGreen" : "pink"
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        console.log("was",addValue)
                        model.addValue = addValue == 0 ? 1 : 0
                        rotationModel.setProperty(index, "addValue", addValue == 0 ? 1 : 0);
                        console.log("become",addValue)
                        parent.color = addValue == 1 ? "lightGreen" : "pink";
                        console.log("clicked")
                    }
                }
            }
            Rectangle {
                height:20
                width: 500
                TextEdit {
                    id:txt
                    x:5
                    z:1
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    text: value
                }
                Text {
                    id:txtHint
                    x:5
                    color: "lightGray"
                    anchors.verticalCenter: parent.verticalCenter
                    text: txt.text.trim().length==0 && !txt.focus ? "replace me" : ""
                    z:0
                }

            }
        }
    }

