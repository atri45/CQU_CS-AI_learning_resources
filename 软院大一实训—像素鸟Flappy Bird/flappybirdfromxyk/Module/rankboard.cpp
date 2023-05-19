#include "rankboard.h"

RankBoard::RankBoard(QWidget *parent)
    : QWidget(parent)
{
    this->setFixedSize(450,500);

    topLcd=new FBNumLCD(this);
    topLcd->setShowHead(false);
    topLcd->setFixedSize(60,20);
    topLcd->move(210,155);
    topLcd->raise();

    top2Lcd=new FBNumLCD(this);
    top2Lcd->setShowHead(false);
    top2Lcd->setFixedSize(60,20);
    top2Lcd->move(210,185);

    top3Lcd=new FBNumLCD(this);
    top3Lcd->setShowHead(false);
    top3Lcd->setFixedSize(60,20);
    top3Lcd->move(210,215);

    number1Lcd=new FBNumLCD(this);
    number1Lcd->setShowHead(false);
    number1Lcd->setFixedSize(60,20);
    number1Lcd->move(50,155);

    number2Lcd=new FBNumLCD(this);
    number2Lcd->setShowHead(false);
    number2Lcd->setFixedSize(60,20);
    number2Lcd->move(50,185);

    number3Lcd=new FBNumLCD(this);
    number3Lcd->setShowHead(false);
    number3Lcd->setFixedSize(60,20);
    number3Lcd->move(50,215);

    this->setRank(0,0,0);
}

RankBoard::~RankBoard()
{

}

void RankBoard::setRank(int top, int top2, int top3)
{
    this->top=top;
    this->top2=top2;
    this->top3=top3;
    update();
    topLcd->setValue(this->top);
    top2Lcd->setValue(this->top2);
    top3Lcd->setValue(this->top3);
    number1Lcd->setValue(number1);
    number2Lcd->setValue(number2);
    number3Lcd->setValue(number3);

}

void RankBoard::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;
    painter.setWindow(-150,0,500,500);
    pix.load(":/Images/rankboard.png");
    painter.drawPixmap(-150,100,390,195,pix);
}
