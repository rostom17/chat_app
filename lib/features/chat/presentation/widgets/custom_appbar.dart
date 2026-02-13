
import 'package:chat_app/core/config/size_config.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/features/chat/presentation/screens/chat_message_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.widget,
  });

  final ChatMessageScreen widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: SizeConfig.isLightMode
              ? AppColors.backgroundColorDark
              : Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: .start,
        children: [
          CircleAvatar(
            backgroundColor: SizeConfig.isLightMode
                ? AppColors.primaryColor.withAlpha(50)
                : AppColors.primaryColor,
            child: Text(
              widget.chat.profilePicture,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SizeConfig.isLightMode
                        ? AppColors.blackColor
                        : AppColors.whiteColor,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: SizeConfig.isLightMode
                        ? Colors.grey[700]
                        : Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.video_camera_front,
            color: SizeConfig.isLightMode ? Colors.black : Colors.grey[200],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.call,
            color: SizeConfig.isLightMode ? Colors.black : Colors.grey[200],
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}