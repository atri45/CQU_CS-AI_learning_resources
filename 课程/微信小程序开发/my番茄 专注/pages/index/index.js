// index.js
// 获取应用实例
const app = getApp()
import {formatTime} from '../utils/util'

Page({

  data: {
    gridList:[
      {id:1, name:'爱情', icon:"/image/love.png"},
      {id:2, name:'电影', icon:"/image/movie.png"},
      {id:3, name:'发呆', icon:"/image/daze.png"},
      {id:4, name:'工作', icon:"/image/workbag.png"},
      {id:5, name:'跑步', icon:"/image/run.png"},
      {id:6, name:'听歌', icon:"/image/music.png"},
      {id:7, name:'写作', icon:"/image/writing.png"},
      {id:8, name:'学习', icon:"/image/learning.png"},
      {id:9, name:'阅读', icon:"/image/reading.png"}],
      time:'5',
      clockShow: false,
      mTime:300000,
      rate:"",
      timeStr:"05:00",
      timer:null,
      cateActive: "0",
      clockHeight: 0,
      indexHeight: 0,
      okShow:false,
      pauseShow:true,
      continueCancleShow:false
    },
  // 事件处理函数
  bindViewTap() {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad() {
    var res=wx.getSystemInfoSync();
    var rate=750 / res.windowWidth
    this.setData({
      rate:rate,
      clockHeight:rate*res.windowHeight,
    })
  },
  slideChange:function(e){
    this.setData({
      time:e.detail.value,
    })
  },
  getUserProfile(e) {
    // 推荐使用wx.getUserProfile获取用户信息，开发者每次通过该接口获取用户个人信息均需用户确认，开发者妥善保管用户快速填写的头像昵称，避免重复弹窗
    wx.getUserProfile({
      desc: '展示用户信息', // 声明获取用户个人信息后的用途，后续会展示在弹窗中，请谨慎填写
      success: (res) => {
        console.log(res)
        this.setData({
          userInfo: res.userInfo,
          hasUserInfo: true
        })
      }
    })
  },
  start: function(){
    this.setData({
        clockShow:true,
        mTime:this.data.time*60*1000,
        timeStr:parseInt(this.data.time) >= 10 ? this.data.time+ ":00" :"0" +this.data.time + ":00"
    })
    this.drawBg();
    this.drawActive();
},

  getUserInfo(e) {
    // 不推荐使用getUserInfo获取用户信息，预计自2021年4月13日起，getUserInfo将不再弹出弹窗，并直接返回匿名的用户个人信息
    console.log(e)
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },
  clickCate:function(e){
    this.setData({
      cateActive: e.currentTarget.dataset.index
    })
  },
  drawBg: function() {
    const lineWidth = 9 / this.data.rate;//px
    const query = wx.createSelectorQuery()
    query.select('#progress_bg')
        .fields({ node:true, size: true})
        .exec((res) => {
           const canvas = res[0].node
           const ctx = canvas.getContext('2d')
           const dpr = wx.getSystemInfoSync().pixelRatio
           canvas.width = res[0].width * dpr
           canvas.height = res[0].height * dpr
           ctx.scale(dpr, dpr)
           ctx.lineCap='round'
           ctx.lineWidth="lineWidth"
           ctx.beginPath()
           ctx.arc(400/this.data.rate/2,400/this.data.rate/2,400/this.data.rate/2-2*lineWidth,0,2*Math.PI,false)
           ctx.strokeStyle ="#ffffff"
           ctx.stroke()
        })
},
drawActive: function() {
   var _this = this;
   var timer = setInterval(function (){
       var angle = 1.5 + 2*(_this.data.time*60*1000 - _this.data.mTime)/(_this.data.time*60*1000);
       var currentTime = _this.data.mTime - 100
       _this.setData({
           mTime:currentTime
       });
       if(angle < 3.5){
           if(currentTime % 1000 == 0){
               var timeStr1 = currentTime / 1000;//s
               var timeStr2 = parseInt(timeStr1 / 60); //m
               var timeStr3 = (timeStr1 - timeStr2 * 60) >= 10 ? (timeStr1 - timeStr2 * 60) :"0" +  (timeStr1 - timeStr2 * 60);
               var timeStr2 = timeStr2 >= 10 ? timeStr2:"0" + timeStr2;
               _this.setData({
                timeStr:timeStr2 + ":" + timeStr3
               })
             };
            const lineWidth = 9 / _this.data.rate;//px
            const query = wx.createSelectorQuery()
            query.select('#progress_active')
            .fields({ node:true, size: true})
            .exec((res) => {
                const canvas = res[0].node
                const ctx = canvas.getContext('2d')

                const dpr = wx.getSystemInfoSync().pixelRatio
                canvas.width = res[0].width * dpr
                canvas.height = res[0].height * dpr
                ctx.scale(dpr, dpr)
                ctx.lineCap='round'
                ctx.lineWidth="lineWidth"
                ctx.beginPath()
                ctx.arc(400/ _this.data.rate/2,400/_this.data.rate/2,400/_this.data.rate/2-2*lineWidth,1.5*Math.PI,angle*Math.PI,false)
                ctx.strokeStyle ="#ff6347"
                ctx.stroke()
                
           })
       } else {
        var logs = wx.getStorageSync("logs") || [];
        _this.setData({
         timeStr:"00:00",
         pauseShow: false,
         continueCancleShow: false,
         okShow: true,
      });
        logs.unshift({
            date: formatTime(new Date),
            cate: _this.data.cateActive,
            time: _this.data.time
        });
        wx.setStorageSync('logs', logs);
        
     clearInterval(timer); 
       }  
   },100);
   _this.setData({
       timer :timer
   })
},
pause:function() {
    clearInterval(this.data.timer);
    this.setData({
        pauseShow: false,
        continueCancleShow: true,
        okShow: false
    }) 
},

continue:function() {
    this.drawActive();
    this.setData({
        pauseShow: true,
        continueCancleShow: false,
        okShow: false
    })
},

cancle:function() {
    clearInterval(this.data.timer);
    this.setData({
        clockShow:false,
        pauseShow: true,          
        continueCancleShow: false,
        okShow: false
    })
},

ok:function() {
    clearInterval(this.data.timer);
    this.setData({
        clockShow:false,
        pauseShow: true,
        continueCancleShow: false,
        okShow: false
    })
}
})
