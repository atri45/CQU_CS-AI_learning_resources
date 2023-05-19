#ifndef GROUND_H
#define GROUND_H

#include <QWidget>
#include <QPainter>
#include <QPixmap>
#include <QTimer>

class Ground : public QWidget
{
    Q_OBJECT

public:
    Ground(QWidget *parent = 0);
    ~Ground();
    void stop();
    void play();
    int sx,sy;

protected:
    void paintEvent(QPaintEvent *);

private slots:
    void groundM();

private:
    QTimer *timer;

};

#endif // GROUND_H
