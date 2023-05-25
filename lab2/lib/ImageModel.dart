import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageModel {
  final String imageUrl;

  ImageModel({required this.imageUrl});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(imageUrl: json['webformatURL']);
  }
}
