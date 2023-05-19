#ifndef PIPE_H
#define PIPE_H

#include <QWidget>
#include <QPainter>
#include <QPixmap>

class Pipe : public QWidget
{
    Q_OBJECT

public:
    Pipe(QWidget *parent = 0);
    ~Pipe();
    int getH1();
    int getH2();
    int getGap();
private:
    void setGapSize(int w);

protected:
    void paintEvent(QPaintEvent *);
    int H1,H2;
    int Gap;

};

#endif // PIPE_H
