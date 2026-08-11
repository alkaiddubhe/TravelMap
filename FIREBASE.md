# Firebase 实时同步配置

免费的 Spark 方案，用谷歌账号登录即可，**不需要信用卡**。全程约 5 分钟。

## 1. 创建项目

1. 打开 https://console.firebase.google.com/
2. 用谷歌账号登录
3. 点「创建项目」，名字随便取（比如 `travel-map`）
4. 问是否启用 Google Analytics 时选「不启用」，省事
5. 等半分钟创建完成

## 2. 创建实时数据库

1. 左侧菜单找「构建」→「Realtime Database」
   （注意别选 Firestore，两个不一样，本项目用的是 Realtime Database）
2. 点「创建数据库」
3. 位置选 **Singapore (asia-southeast1)**，国内访问相对快些
4. 安全规则选「**以测试模式启动**」，然后点启用

## 3. 拿配置信息

1. 点左上角齿轮 →「项目设置」
2. 拉到最下面「你的应用」，点 `</>`（Web）图标
3. 应用别名随便填，**不要**勾选 Firebase Hosting，点「注册应用」
4. 会显示一段 `const firebaseConfig = {...}`，把大括号里的内容抄下来

## 4. 填进 firebase-config.js

打开 `firebase-config.js`，把第 3 步拿到的值替换进去：

```js
window.FIREBASE_CONFIG = {
  apiKey: "AIzaSy...",                    // 你的
  authDomain: "travel-map-xxx.firebaseapp.com",
  databaseURL: "https://travel-map-xxx-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "travel-map-xxx",
  appId: "1:123:web:abc"
};
```

**`databaseURL` 是最关键的一项**。如果第 3 步的配置里没有它，去「Realtime Database」页面顶部复制那个 `https://xxx.firebasedatabase.app` 地址。

## 5. 打开网页

刷新 `index.html`，顶部状态栏应该显示绿灯 +「已连接 · 房间「default」」，并提示你输入名字。

四个人各自打开同一个网址就行，谁点了什么大家都会实时看到。

---

## 关于安全规则

测试模式的规则是**任何人只要知道数据库地址就能读写**，且 30 天后自动失效。
对四个人内部用的地图，这个风险可以接受，但两点要注意：

- 30 天后会自动锁死，届时地图会变成只读。到期前去「Realtime Database」→「规则」，把日期条件改掉：

```json
{
  "rules": {
    "rooms": {
      ".read": true,
      ".write": true
    }
  }
}
```

- `apiKey` 会暴露在网页源码里，这是 Firebase 的正常设计（它不是密钥，只是项目标识）。真正管访问的是上面这个规则。

如果之后想收紧，可以启用匿名登录并把规则改成 `".write": "auth != null"`，需要的话我再帮你改。

---

## 房间

同一个房间的人共用一张地图。默认房间叫 `default`。

想再开一张互不干扰的图，在网址后面加参数：

```
index.html?room=2026暑假
```

或者直接改 `firebase-config.js` 里的 `window.ROOM_ID`。

---

## 没配置会怎样

不填配置也能正常用，只是退回单机模式：数据存在本地浏览器，顶部显示「单机模式」，
「分享链接」会生成带标记快照的长网址（别人打开能看到你的标记，但不能实时协作）。
