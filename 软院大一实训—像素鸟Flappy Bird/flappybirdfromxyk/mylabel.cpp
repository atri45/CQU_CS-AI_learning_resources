#include "mylabel.h"
#include"QMouseEvent"


mylabel::mylabel(QWidget* parent) :QLabel(parent)
{

}
mylabel::~mylabel()
{

}
//鼠标移动显示坐标
void mylabel::mouseMoveEvent(QMouseEvent* event)
{
    if (event->buttons() & Qt::LeftButton)  //进行的按位与（只有左键点击移动才满足）
    {
        QString str = QString("Move:(X:%1,Y:%2)").arg(event->x()).arg(event->y());
         this->setText(str);

    }

}
//鼠标按下显示“ok，mouse is press”
void mylabel::mousePressEvent(QMouseEvent* event)
{
    setText("Ok, mouse is press");

}
//鼠标释放清除显示
void mylabel::mouseReleaseEvent(QMouseEvent* event)
{
    setText(" ");
}
