import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:rick_and_morty/app/utils/query.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    // accept id ------------------Check
    // query detail----------------Check
    // show detail-----------------Check
    //print("DEtail screen: $id");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 93, 244, 131),
        title: Image.asset(
          "assets/logo.png",
          height: 62,
        ),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(
              getCharacterById), // this is the query string you just created
          variables: {
            'id': id,
          },
          pollInterval: const Duration(seconds: 10),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          final character = result.data?['character'];

          return ListView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    character['image'] ?? '',
                    height: 250, // Adjust the height as needed
                    width: 250, // Adjust the width as needed
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Name: ${character['name']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Status: ${character['status'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 57, 165, 254),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Species: ${character['species'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 57, 165, 254),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Gender: ${character['gender'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 57, 165, 254),
                  ),
                ),
                Text(
                  'Origin: ${character['origin']['name'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 57, 165, 254),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Location: ${character['location']['name'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 57, 165, 254),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Episodes:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ...List<Widget>.from(character['episode'].map((ep) {
                  return Wrap(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [Colors.blue[50]!, Colors.teal[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Text(
                            'Episode ${ep['name'] ?? 'Unknown'} : ${ep['episode'] ?? 'Unknown'}'),
                      ),
                    ],
                  );
                })),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ]
              // itemCount: characters.l,

              );
        },
      ),
    );
  }
}
