#ifndef MYLABEL_H
#define MYLABEL_H
#pragma once
#include <qlabel.h>

class mylabel : public QLabel
{
public:
    mylabel(QWidget* parent = 0);
    ~mylabel();
public:
    //鼠标移动事件
    void mouseMoveEvent(QMouseEvent* event);
    //鼠标按下事件
    void mousePressEvent(QMouseEvent* event);
    //鼠标释放事件
    void mouseReleaseEvent(QMouseEvent* event);
};
#endif // MYLABEL_H
