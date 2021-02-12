part of masamune.list;

/// List tile for ranking.
class RankingListTile extends StatelessWidget {
  /// List tile for ranking.
  ///
  /// [rank]: Rank.
  /// [primaryColor]: The color when the rank is 1st.
  /// [secondaryColor]: The color when the rank is 2 or 3.
  /// [color]: Color when the rank is 4th or lower.
  /// [image]: The tile image.
  /// [title]: Title of the tile.
  /// [trailing]: Trailing tiles.
  /// [onTap]: Call back on tap.
  const RankingListTile({
    required this.rank,
    this.primaryColor,
    this.secondaryColor,
    this.color,
    this.image,
    this.title,
    this.onTap,
    this.trailing,
  });

  /// Rank.
  final int rank;

  /// The color when the rank is 1st.
  final Color? primaryColor;

  /// The color when the rank is 2 or 3.
  final Color? secondaryColor;

  /// Color when the rank is 4th or lower.
  final Color? color;

  /// The tile image.
  final ImageProvider? image;

  /// Title of the tile.
  final String? title;

  /// Trailing tiles.
  final Widget? trailing;

  /// Call back on tap.
  final VoidCallback? onTap;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: 60,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1,
                  color: context.theme.dividerColor,
                ),
              ),
            ),
            child: Text(rank.toString(),
                style: TextStyle(
                  color: _getColor(context),
                  fontWeight: _getWeight(context),
                  fontSize: 32,
                ),
                textAlign: TextAlign.center),
          ),
          const Space.width(20),
          if (image != null) ...[
            SizedBox(
              width: 36,
              height: 36,
              child: CircleAvatar(
                backgroundColor: context.theme.disabledColor,
                backgroundImage: image,
              ),
            ),
            const Space.width(20),
          ],
          Expanded(
            child: Text(
              title ?? "",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (trailing != null) ...[
            const Space.width(5),
            trailing!,
            const Space.width(10),
          ]
        ],
      ),
    );
  }

  Color _getColor(BuildContext context) {
    if (rank <= 1) {
      return primaryColor ?? context.theme.primaryColor;
    } else if (rank <= 3) {
      return secondaryColor ?? context.theme.accentColor;
    } else {
      return color ?? context.theme.disabledColor;
    }
  }

  FontWeight _getWeight(BuildContext context) {
    if (rank <= 1) {
      return FontWeight.w800;
    } else if (rank <= 3) {
      return FontWeight.w600;
    } else {
      return FontWeight.w400;
    }
  }
}
