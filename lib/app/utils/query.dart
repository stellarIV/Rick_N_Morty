import 'package:graphql_flutter/graphql_flutter.dart';

String getAllCharachters = r"""
  query GetCharachters ($page:Int){
    characters (page:$page) {
      info {
        next
      }
      results {
        id
        status
        species
        gender
        image
        type
        name
        location{
          name
        }
      }
    }
  }
""";
String getCharacterById = r"""
  query GetCharacter($id: ID!) {
    character(id: $id) {
      id
      name
      status
      species
      type
      gender
      origin {
        name
      }
      image
      episode {
        episode
        name
      }
      location {
        name
        dimension
      }
    }
  }
""";
