class BasicTile {
  final String title;
  final List<BasicTile> titles;
  const BasicTile({required this.title, this.titles = const []});
}

final basicTiles = <BasicTile>[
  const BasicTile(title: 'Fruits', titles: [
    BasicTile(title: 'Apple'),
    BasicTile(title: 'Orange'),
    BasicTile(title: 'Banana'),
    BasicTile(title: 'Watermelon')
  ]),
  const BasicTile(title: 'Continents', titles: [
    BasicTile(title: 'Asia', titles: [
      BasicTile(title: 'Afghanistan'),
      BasicTile(title: 'Iraq'),
    ]),
    BasicTile(title: 'Europe'),
    BasicTile(title: 'Africa'),
    BasicTile(title: 'America')
  ]),
  const BasicTile(title: 'Fruits', titles: [
    BasicTile(title: 'Apple'),
    BasicTile(title: 'Orange'),
    BasicTile(title: 'Banana'),
    BasicTile(title: 'Watermelon')
  ]),
];
