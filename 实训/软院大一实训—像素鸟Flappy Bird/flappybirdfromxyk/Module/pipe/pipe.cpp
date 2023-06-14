#include "pipe.h"

Pipe::Pipe(QWidget *parent)
    : QWidget(parent)
{
    Gap=qrand()%200+200;
    setGapSize(Gap);
}

Pipe::~Pipe()
{

}


void Pipe::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing,true);
    QPixmap pix;
    pix.load(":/Images/pipe5.png");
    painter.drawPixmap(0,0,70,350,pix);
    pix.load(":/Images/pipe6.png");
    painter.drawPixmap(0,300+Gap,70,450,pix);
}

int Pipe::getH1()
{
    return 350;
}

int Pipe::getH2()
{
    return 250;
}

int Pipe::getGap()
{
    return Gap;
}


void Pipe::setGapSize(int w)
{
    this->setFixedSize(70,w+700);
    this->Gap=w;
    update();
}
