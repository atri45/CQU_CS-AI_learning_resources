#include "mainwindow.h"
#include <QDesktopWidget>
#include <QMessageBox>
#include <ctime>
#include <iostream>
using namespace std;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    //构造函数创建了整个游戏界面和时间处理规则。对象的创建顺序就是最终的窗口层次顺序
    // this->setMaximumSize(380,500);
    //  this->setMinimumSize(380,500);
    qsrand(QTime(0, 0, 0).secsTo(QTime::currentTime()));
    this->setFixedSize(1100,800);	//锁定窗口的大小为380x500  效果等于上面两句
    this->setWindowIcon(QIcon(":/Images/bird1.png"));
    this->move((QApplication::desktop()->width()-this->width())/2,(QApplication::desktop()->height()-this->height())/2);	///这样做可以让窗口居中于屏幕显示，需要引入 QDesktopWidget

    for(int i=0;i<pipeCount;i++)	///创建管道对象
        pipe[i]=new Pipe(this);

    createPipe();
    pipeTimer =new QTimer(this);	//创建管道的Timer 以下的三个connect说明了其处理的动作不只一个
    connect(pipeTimer,SIGNAL(timeout()),this,SLOT(pipeAction()));
    connect(pipeTimer,SIGNAL(timeout()),this,SLOT(collisDete()));
    connect(pipeTimer,SIGNAL(timeout()),this,SLOT(scoreDete()));
    pipeTValue=8;

    birds=new Bird(this);
    birds->move(60,400);

    this->fpV[0]=-3;
    this->fpV[1]=-4;
    this->fpV[2]=-3;
    this->fpV[3]=-2;
    this->fpV[4]=-1;
    this->fpV[5]=-1;
    this->fpV[6]=-1;
    this->fpV[7]=0;
    this->fpV[8]=1;
    this->fpV[9]=1;
    this->fpV[10]=2;
    this->fpV[11]=2;
    this->fpV[12]=2;
    this->fpV[13]=3;
    this->fpV[14]=3;

    this->fpp=0;


    health=1;//初始生命值
    Flag=1;//难度选择标志

    //    QFont font ;
    //    font.setFamily("微软雅黑"); //字体
    //    font.setBold(true);  //加粗
    //    font.setItalic(true);    //斜体
    //    font.setStrikeOut(false); //删除线
    //    font.setUnderline(true);   //下划线
    //    font.setPointSize(23);   //字体大小
    //    ui->label->setFont(font);

        // 修改标签文本格式


    birdTimer=new QTimer(this);


    //birdTimer->start(20);
    birdV=0;
    gamemod=redy;		//游戏状态初始化为redy

    score=0;
    top=0;
    top2=0;
    top3=0;
    easytim=0;
    normaltim=0;
    loadTop();		//载入得分记录
    loadtim();

    scoreLCD=new FBNumLCD(this);	///计分板的实现
    scoreLCD->setShowHead(false);	///不显示多余位数
    scoreLCD->setValue(0);
    //scoreLCD->setFixedSize(28*4,36);
    scoreLCD->move(140,-100);

    scoreBoard=new ScoreBoard(this);
    scoreBoard->move(-350,100);
    scobTimer=new QTimer(this);
    connect(scobTimer,SIGNAL(timeout()),this,SLOT(scbAction()));

    rankboard=new RankBoard(this);
    rankboard->move(-350,100);
    rankTimer=new QTimer(this);
    connect(rankTimer,SIGNAL(timeout()),this,SLOT(rankAction()));

    thisGround=new Ground(this);
    thisGround->move(0,745);//改变道路的位置

    myredyBoard=new RedyBoard(this);
    myredyBoard->setFixedSize(380,500);
    myredyBoard->move(400,0);


    replay=new QLabel(this);		///这就是那个万恶的按钮 他的实现完全靠一个区域限制
    QPixmap pix1;
    pix1.load(":/Images/replay.png");		///所有的素材被写在资源文件中 编译时会被加到应用程序中去.调用资源文件只需要使用"："即可
    replay->setPixmap(pix1);
    replay->setFixedSize(140,80);
    replay->move(400,-400);



    pause=new QLabel(this);
    QPixmap pix2;
    pix2.load(":/Images/pause.png");
    pause->setPixmap(pix2);
    pause->setFixedSize(140,80);
    pause->move(800,-400);
    pause->installEventFilter(this);

    restart=new QLabel(this);
    QPixmap pix3;
    pix3.load(":/Images/restart.png");
    restart->setPixmap(pix3);
    restart->setFixedSize(250,100);
    restart->move(330,-400);
    restart->installEventFilter(this); // 安装事件过滤器

    begin=new QLabel(this);
    QPixmap pix4;
    pix4.load(":/Images/begin.png");
    begin->setPixmap(pix4);
    begin->setFixedSize(140,80);
    begin->move(120,-400);
    begin->installEventFilter(this);

    easy=new QLabel(this);
    QPixmap pix5;
    pix5.load(":/Images/easy.png");
    easy->setPixmap(pix5);
    easy->setFixedSize(183,157);
    easy->move(120,-400);
    easy->installEventFilter(this);

    normal=new QLabel(this);
    QPixmap pix6;
    pix6.load(":/Images/normal.png");
    normal->setPixmap(pix6);
    normal->setFixedSize(183,157);
    normal->move(120,-400);
    normal->installEventFilter(this);

    difficult=new QLabel(this);
    QPixmap pix7;
    pix7.load(":/Images/difficult.png");
    difficult->setPixmap(pix7);
    difficult->setFixedSize(183,157);
    difficult->move(120,-400);
    difficult->installEventFilter(this);

    prop=new QLabel(this);
    QPixmap pix8;
    pix8.load(":/Images/prop.png");
    prop->setPixmap(pix8);
    prop->setFixedSize(140,80);
    prop->move(120,-400);

    rank=new QLabel(this);
    QPixmap pix9;
    pix9.load(":/Images/rank.png");
    rank->setPixmap(pix9);
    rank->setFixedSize(140,80);
    rank->move(120,-400);
    rank->installEventFilter(this);

    easytime=new QLabel(this);
    easytime->setFixedSize(1000,80);
    easytime->setText("你已经累计5次在简单模式达到五分以上，建议你更换到普通模式游玩");
    easytime->move(100,-400);
    QPalette pe1;
    pe1.setColor(QPalette::WindowText,Qt::red);
    easytime->setPalette(pe1);
    QFont ft1;
    ft1.setPointSize(14);
    easytime->setFont(ft1);

    normaltime=new QLabel(this);
    normaltime->setFixedSize(1000,80);
    normaltime->setText("你已经累计5次在普通模式达到五分及以下，建议你更换到简单模式游玩");
    normaltime->move(100,-400);
    QPalette pe2;
    pe2.setColor(QPalette::WindowText,Qt::red);
    normaltime->setPalette(pe2);
    QFont ft2;
    ft2.setPointSize(14);
    normaltime->setFont(ft2);

    healthsmall1=new QLabel(this);
    QPixmap pix10;
    pix10.load(":/Images/health1.png");
    healthsmall1->setPixmap(pix10);
    healthsmall1->setFixedSize(140,80);
    healthsmall1->move(120,-400);

    healthsmall2=new QLabel(this);
    QPixmap pix11;
    pix11.load(":/Images/health3.png");
    healthsmall2->setPixmap(pix11);
    healthsmall2->setFixedSize(140,80);
    healthsmall2->move(120,-400);

    healthbig=new QLabel(this);
    QPixmap pix12;
    pix12.load(":/Images/health3.png");
    healthbig->setPixmap(pix12);
    healthbig->setFixedSize(140,80);
    healthbig->move(120,-400);






            //////sound
    playList=new QMediaPlaylist;
    QFileInfo info;

    playList->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_wing.mp3")));
    playList->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_point.mp3")));
    playList->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_die.mp3")));
    playList->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_hit.mp3")));
    playList->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_swooshing.mp3")));
    playList->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);

    playList_wing=new QMediaPlaylist;
    playList_wing->addMedia(QMediaContent(QUrl("qrc:/sounds/sfx_wing.mp3")));
    playList_wing->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
    playList_wing->setCurrentIndex(1);

    media=new QMediaPlayer;
    media->setVolume(100);
    media->setPlaylist(playList_wing);

    isFlag=-1;
    media2=new QMediaPlayer;
    media2->setPlaylist(playList);
    media2->setVolume(100);
    isHit=0;

    this->setWindowTitle("像素鸟 from xyk");		///设置标题
}

void MainWindow::createPipe()		//初始化管道。使其以一定次序排在地图之外
{
    int startx=500;		//第一个管道的位置
    pipeXgap=200;		///间距
    int pipR;			///会产生一个垂直位置的随机数
    qsrand(time(nullptr));		///qrand是qt的随机数函数 用法个c的rand一样  也需要初始化种子
    for(int i=0;i<pipeCount;i++)
    {
        pipR=qrand()%200;

        pipe[i]->move(startx+i*pipeXgap,-200+pipR);
        lastPipe=i;		//很重要 设置最后一根管道的编号 为后面的管道循环奠定基础
    }
}

MainWindow::~MainWindow()
{

}

void MainWindow::paintEvent(QPaintEvent *)		//重载的绘图事件。用来产生背景
{
    QPainter painter(this);
    QPixmap pixmap;
    pixmap.load(":/Images/bg.png");
    painter.drawPixmap(0,0,1100,800,pixmap);
}

void MainWindow::mousePressEvent(QMouseEvent *event)	//鼠标事件
{
    //左键或右键都能控制鸟的运动 并且为防止飞出地图 曾加了birds->pos().y()>0
    if((event->button()==Qt::LeftButton||event->button()==Qt::RightButton)&&birds->pos().y()>0)
    {
        if(gamemod==stop)		//如果游戏是停止 也就是失败了的状态下，通过计分板到位才能触发事件
        {
            if(isScobOk)
                if((event->pos().x()>=430&&event->pos().x()<=570)&&(event->pos().y()>=400&&event->pos().y()<=480))
                {
                    ///这里 当点击开始按钮 计分板会退出地图，鸟会归位，管道会归位，游戏状态改为redy，计分板会清空，路面会开始运动
                    gameRedy();
                    playSound(s_sw);

                }

        }
        else
        {
            mainAction();  //剩下的事件处理 因为是键盘鼠标通用 所以写在函数中
        }

    }
}



void MainWindow::keyPressEvent(QKeyEvent *event)
{
    //键盘处理 空格 上键的可操控
    if((event->key()==Qt::Key_Space||event->key()==Qt::Key_Up)&&birds->pos().y()>0)
    {
        mainAction();
    }
}

void MainWindow::mainAction()
{
    //通用事件处理
    if(gamemod==redy)	//如果是redy：开始游戏，鸟开始运动，管道开始运动
    {
        if(Flag==1)
        {   myredyBoard->close();
            difchoose();
        }
        else if(Flag==-1)
        {
        gameStart();
        timedata=8;
        birdTimer->start(timedata);
        pipeTimer->start(pipeTValue);
        fpp=0.0;
        birdV=fpV[int(fpp)];		///每次触发 鸟都会向上飞 也就是速度是负数。
        emit birds->fly();	///这个信号是Bird类的 用于让鸟抬头
        }
    }
    else if(gamemod==start)	//如果游戏是开始状态，只处理鸟的飞行姿态
    {
        fpp=0.0;
        birdV=fpV[int(fpp)];
        timedata=8;
        birdTimer->setInterval(timedata);
        emit birds->fly();
    }
    playWingSound();
}



void MainWindow::birdAction1()
{
    //bird的运动时间。这里是决定鸟运动数度 操作难度的地方。
    birds->move(birds->pos().x(),birds->pos().y()+birdV);

    if(fpp<14.0)
        fpp+=0.2;
    else
        fpp=14.0;
    birdV=fpV[int(fpp)];

    if(birds->pos().y()+birds->height()>=745)//与道路的碰撞检测
    {
        birds->move(birds->pos().x(),745-birds->height()+5);
        birdTimer->stop();
        isHit=true;
        playSound(s_hit);
        gameLose();
        birds->setRale(90);//如果碰撞到了，则计时器停止，鸟的飞行姿态大幅旋转
    }

}

void MainWindow::birdAction2()
{
    //bird的运动时间。这里是决定鸟运动数度 操作难度的地方。
    birds->move(birds->pos().x(),birds->pos().y()+1.5*birdV);

    if(fpp<14.0)
        fpp+=0.2;
    else
        fpp=14.0;
    birdV=fpV[int(fpp)];

    if(birds->pos().y()+birds->height()>=745)//与道路的碰撞检测
    {
        birds->move(birds->pos().x(),745-birds->height()+5);
        birdTimer->stop();
        isHit=true;
        playSound(s_hit);
        gameLose();
        birds->setRale(90);//如果碰撞到了，则计时器停止，鸟的飞行姿态大幅旋转
    }

}

void MainWindow::birdAction3()
{
    //bird的运动时间。这里是决定鸟运动数度 操作难度的地方。
    birds->move(birds->pos().x(),birds->pos().y()+2*birdV);

    if(fpp<14.0)
        fpp+=0.2;
    else
        fpp=14.0;
    birdV=fpV[int(fpp)];

    if(birds->pos().y()+birds->height()>=745)//与道路的碰撞检测
    {
        birds->move(birds->pos().x(),745-birds->height()+5);
        birdTimer->stop();
        isHit=true;
        playSound(s_hit);
        gameLose();
        birds->setRale(90);//如果碰撞到了，则计时器停止，鸟的飞行姿态大幅旋转
    }

}

void MainWindow::birdAction4()
{
    //bird的运动时间。这里是决定鸟运动数度 操作难度的地方。
    birds->move(birds->pos().x(),birds->pos().y()+0.7*birdV);

    if(fpp<14.0)
        fpp+=0.2;
    else
        fpp=14.0;
    birdV=fpV[int(fpp)];

    if(birds->pos().y()+birds->height()>=745)//与道路的碰撞检测
    {
        birds->move(birds->pos().x(),745-birds->height()+5);
        birdTimer->stop();
        isHit=true;
        playSound(s_hit);
        gameLose();
        birds->setRale(90);//如果碰撞到了，则计时器停止，鸟的飞行姿态大幅旋转
    }

}

void MainWindow::pipeAction()
{
    //管道的动画，重点是管道离开地图后将重新回到右侧并接替lastPipe的地位，产生一个新的高度
    int pipR;
    for(int i=0;i<pipeCount;i++)
    {
        pipe[i]->move(pipe[i]->pos().x()-1,pipe[i]->pos().y());//让管道向左移动
        healthbig->move(healthbig->pos().x()-0.001,healthbig->pos().y());
        prop->move(prop->pos().x()-0.001,prop->pos().y());
        if(prop->pos().x()<30)
        {
            prop->move(100,-400);
        }
        if(healthbig->pos().x()<30)
        {
            healthbig->move(100,-400);
        }
        if(pipe[i]->pos().x()<-100)
        {
            pipR=qrand()%200;
            pipe[i]->move(pipe[lastPipe]->pos().x()+pipeXgap,-200+pipR);
            lastPipe=i;
        }
    }
}

void MainWindow::collisDete()
{
    ///碰撞检测，判定是否优秀看这里。不注释
    int birdRx=birds->pos().x()+65;
    int birdDy=birds->pos().y()+100;
    if(birdRx>=prop->x()&&birds->pos().x()<=prop->pos().x()+prop->width()-10)
    {
        if(birds->y() <= prop->y()+30&& birds->y() >= prop->y()-30)
        {
            if(Flag2==1)
            {
                prop->move(100,-300);
                disconnect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction1()));
                connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction4()));
            }
            else if(Flag2==2)
            {
                prop->move(100,-300);
                disconnect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction2()));
                connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction1()));
            }
            else if(Flag2==3)
            {
                prop->move(100,-300);
                disconnect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction3()));
                connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction2()));
            }
        }
    }
    if(birds->pos().x()>=healthbig->x()&&birds->pos().x()<=healthbig->pos().x()+healthbig->width()-10)
    {
        if(birds->y() <= healthbig->y()+10&& birds->y() >= healthbig->y()-10)
        {
            health=2;
            healthbig->move(-100,-100);
            healthsmall2->move(70,20);
        }
    }
    int i;
    for(i=Flag3;i<pipeCount;i++)
    {
        if(birdRx>=pipe[i]->x()&&birds->pos().x()<=pipe[i]->pos().x()+pipe[i]->width()-10)
        {
            if(birds->y() <= (pipe[i]->y()+pipe[i]->getH1()) || birdDy >= (pipe[i]->y()+pipe[i]->getH1()+pipe[i]->getGap()))
            {
                Flag3=i+1;
                if(health==1)
                {
                    gameLose();
                    healthsmall1->move(-300,-200);
                }
                if(health==2)
                {
                    health=1;
                    healthsmall2->move(-300,-200);
                }

        }
        }
    }

}




void MainWindow::scoreDete()
{
    //分数检测，实质也是一个碰撞检测
    for(int i=0;i<pipeCount;i++)
    {
        if(birds->pos().x()+birds->width()>=pipe[i]->pos().x()+35&&birds->pos().x()+birds->width()<=pipe[i]->pos().x()+40&&cx)
        {
            playSound(s_point);
            this->score+=1;
            scoreLCD->setValue(score);
            //birds->fly();
            if(score>=1000)
            {
                scoreLCD->move(450+14*3,50);
            }
            else if(score>=100)
            {
                scoreLCD->move(450+14*2,50);
            }
            else if(score>=10)
            {
                scoreLCD->move(450+14,50);
            }
            cx=0;
        }

        if(birds->pos().x()>=pipe[i]->pos().x()+68&&birds->pos().x()<=pipe[i]->pos().x()+73)
            cx=1;
    }
}


void MainWindow::scbAction()
{
    ///失败时的记分牌动画
    scoreBoard->move(scoreBoard->pos().x()+1,scoreBoard->pos().y());
    if(scoreBoard->pos().x()>=400)
    {
        scoreBoard->move(400,scoreBoard->pos().y());
        scobTimer->stop();
        replay->move(490,400);
        restart->move(150,380);
        rank->move(800,400);
        isScobOk=1;
    }
}

void MainWindow::rankAction()
{
    rankboard->move(375,45);
}

void MainWindow::gameRedy()
{
    myredyBoard->show();
    scoreBoard->move(-350,100);
    birds->move(60,400);
    replay->move(120,-400);
    restart->move(80,-400);
    createPipe();
    birds->setRale(-50);
    gamemod=redy;
    scoreLCD->setValue(0);
    thisGround->play();
    birds->play();
    rank->move(500,-400);
    rankboard->move(-100,-300);
    rankTimer->stop();
    health=1;
    healthsmall2->move(-200,-200);
    Flag3=0;

}

void MainWindow::gameLose()
{
    //游戏失败时的处理：记分牌滑出，游戏状态失败，地面停止，鼠标键盘时间锁定，计算得分
    isScobOk=0;
    gamemod=stop;
    birds->stop();
    pipeTimer->stop();
    thisGround->stop();
    pause->move(120,-400);
    prop->move(120,-400);
    if(!isHit)
    {
        playSound(s_die);
    }
    else
        isHit=false;
    compare();
    top=numberline[0];
    top2=numberline[1];
    top3=numberline[2];
    saveTop();
    scoreBoard->setScore(score,top);
    rankboard->setRank(top,top2,top3);
    scobTimer->start(3);
    scoreLCD->move(550,-100);
    scodet();
}

void MainWindow::gameStart()
{
    //开始游戏的动作
    gamemod=start;
    myredyBoard->close();
    cx=1;
    score=0;
    scoreLCD->move(450,50);
    pause->move(1000,30);
    pause->raise();
    qsrand(time(NULL));
    int propX,propY;
    propX=qrand()%100+500;
    propY=qrand()%500+200;
    prop->move(propX,propY);
    int j=0;
    j=qrand()%2;
    int q=0;
    q=-2+qrand()%4;
    healthbig->move(500+j*2,400+q*100);
    healthsmall1->move(20,20);



}
void MainWindow::difchoose()
{
    easy->move(500,110);
    normal->move(500,310);
    difficult->move(500,510);
    timAction();
}

void MainWindow::saveTop()
{
    //保存记录，二进制保存，存储在top.d文件下。
    QFile file("top.d");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out<<this->top;
    out<<this->top2;
    out<<this->top3;
}


void MainWindow::loadTop()
{
    //读取记录 在构造函数里触发
    QFile file("top.d");
    if(file.open(QIODevice::ReadOnly))
    {
        QDataStream in(&file);
        in>>this->top;
        in>>this->top2;
        in>>this->top3;

    }
    else
        top=0;
}

void MainWindow::savetim()
{
    //保存记录，二进制保存，存储在top.d文件下。
    QFile file("tim.d");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out<<this->easytim;
    out<<this->normaltim;

}

void MainWindow::loadtim()
{
    //读取记录 在构造函数里触发
    QFile file("tim.d");
    if(file.open(QIODevice::ReadOnly))
    {
        QDataStream in(&file);
        in>>this->easytim;
        in>>this->normaltim;

    }

}

void MainWindow::timAction()
{
    if(easytim>5)
    {
       easytime->move(20,30);
    }
    if(normaltim>5)
    {
       normaltime->move(20,30);
    }
    if(easytim<=5)
    {
        easytime->move(500,-300);
    }
    if(normaltim<=5)
    {
        normaltime->move(500,-300);
    }
}

void MainWindow::scodet()
{
    if(Flag2==1)
    {
       normaltim=0;
       savetim();
    if(score>5)
    {
       easytim++;
       savetim();
    }

    }

    else if(Flag2==2)
    {
       easytim=0;
       savetim();
    if(score<=5)
    {
       normaltim++;
       savetim();
    }
    }
}

void MainWindow::playWingSound()
{
    media->stop();

    media->play();
}

void MainWindow::playSound(int flag)
{
    if(isFlag!=flag)
    {
        playList->setCurrentIndex(flag);
    }
    media2->play();
    media2->setVolume(100);
}

void MainWindow::compare()
{
    numberline[0]=top;
    numberline[1]=top2;
    numberline[2]=top3;
    numberline[3]=score;
    for (int i = 0; i < 3; i++){
       for (int j = 0; j < 3 - i; j++){
          if (numberline[j] < numberline[j + 1])
              swap(numberline[j], numberline[j + 1]);
       }
    }
}

bool MainWindow::eventFilter(QObject *obj, QEvent *event)
{
    //设置重玩功能
    if (obj == restart)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                 gameRedy();
                 mainAction();
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }
    //设置暂停功能
    if (obj == pause)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                birds->stop();
                birdTimer->stop();
                pipeTimer->stop();
                begin->move(1000,30);
                pause->move(1000,-480);
                thisGround->stop();
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }
    if (obj == begin)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                birds->play();
                birdTimer->start(8);
                pipeTimer->start(pipeTValue);
                pause->move(1000,30);
                begin->move(1000,-480);
                thisGround->play();
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }
    //设置难度选择功能
    if (obj == easy)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                disconnect(birdTimer,nullptr,nullptr,nullptr);
                connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction1()));
                gameRedy();
                Flag=-1;
                mainAction();
                easy->move(-300,10);
                normal->move(-300,150);
                difficult->move(-300,290);
                Flag=1;
                Flag2=1;
                easytime->move(500,-300);
                normaltime->move(500,-300);
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }

    if (obj == normal)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                disconnect(birdTimer,nullptr,nullptr,nullptr);
                connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction2()));
                gameRedy();
                Flag=-1;
                mainAction();
                easy->move(-300,10);
                normal->move(-300,150);
                difficult->move(-300,290);
                Flag=1;
                Flag2=2;
                easytime->move(500,-300);
                normaltime->move(500,-300);
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }

    if (obj == difficult)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                 disconnect(birdTimer,nullptr,nullptr,nullptr);
                 connect(birdTimer,SIGNAL(timeout()),this,SLOT(birdAction3()));
                 gameRedy();
                 Flag=-1;
                 mainAction();
                 easy->move(-300,10);
                 normal->move(-300,150);
                 difficult->move(-300,290);
                 Flag=1;
                 Flag2=3;
                 easytime->move(500,-300);
                 normaltime->move(500,-300);
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }

    if (obj == rank)//指定某个QLabel
     {
         if (event->type() == QEvent::MouseButtonPress) //鼠标点击
         {
             QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event); // 事件转换

             if(mouseEvent->button() == Qt::LeftButton)
             {
                 rankTimer->start(3);
                 scoreBoard->move(100,-300);
                 return true;
             }
             else
             {
                 return false;
             }
         }
         else
         {
             return false;
         }
     }

    else
     {
         // pass the event on to the parent class
         return QWidget::eventFilter(obj, event);
     }
}
