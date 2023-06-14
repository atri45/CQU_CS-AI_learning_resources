#include "bird.h"

Bird::Bird(QWidget *parent)
    : QWidget(parent)
{
    setMaximumSize(70,80);
    setMinimumSize(70,80);
    co=0;
    timer=new QTimer(this);

    src[0]=":/Images/4.png";
    src[1]=":/Images/5.png";
    this->rale=-31;
    connect(timer,SIGNAL(timeout()),this,SLOT(update()));
    connect(this,SIGNAL(fly()),this,SLOT(updateRale()));
    timer->start(200);

}

Bird::~Bird()
{

}

void Bird::play()
{
    timer->start(200);
}

void Bird::stop()
{
    timer->stop();
}

void Bird::paintEvent(QPaintEvent *)
{

    ///需要注意的只有这里：鸟的旋转实际上不是鸟在旋转，而是整个窗体世界在旋转，相当于旋转了画布再把图画上去，看起来不就是鸟在旋转了吗
    QPainter painter(this);
    QPixmap pix;

    painter.setWindow(-20,-20,40,40);	///设置画布等于偏移中心坐标，使绝对坐标中心轴为20,0
    pix.load(src[co]);
    if(zt==1)
    {
        painter.rotate(ztr);
        ztr-=10;
        if(ztr<=30)
        {
            zt=0;
        }
    }
    else
    {
        if(rale>=-30&&rale<=90)
        {
            painter.rotate(rale);
            if(rale<10)
            {
                rale=0.01*x*x-30;
                x+=1;
            }
            else
            {
                rale+=2;
            }
        }
        else if(rale>=90)
        {
            rale=90;
            painter.rotate(rale);
        }
        else if(rale<-30)
        {
            painter.rotate(0);
        }
    }
    co++;
    if(co>=2)
        co=0;
    painter.rotate(0);
    painter.drawPixmap(-20,-20,40,40,pix);
}

void Bird::updateRale()
{
    ztr=rale;
    this->rale=-30;
    x=0;
    zt=1;

}

void Bird::setRale(int rale)
{
    this->rale=rale;
}
