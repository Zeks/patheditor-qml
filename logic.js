/* This script file handles the game logic */
//.pragma library
.import QtQuick.LocalStorage 2.0 as Sql
function saveItems() {
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

function loadItems() {
    var db = Sql.LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
    console.log(db)
    db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ROTATIONSETS(setname TEXT, setoperation NUMBER, setfolder TEXT)');
                    var rs = tx.executeSql('Select setname from ROTATIONSETS')
                    var groups = []
                    for(var i = 0; i < rs.rows.length; i++)
                    {
//                        rotationModel.append({"text": rs.rows.item(i).setname, "addValue":rs.rows.item(i).setoperation, "value":rs.rows.item(i).setfolder})
                        if(groups.indexOf(rs.rows.item(i).setname) == -1)
                            groups.push(rs.rows.item(i).setname);
                    }
                    cbCombinations.model = groups
                }
                )

}
function setGroup()
{
    console.log("slot fired")
    rotationModel.clear();
    var db = Sql.LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
    db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS ROTATIONSETS(setname TEXT, setoperation NUMBER, setfolder TEXT)');
                    var rs = tx.executeSql('Select * from ROTATIONSETS where setname = ?', cbCombinations.currentText)
                    for(var i = 0; i < rs.rows.length; i++)
                    {
                        console.log("adding ", rs.rows.item(i).setfolder)
                        rotationModel.append({"text": rs.rows.item(i).setname, "addValue":rs.rows.item(i).setoperation, "value":rs.rows.item(i).setfolder})
                    }
                }
                )
}

function cutPath(fullEnvironment){
    var rxStart = /\n(PATH=[\w\d\\\.:;\s\(\)-]+\n)/;
    var matchStart = rxStart.exec(fullEnvironment);
    return matchStart[0].replace(/;/g, ";\n");
}

function collectPATH()
{
    var env = accessor.get_environment().split(";");
    //console.log(env)
    for(var i in env)
    {
        console.log(i," " ,env[i])
        pathModel.append({"value": env[i]})
    }
}

function markUp()
{

}
