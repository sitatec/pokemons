/// Represents a [Pokemon](https://en.wikipedia.org/wiki/Pok%C3%A9mon_(video_game_series))
class Pokemon {
  /// The unique **identifier** of the pockemon.
  final int id;
  final String name;
  final int height;
  final int weight;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final List<String> types;
  final String imageUrl;

  /// Represents the BMI got using this formula: [weight] / ([height]^2)
  late final double bmi = weight / (height ^ 2);

  /// A formatted version of the Pockemon's [id] e.g: id = 3, formatedId = #003
  /// id = 232 formatedId = #232.
  late final String formatedId = _formatId();

  /// The average power of this Pockemon. Got usign this formula:
  /// ([hp] + [attack] + [defense] + [specialAttack] + [specialDefense] + [speed]) / 6
  late final double avgPower =
      (hp + attack + defense + specialAttack + specialDefense + speed) / 6;

  /// Construct a [Pokemon]
  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.types,
  });

  String _formatId() {
    String idPrefix = "#";
    if (id < 100) {
      if (id < 10) {
        idPrefix += "00";
      } else {
        idPrefix += "0";
      }
    }
    return "$idPrefix$id";
  }
}
