#include "scoreboard.h"

ScoreBoard::ScoreBoard(QWidget *parent)
    : QWidget(parent)
{
    this->medal[0]=":/Images/medal0.png";
    this->medal[1]=":/Images/medal1.png";
    this->medal[2]=":/Images/medal2.png";
    this->setFixedSize(300,300);

    scoreLcd=new FBNumLCD(this);
    scoreLcd->setShowHead(false);
    scoreLcd->setFixedSize(60,20);
    scoreLcd->move(210,158);

    topLcd=new FBNumLCD(this);
    topLcd->setShowHead(false);
    topLcd->setFixedSize(60,20);
    topLcd->move(210,215);

    this->setScore(0,0);
}

ScoreBoard::~ScoreBoard()
{

}



void ScoreBoard::setScore(int score, int top)
{
    this->Score=score;
    this->top=top;
    update();
    scoreLcd->setValue(Score);
    topLcd->setValue(this->top);
}

void ScoreBoard::paintEvent(QPaintEvent *)
{
	///绘制计分板，并依据得分选择奖牌。
    QPainter painter(this);
    QPixmap pix;
    painter.setWindow(-150,0,300,300);
    pix.load(":/Images/gameover.png");
    painter.drawPixmap(-128,0,256,60,pix);

    pix.load(":/Images/scoreboard.png");
    painter.drawPixmap(-150,110,300,155,pix);

    switch (Score/10) {
    case 0:
        pix.load("");
        break;
    case 1:
        pix.load(medal[2]);
        break;
    case 2:
        pix.load(medal[1]);
        break;
    default:
        pix.load(medal[0]);
    }
    painter.drawPixmap(-115,160,60,60,pix);
}
