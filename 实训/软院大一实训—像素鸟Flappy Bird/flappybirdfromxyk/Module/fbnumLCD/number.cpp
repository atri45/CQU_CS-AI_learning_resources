#include "number.h"
#include <cstring>

FBNumLCD::FBNumLCD(QWidget *parent)
    : QWidget(parent)
{
    this->data=0;
    this->len=1;
    memset(num,0,sizeof(num));

    QString str;
    for(int i=0;i<10;i++)
    {
        str.clear();
        str=tr(":/Images/scoreNumber/%1.png").arg(i);
        lcdList[i]=str;
    }

    this->setShowHead(true);
    this->setValue(0);

    this->setGeometry(100,100,28*MaxSize,36);
}

FBNumLCD::~FBNumLCD()
{

}

void FBNumLCD::setShowHead(bool s)
{
    this->showHead=s;
}

void FBNumLCD::setValue(int v)
{
    data=v;
    runtime();
}

int FBNumLCD::value() const
{
    return data;
}

void FBNumLCD::runtime()
{
    memset(num,0,sizeof(num));

    int i=0;
    int t=this->data;
    while(t>0&&i<MaxSize)
    {
        num[i]=t%10;
        t/=10;
        i++;
    }
    len=i;
    update();
}

void FBNumLCD::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;

    int Minw=28*MaxSize;
    painter.setWindow(0,0,Minw,36);

    int k=0;
    for(int i=Minw-25;i>0;i-=28)
    {
        pix.load(lcdList[num[k]]);
        painter.drawPixmap(i,0,24,36,pix);
        k++;
        if(k>=len&&!showHead)
            break;
    }
}
