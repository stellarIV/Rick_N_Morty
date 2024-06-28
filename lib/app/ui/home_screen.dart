import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/ui/detail_screen.dart';
import 'package:rick_and_morty/app/utils/query.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 1;
  List<Character> characters = [];
  bool isLoadingMore = false;

  Future<void> fetchMoreCharacters(FetchMore? fetchMore, int? nextPage) async {
    if (fetchMore != null && nextPage != null && !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      FetchMoreOptions options = FetchMoreOptions(
        variables: {'page': nextPage},
        updateQuery: (previousResultData, fetchMoreResultData) {
          final List<dynamic> repos = [
            ...previousResultData!["characters"]["results"] as List<dynamic>,
            ...fetchMoreResultData!["characters"]["results"] as List<dynamic>
          ];
          fetchMoreResultData["characters"]["results"] = repos;
          return fetchMoreResultData;
        },
      );
      await fetchMore(options);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 62,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SearchWidget(characters: characters),
            )),
            icon: Icon(Icons.search),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 69, 250, 75),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Query(
            options: QueryOptions(
              document: gql(getAllCharachters),
              variables: {'page': currentPage},
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Center(child: Text(result.exception.toString()));
              }

              if (result.isLoading && characters.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              if (result.data != null) {
                final List<Character> newCharacters =
                    (result.data!["characters"]["results"] as List)
                        .map((e) => Character.fromMap(e))
                        .toList();

                if (currentPage == 1) {
                  characters = newCharacters;
                } else {
                  characters.addAll(newCharacters);
                }

                final int? nextPage =
                    result.data!["characters"]["info"]["next"];

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      currentPage = 1;
                      characters.clear();
                    });
                    await refetch!();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: characters
                                .map((e) => CharacterWidget(character: e))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (nextPage != null)
                          ElevatedButton(
                            onPressed: () =>
                                fetchMoreCharacters(fetchMore, nextPage),
                            child: isLoadingMore
                                ? const CircularProgressIndicator.adaptive()
                                : const Text("Load More"),
                          ),
                      ],
                    ),
                  ),
                );
              }

              return Center(child: Text("Something went wrong"));
            },
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  final List<Character> characters;

  SearchWidget({required this.characters});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Character> _filteredCharacters = [];
  String _selectedFilter = 'Name'; // Default filter criterion

  @override
  void initState() {
    super.initState();
    _filteredCharacters = widget.characters;
  }

  void _handleSearch(String query) {
    setState(() {
      _filteredCharacters = widget.characters.where((char) {
        switch (_selectedFilter) {
          case 'Name':
            return char.name.toLowerCase().contains(query.toLowerCase());
          case 'Status':
            return char.status.toLowerCase().contains(query.toLowerCase());
          case 'Species':
            return char.species.toLowerCase().contains(query.toLowerCase());
          default:
            return true;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search and Filter"),
        backgroundColor: Color.fromARGB(255, 77, 246, 122),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: _handleSearch,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Character Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 15, 71, 118)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list),
                  onSelected: (String value) {
                    setState(() {
                      _selectedFilter = value;
                      _handleSearch(_controller
                          .text); // Reapply the filter with the new criterion
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Name', 'Status', 'Species'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCharacters.length,
              itemBuilder: (context, index) {
                final Character char = _filteredCharacters[index];
                return ListTile(
                  leading: Image.network(
                    char.image,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(char.name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailScreen(id: char.id),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
