import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商店2"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.selectView(Icons.message, '发起群聊', 'A'),
              this.selectView(Icons.message, '扫一扫', 'B'),
              this.selectView(Icons.message, '钱包', 'C'),
            ],
            onSelected: (String action) {
              // 点击选项的时候
              switch (action) {
                case 'A':
                  break;
                case 'B':
                  break;
                case 'C':
                  break;
              }
            },
          )
        ],
      ),
      body: buildBody(context),
      floatingActionButton: showToTop
          ? FloatingActionButton(
              onPressed: () {
                print('哈哈哈');
                _controller.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              child: Icon(Icons.arrow_upward),
              // child: Icon(Icons.add_a_photo),
            )
          : null,
    );
  }

  // 返回每个隐藏的菜单项
  selectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(
              text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ));
  }

  ScrollController _controller = new ScrollController();
  bool showToTop = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print(_controller.offset);
      if (_controller.offset < 1000 && showToTop) {
        setState(() {
          showToTop = false;
        });
      } else if (_controller.offset >= 1000 && showToTop == false) {
        setState(() {
          showToTop = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: 50,
        itemExtent: 50,
        controller: _controller, //列表项高度固定时，显式指定高度是一个好习惯(性能消耗小)
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text('我说{$index}行'),
                Container(width: 10),
                RaisedButton(
                  child: Text('按钮{$index}'),
                  onPressed: () {
                    print('打印');
                  },
                  textColor: Colors.white,
                  color: Colors.blue[200],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
