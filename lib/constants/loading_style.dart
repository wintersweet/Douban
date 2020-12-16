import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget wrapperPlaceholderProgress() => Platform.isAndroid
    ? CircularProgressIndicator()
    : CupertinoActivityIndicator(radius: 15.0);

Widget wrapperLoadingIndicator() => Platform.isAndroid
    ? CircularProgressIndicator()
    : CupertinoActivityIndicator(radius: 20.0);
