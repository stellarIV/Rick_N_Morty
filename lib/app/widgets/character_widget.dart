import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/ui/detail_screen.dart';

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(character.name);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(id: character.id)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .43,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.lightGreen)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              //image
              alignment: Alignment.centerLeft,
              width: double.maxFinite,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: CachedNetworkImage(
                imageUrl: character.image,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                  height: 100,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.red,
                ),
                // character.image,
                // width: MediaQuery.of(context).size.width * .43,
                // fit: BoxFit.fitWidth,
              ),
            ),
            //spacing
            const SizedBox(
              height: 8,
            ),
            //all, only(top: 8)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Text(
                            character.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      const SizedBox(
                        width: 4,
                      ),
                      // Text(character.gender),
                      Tooltip(
                        message: character.status,
                        child: Icon(
                          Icons.circle,
                          size: 12,
                          color: character.status.toLowerCase() == "alive"
                              ? Colors.green
                              : character.status.toLowerCase() == "unknown"
                                  ? Colors.grey
                                  : Colors.red,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndLabel(
                            label: character.species,
                            icon: Icons.psychology_outlined),
                        IconAndLabel(
                            label: character.gender,
                            icon: (character.gender.toLowerCase() == "Female"
                                ? (Icons.female_outlined)
                                : character.gender.toLowerCase() == "Male"
                                    ? (Icons.male_outlined)
                                    : Icons.male_rounded)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (character.type.isNotEmpty)
                    IconAndLabel(
                      label: character.type,
                      icon: Icons.coronavirus_outlined,
                      flexible: true,
                    ),
                  IconAndLabel(
                    label: character.location,
                    icon: Icons.location_city_outlined,
                    flexible: true,
                  ),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IconAndLabel extends StatelessWidget {
  IconAndLabel(
      {super.key,
      required this.label,
      required this.icon,
      this.flexible = false});
  final String label;
  final IconData icon;
  final bool flexible;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(
        icon,
        size: 16,
      ),
      const SizedBox(
        width: 6,
      ),
      //all space on area
      flexible
          ? Flexible(
              flex: 1,
              child: Text(
                label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : Text(
              label,
              // maxLines: 2,overflow: TextOverflow.ellipsis,
            ),
    ]);
  }
}
