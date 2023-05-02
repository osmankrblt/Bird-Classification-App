import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikipedia/wikipedia.dart';

Future getBirdImageFromWiki(names) async {
  List<List<dynamic>> birdsWithImages = [];
  for (var element in names) {
    String req_url =
        "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=" +
            element.title!.toString();

    http.Response response = await http.get(Uri.parse(req_url));

    Map json_data = (json.decode(response.body) as Map<dynamic, dynamic>);

    print(json_data);
    try {
      birdsWithImages.add([
        element,
        json_data['query']['pages'][element.pageid.toString()]['original']
            ['source']
      ]);
    } on NoSuchMethodError catch (e) {
      birdsWithImages.add([element, Null]);
    }
  }

  return birdsWithImages;
}

Future getWiki(bird_name) async {
  List<WikipediaSearch> _data;
  late Wikipedia instance = Wikipedia();

  WikipediaResponse? result = await instance.searchQuery(
    searchQuery: bird_name,
    limit: 2,
  );

  _data = result!.query!.search!;
  return getBirdImageFromWiki(_data);
}

Future getPageDataWithId(pageId) async {
  Wikipedia instance = Wikipedia();

  var wikiPage = await instance.searchSummaryWithPageId(pageId: pageId);

  return wikiPage;
}
