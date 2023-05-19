#ifndef PROP_H
#define PROP_H

#include <QWidget>
#include <QPainter>
#include <QPixmap>

class Prop : public QWidget
{
    Q_OBJECT

public:
    Prop(QWidget *parent = 0);
    ~Prop();

private:


protected:
    void paintEvent(QPaintEvent *);


};



#endif // PROP_H
