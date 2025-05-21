// lib/library/othman/CustomWidgets.dart
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:aabu_project/library/GV.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/classes/Classes.dart';
import 'package:aabu_project/screens/edit_post/edit_post_step1.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Jop Post Card
class JopCard extends StatefulWidget {
  JopCard({
    super.key,
    required this.J,
    this.MyPost = false,
    this.saved = false,
  });
  Jop J;
  bool MyPost;
  bool saved;
  @override
  State<JopCard> createState() => _JopCardState();
}

class _JopCardState extends State<JopCard> {
  late String title;
  late String price;
  late String imageUrl;
  late String location;
  final JobApi _jobApi = JobApi();

  @override
  Widget build(BuildContext context) {
    title = widget.J.title;
    price = "\$ ${widget.J.price}";
    imageUrl = widget.J.images.isNotEmpty
        ? widget.J.images[0]
        : 'assets/UniversalPlaceholder.jpg';
    location = "${widget.J.city}، ${widget.J.town}";

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          if (widget.MyPost == true) {
            Navigator.pushNamed(
              context,
              '/MyPost',
              arguments: widget.J,
            );
          } else {
            Navigator.pushNamed(
              context,
              '/NotMyPost',
              arguments: widget.J,
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      print('Image load error: $error');
                      return Image.asset(
                        'assets/UniversalPlaceholder.jpg',
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingIcon(rate: widget.J.rating.rate),
                        SizedBox(width: 8),
                        Text("${widget.J.rating.rate.toStringAsFixed(1)}",
                            style: GS),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.MyPost
                            ? SizedBox(
                                child: CustomButton(
                                  label: "تعديل",
                                  action: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPostStep1(job: widget.J),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  final response = widget.saved
                                      ? await _jobApi.unsaveJob(widget.J.id)
                                      : await _jobApi.saveJob(widget.J.id);
                                  if (response['success']) {
                                    setState(() {
                                      widget.saved = !widget.saved;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(response['error'])),
                                    );
                                  }
                                },
                                child: widget.saved
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                              ),
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          child: Text(title, style: BBM),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          child: Text(price, style: GM),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 30,
                          child: Text(location, style: GS),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Button
class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.label,
      this.action,
      this.BG = orange,
      this.width});
  double? width;
  final String label;
  Function()? action;
  Color BG;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(BG),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Custom Rating Icon
class RatingIcon extends StatelessWidget {
  RatingIcon({super.key, required this.rate});
  double rate;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          rate <= 0
              ? Icon(Icons.star_border_rounded, color: gray)
              : (rate >= 1
                  ? Icon(Icons.star_rounded, color: gray)
                  : Icon(Icons.star_half_rounded, color: gray)),
          rate <= 1
              ? Icon(Icons.star_border_rounded, color: gray)
              : (rate >= 2
                  ? Icon(Icons.star_rounded, color: gray)
                  : Icon(Icons.star_half_rounded, color: gray)),
          rate <= 2
              ? Icon(Icons.star_border_rounded, color: gray)
              : (rate >= 3
                  ? Icon(Icons.star_rounded, color: gray)
                  : Icon(Icons.star_half_rounded, color: gray)),
          rate <= 3
              ? Icon(Icons.star_border_rounded, color: gray)
              : (rate >= 4
                  ? Icon(Icons.star_rounded, color: gray)
                  : Icon(Icons.star_half_rounded, color: gray)),
          rate <= 4
              ? Icon(Icons.star_border_rounded, color: gray)
              : (rate >= 5
                  ? Icon(Icons.star_rounded, color: gray)
                  : Icon(Icons.star_half_rounded, color: gray)),
        ],
      ),
    );
  }
}

// Custom Comment Card
class CommentCard extends StatelessWidget {
  CommentCard({super.key, required this.comment, this.onDelete});
  Comment comment;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isMyComment =
        currentUser != null && comment.userId == currentUser.uid;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              height: 80,
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: comment.userImage.isNotEmpty
                    ? Image.network(
                        comment.userImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/UniversalPlaceholder.jpg',
                            fit: BoxFit.fitWidth,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/UniversalPlaceholder.jpg',
                        fit: BoxFit.fitWidth,
                      ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(comment.username, style: BS),
                        RatingIcon(rate: comment.rating.rate),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(comment.comment, style: GS),
                  ),
                ],
              ),
            ),
            if (isMyComment)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

// Dropdown Button
class CustomDropdown extends StatefulWidget {
  List<String> options;
  String? initialValue;
  ValueChanged<String?>? onChanged;

  CustomDropdown({
    super.key,
    this.initialValue,
    this.onChanged,
    required this.options,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = _getValidValue();
  }

  String? _getValidValue() {
    if (widget.initialValue != null &&
        widget.options.contains(widget.initialValue)) {
      return widget.initialValue;
    }
    return widget.options.isNotEmpty ? widget.options.first : null;
  }

  @override
  Widget build(BuildContext context) {
    selectedValue = _getValidValue();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: lightblue, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          items: widget.options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option, style: GS),
                ),
              )
              .toList(),
          onChanged: (value) {
            selectedValue = value;
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
      ),
    );
  }
}

// Custom Container
class CustomContainer extends StatefulWidget {
  CustomContainer({super.key, required this.Children});
  List<Widget> Children;
  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widget.Children,
      ),
    );
  }
}

// Add Rating Icon
class AddRating extends StatefulWidget {
  final ValueChanged<double> onRatingChanged;
  const AddRating({super.key, required this.onRatingChanged});

  @override
  State<AddRating> createState() => _AddRatingState();
}

class _AddRatingState extends State<AddRating> {
  double rate = 0.0;
  Color mainColor = orange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 1; i <= 5; i++)
          IconButton(
            onPressed: () {
              setState(() {
                rate = i.toDouble();
                widget.onRatingChanged(rate);
              });
            },
            icon: i <= rate
                ? Icon(Icons.star_rounded, color: mainColor)
                : Icon(Icons.star_border_rounded, color: mainColor),
          ),
      ],
    );
  }
}
// Custom delete warning Component
