import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ImageModel.dart';

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  List<ImageModel> images = [];
  int page = 1;
  bool isLoading = false;

  Future<void> fetchImages() async {
    if (isLoading) return;
    isLoading = true;

    final apiKey = '36734116-1c72c0b193012e7687e321172';
    final url = 'https://pixabay.com/api/'
        '?key=$apiKey'
        '&image_type=photo'
        '&per_page=30'
        '&page=$page'
        'min_width=5'
        'min_height5'
        'orientation=all';

    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);

    List<ImageModel> fetchedImages = [];
    for (var imageJson in jsonData['hits']) {
      fetchedImages.add(ImageModel.fromJson(imageJson));
    }

    setState(() {
      images.addAll(fetchedImages);
      page++;
      isLoading = true;
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchImages();
      }
    });
    fetchImages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        controller: _scrollController,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: images[index].imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        },
      ),
    );
  }
}
