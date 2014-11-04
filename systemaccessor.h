#ifndef SYSTEMACCESSOR_H
#define SYSTEMACCESSOR_H
#include <QObject>
#include <QProcess>
#include <QSettings>
#include <QDir>
#include <QDebug>
#include <QQuickTextDocument>
//#include <

class SystemAccessor : public QObject{
    Q_OBJECT
public:
    explicit SystemAccessor (QObject* parent = 0) : QObject(parent) {}
    Q_INVOKABLE QString get_environment()
    {
        QSettings excelSettings("HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment", QSettings::NativeFormat);
        loadedFolders = excelSettings.value("PATH").toString().split(";");
        return excelSettings.value("PATH").toString() ;//QProcess::systemEnvironment();
    }

    Q_INVOKABLE QString markup(QQuickTextDocument* doc)
    {
        QString text = doc->textDocument()->toPlainText();
        qDebug() << "Passed : " << text;
        text=text.replace(";", "\n");
        QStringList folders = text.split(QRegExp("\n"));
        QString result;
        QString failed = "<font color='red'>%1</font><br>";
        QString newFolders = "<font color='green'>%1</font><br>";
        for(QString folder : folders)
        {
            if(folder[0] != '%' && !QDir(folder.replace(";","")).exists())
            {
                result+=failed.arg(folder);
                continue;
            }
            if(!loadedFolders.contains(folder))
            {
                result+=newFolders.arg(folder);
                continue;
            }
            result+=folder+"<br>";
        }
        return result;
    }

    Q_INVOKABLE void set_environment(QQuickTextDocument* doc)
    {
        QString value = doc->textDocument()->toPlainText().trimmed().replace("\n", ";");
        QSettings excelSettings("HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment", QSettings::NativeFormat);
        qDebug() << "writing: " << value;
        excelSettings.setValue("PATH", value);
        excelSettings.sync();
    }
    QList<QVariantMap> GetRotations()
    {
        QSettings settings("rotations.ini", QSettings::IniFormat);
        return  QList<QVariantMap>();
    }

    void SetRotations(QList<QVariantMap> rotations)
    {
        QSettings settings("rotations.ini", QSettings::IniFormat);
    }

    QStringList loadedFolders;
};
#endif // SYSTEMACCESSOR_H
