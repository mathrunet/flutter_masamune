part of masamune.list;

/// List tiles for comment.
class CommentTile extends StatelessWidget {
  /// List tiles for comment.
  const CommentTile({
    this.image,
    this.avatar,
    this.name,
    this.date,
    this.format = "yyyy/MM/dd HH:mm",
    required this.text,
  });

  /// Format.
  final String format;

  /// Picture.
  final ImageProvider? image;

  /// Avatar image.
  final ImageProvider? avatar;

  /// Name.
  final String? name;

  /// Posting Date.
  final DateTime? date;

  /// Comments.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatar != null) ...[
            SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                backgroundImage: avatar,
              ),
            ),
            const Space.width(20),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty || date != null)
                  Text(
                    (name.isNotEmpty ? "$name " : "") +
                        (date != null ? date!.format(format) : ""),
                    style: context.theme.textTheme.caption,
                  ),
                const Space(),
                Text(
                  text,
                ),
                if (image != null) ...[
                  const Space(),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    constraints: const BoxConstraints.expand(height: 200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(image: image!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
