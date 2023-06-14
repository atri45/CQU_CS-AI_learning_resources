#ifndef FBNUMLCD_H
#define FBNUMLCD_H

#include <QWidget>
#include <QtGui>
#include <QPainter>
#include <QPixmap>


///这是一个flappybird的字体方式显示数字的类
class FBNumLCD : public QWidget
{
    Q_OBJECT

public:
    FBNumLCD(QWidget *parent = 0);
    ~FBNumLCD();

    void setValue(int v);	///设置值
    int value() const;		///读取值
    void setShowHead(bool s);	///设置是否显示前缀0位

protected:
    void paintEvent(QPaintEvent *);

private:
    void runtime();		///执行转换操作

private:
    QString lcdList[11];
    int data;
    enum{MaxSize=4};
    int num[MaxSize];
    int len;
    bool showHead;
};

#endif // FBNUMLCD_H
