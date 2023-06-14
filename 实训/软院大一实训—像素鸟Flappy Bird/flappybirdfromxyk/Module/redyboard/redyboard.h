#ifndef REDYBOARD_H
#define REDYBOARD_H

#include <QWidget>
#include <QtGui>
#include <QPainter>
#include <QPixmap>
#include <QLabel>

///预备状态提示板
class RedyBoard : public QWidget
{
    Q_OBJECT

public:
    RedyBoard(QWidget *parent = 0);
    ~RedyBoard();
protected:
    void paintEvent(QPaintEvent *);

private:
    QLabel *label;
    QLabel *versionLabel;	///版本信息
};

#endif // REDYBOARD_H
