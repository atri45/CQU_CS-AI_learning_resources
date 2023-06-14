#include "redyboard.h"

RedyBoard::RedyBoard(QWidget *parent)
    : QWidget(parent)
{
    this->setGeometry(0,0,480,500);
    label=new QLabel(tr("<font color=red>控制：鼠标左右键 or 空格 or 上键</font>"),this);
    label->move(80,480);
}

RedyBoard::~RedyBoard()
{

}

void RedyBoard::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;
    painter.setWindow(0,0,380,500);
    pix.load(":/Images/ready.png");
    painter.drawPixmap(0,0,380,500,pix);
}
