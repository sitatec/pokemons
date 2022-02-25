import 'package:podedex/domain/data_sources/http_client.dart';

const JsonObject fakePokemonJson = {
  "id": 1,
  "name": "bulbasaur",
  "sprites": {
    "other": {
      "official-artwork": {"front_default": "fake_url"}
    }
  },
  "height": 7,
  "weight": 69,
  "stats": [
    {
      "base_stat": 43,
      "stat": {
        "name": "hp",
      }
    },
    {
      "base_stat": 33,
      "stat": {
        "name": "attack",
      }
    },
    {
      "base_stat": 4,
      "stat": {
        "name": "defense",
      }
    },
    {
      "base_stat": 40,
      "stat": {
        "name": "special-attack",
      }
    },
    {
      "base_stat": 80,
      "stat": {
        "name": "special-defense",
      }
    },
    {
      "base_stat": 40,
      "stat": {
        "name": "speed",
      }
    },
  ],
  "types": [
    {
      "type": {"name": "grass"}
    },
    {
      "type": {"name": "poison"}
    }
  ],
};

JsonObject get newFakePokemonJson => Map.from(fakePokemonJson);
