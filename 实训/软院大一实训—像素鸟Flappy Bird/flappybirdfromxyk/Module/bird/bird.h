#ifndef BIRD_H
#define BIRD_H

#include <QWidget>
#include <QPainter>
#include <QPixmap>
#include <QTimer>
#include <math.h>

///这是bird的类
class Bird : public QWidget
{
    Q_OBJECT
///继承于QWidget 需要使用该宏来处理
public:
    Bird(QWidget *parent = 0);
    ~Bird();
    void setRale(int rale);	///设置旋转角度。
    void play();
    void stop();

signals:
    void fly();		///触发抬头动作的信号

private slots:
    void updateRale();		///更新旋转角度。

protected:
    void paintEvent(QPaintEvent *);		///绘图事件
private:
    double rale;		///角度参数
    double x;			///旋转角度的单位偏移
    int zt;		///一个30度夹角的标识，用于为鸟旋转提供更好的状态处理
    double ztr;
    int co;		///鸟的动作由三张图片组成，这是序号
    QTimer *timer;
    QString src[2];	///位图的绝对路径
};

#endif // BIRD_H
