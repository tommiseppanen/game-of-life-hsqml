import QtQuick 2.3

Rectangle {
	width: 400
	height: 450
	color: "black"
	
	function getCellOpacity(cellAlive, mouseInCell) {
		if (cellAlive)
			return 1.0;
		
		if (mouseInCell)
			return 0.5;
		
		return 0.0;
	}
	
	Timer {
		id: gameTimer
        interval: 200; running: false; repeat: true
        onTriggered: nextStep()
     }
	
	Column {
		spacing: 2
		Row {
			spacing: 2
			Rectangle {
				color: startButton.containsMouse ? "#178FC7" : "#1373A1"
				radius: 20.0
                width: 199; height: 50
                Text {
					id: playButtonText
					anchors.centerIn: parent
                    font.pointSize: 24; text: "Start"
					color: "white"
				} 
				MouseArea {
					id: startButton
					anchors.fill: parent
					hoverEnabled: true
					onClicked: {
						gameTimer.running = !gameTimer.running
						playButtonText.text = gameTimer.running ? "Stop" : "Start"
					}
				}	
			}
			
			Rectangle { 
				color: resetButton.containsMouse ? "#178FC7" : "#1373A1"
				radius: 20.0
                width: 199; height: 50
                Text {
					anchors.centerIn: parent
					font.pointSize: 24; text: "Reset"
					color: "white"
				} 
				MouseArea {
					id: resetButton
					hoverEnabled: true
					anchors.fill: parent
					onClicked: reset()
				}
			}
		}
		
		Rectangle {
			 width: 400; height: 400; color: "black"

			 Grid {
				 x: 0; y: 0
				 rows: 20; columns: 20; spacing: 1

				 Repeater { model: 400
							Rectangle { width: 19; height: 19
										color: "#1aa1e1"
										opacity: getCellOpacity(result[index], cell.containsMouse) 
										
										MouseArea {
											id: cell
											hoverEnabled: true
											anchors.fill: parent
											onClicked: {
												var temp = result;
												temp[index] = !temp[index];
												result = temp;
											}
										}

										Text { text: ""
											   color: "white"
											   font.pointSize: 10
											   anchors.centerIn: parent } }
				}
			}
		}

	}
}