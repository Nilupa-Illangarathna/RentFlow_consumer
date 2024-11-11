import 'package:flutter/material.dart';

import '../../global/responsiveness.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final bool isActive;
  final String? profileImageUrl;

  ProfileWidget({required this.name, required this.isActive, this.profileImageUrl,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Color(0xFFECF2ED),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFADF2C6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 22,
                      height: 24,
                      child: ClipOval(
                        child: profileImageUrl != null
                            ? Image.network(profileImageUrl!)
                            : Image.asset(
                          'assets/images/homepage/profile.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: isActive ? Color(0xFF00AB63) : Colors.red),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFF00AB63) : Colors.red,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  isActive ? 'Active' : 'Disabled',
                  style: TextStyle(
                    color: isActive ? Color(0xFF00AB63) : Colors.red,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}