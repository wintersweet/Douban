import 'user.dart';

class ConstantKey {
  static final int camera_identify_face = 101;
  static final int camera_identify_idcard = 101;
  static final int camera_identify_ercode = 101;

  static final String IDCARD_NUM = "id_card_number";
  static final String IDCARD_NAME = "name";
  static final String Web_Identify_IDCard = "Identify_IDCard";
  //static final String Web_Identify_IDCard = "startIdentifyIDCard";
  static final String Web_Identify_Face = "Identify_Face";
  static final String Web_Identify_QRCode = "Identify_QRCode";
}

class APPApiKey {
  static final String Face_api_key = "yours";
  static final String Face_api_secret = "yours";

  static final String Jpush_app_key = "yours";
  static final String Agora_app_id = "yours";
}

class SharedKey {
  static final String USER_NAME = "user_name";
}

class ConstantObject {
  static User mUser;
  static User getUser() {
    if (mUser == null) {
      mUser = new User();
      mUser.agoraId = "Rose";
    }
    return mUser;
  }
}

class Constant {
  static const String BASE_URL = "https://api.apiopen.top/";

  /// 使用json placeholder mock的静态数据的仓库
  static const String MOCK_REPO = null;
  static const int PAGE_DEFAULT = 20;

  static const String TEST_AVARTAR =
      "https://img1.doubanio.com/view/celebrity/s_ratio_celebrity/public/p10899.jpg";
  static const String TEST_HOME = "https://movie.douban.com/subject/1291546/";
  static const String TEST_HOME_CARD =
      "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p480747492.webp";
  static const String TEST_IMG =
      "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2578721161.jpg";
  static const String TOP_250 = '/v2/movie/top250';

  static const String IMG_TMP1 =
      'https://upload-images.jianshu.io/upload_images/3884536-b21bfc556ffcc062.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240';

  static const String IMG_TMP2 =
      'https://upload-images.jianshu.io/upload_images/3884536-bb35459fd52009d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240';

  static const double MARGIN_LEFT = 13.0;
  static const double MARGIN_RIGHT = 13.0;
  static const String ASSETS_IMG = 'assets/images/';
  static const double TAB_BOTTOM = 8.0;

  static String URL_MP4_DEMO_0 =
      'http://vt1.doubanio.com/201902111139/0c06a85c600b915d8c9cbdbbaf06ba9f/view/movie/M/302420330.mp4';

  static String URL_MP4_DEMO_1 =
      'http://vt1.doubanio.com/201903032315/702b9ad25c0da91e1c693e5e4dc5a86e/view/movie/M/302430864.mp4';

  //视频大纲获取接口
  static String Home_tab = "videoHomeTab";
  //首页新闻接口
  static const String BASE_URL1 = "http://v.juhe.cn/toutiao/";
  static String Home_news =
      "http://v.juhe.cn/toutiao/index?type=top&key=caeaf8b9afdc9c5366d9447df1150e5a";
}
