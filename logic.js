/* This script file handles the game logic */
//.pragma library
.import QtQuick.LocalStorage 2.0 as Sql
function saveItems(rotationModel) {
    var db = Sql.LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
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
                                          [rotationModel.get(i).text, parseInt(rotationModel.get(i).addValue), rotationModel.get(i).value]);
                        }
                    }
                }
                )
}

function loadItems(rotationModel) {
    var db = Sql.LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
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

}
