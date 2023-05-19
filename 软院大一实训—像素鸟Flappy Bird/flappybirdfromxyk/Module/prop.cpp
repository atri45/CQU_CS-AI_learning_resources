#include "prop.h"

Prop::Prop(QWidget *parent)
    : QWidget(parent)
{

}

Prop::~Prop()
{

}


void Prop::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing,true);
    QPixmap pix;
    pix.load(":/Images/prop.png");
    painter.drawPixmap(0,0,70,300,pix);
}


