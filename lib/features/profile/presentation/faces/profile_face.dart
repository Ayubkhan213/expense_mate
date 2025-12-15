import 'package:expense_mate/core/navigation/route_name.dart';
import 'package:flutter/material.dart';

class ProfileFace extends StatelessWidget {
  const ProfileFace({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteName.template);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text('Template', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10.0),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteName.language);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text('Language', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
