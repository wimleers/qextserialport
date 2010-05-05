
#include "PortListener.h"
#include <QtDebug>

PortListener::PortListener(const QString & portName)
{
    this->port = new QextSerialPort(portName, QextSerialPort::EventDriven);
    port->setBaudRate(BAUD9600);
    port->setFlowControl(FLOW_OFF);
    port->setParity(PAR_NONE);
    port->setDataBits(DATA_8);
    port->setStopBits(STOP_1);

    if (port->open(QIODevice::ReadWrite) == true) {
        connect(port, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
        connect(port, SIGNAL(dsrChanged(bool)), this, SLOT(onDsrChanged(bool)));
        if (!(port->lineStatus() & LS_DSR))
            qDebug() << "warning: device is not turned on";
        qDebug() << "listening for data on" << port->portName();
    }
    else {
        qDebug() << "device failed to open:" << port->errorString();
    }
}


void PortListener::onReadyRead()
{
    static QByteArray bytes;
    int a = port->bytesAvailable();
    qDebug() << "bytes available:" << a;


    QByteArray newBytes;
    newBytes.resize(a);
    port->read(newBytes.data(), newBytes.size());
//    newBytes.resize(port->readLine(newBytes.data(), 1024));
    qDebug() << "bytes read:" << newBytes.size();
    qDebug() << "bytes:" << newBytes;


//    QByteArray newBytes = port->readAll();
//    qDebug() << newBytes;

    // merge.
    bytes.append(newBytes);
    qDebug() << "total:" << bytes;
}

/*
void PortListener::onReadyRead()
{
    QByteArray bytes;
    int a = port->bytesAvailable();
    bytes.resize(a);
    port->read(bytes.data(), bytes.size());
    qDebug() << "bytes read:" << bytes.size();
    qDebug() << "bytes:" << bytes;
}
*/
void PortListener::onDsrChanged(bool status)
{
    if (status)
        qDebug() << "device was turned on";
    else
        qDebug() << "device was turned off";
}
