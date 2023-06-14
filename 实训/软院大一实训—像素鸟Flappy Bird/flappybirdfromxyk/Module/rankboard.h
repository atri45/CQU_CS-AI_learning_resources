#ifndef RANKBOARD_H
#define RANKBOARD_H

#include <QWidget>
#include <QPainter>
#include <QPixmap>
#include <QLCDNumber>
#include "Module/fbnumLCD/number.h"

///计分板类 单纯的用于显示成绩
class RankBoard : public QWidget
{
    Q_OBJECT

public:
    RankBoard(QWidget *parent = 0);
    ~RankBoard();

    void setRank(int top,int top2,int top3);	///设置前三名分数

protected:
    void paintEvent(QPaintEvent *);

private:
    int top;            ///排行
    int top2;
    int top3;
    int number1=1;
    int number2=2;
    int number3=3;
    FBNumLCD *topLcd;		///排行显示LCD
    FBNumLCD *top2Lcd;
    FBNumLCD *top3Lcd;
    FBNumLCD *number1Lcd;
    FBNumLCD *number2Lcd;
    FBNumLCD *number3Lcd;
};


#endif // RANKBOARD_H
