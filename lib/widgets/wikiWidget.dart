import 'package:flutter/material.dart';

import '../utils/utils.dart';

class WikiWidget extends StatelessWidget {
  var bird;

  WikiWidget({
    Key? key,
    required this.bird,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var _birdWiki = await getPageDataWithId(bird[0].pageid);
        if (_birdWiki == null) {
          const snackBar = SnackBar(
            content: Text('Data Not Found'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
              appBar: AppBar(
                title: Text(bird[0].title!,
                    style: const TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  bird[1] != Null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            bird[1],
                          ),
                        )
                      : SizedBox(),
                  Text(
                    _birdWiki.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _birdWiki.description!,
                    style: const TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _birdWiki.extract!,
                  )
                ],
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bird[1] != Null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        bird[1],
                      ),
                    )
                  : SizedBox(),
              Text(
                bird[0].title!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                bird[0].snippet!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
