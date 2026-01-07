import 'package:expense_mate/core/app_export.dart';

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
            SizedBox(height: 10.0),
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (p, c) => p.status != c.status,
              listener: (context, state) {
                if (state.status == AuthStatus.unauthenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteName.login,
                    (_) => false,
                  );
                }
              },
              child: InkWell(
                onTap: () {
                  print('inkwell');
                  context.read<AuthBloc>().add(LogoutEvent());
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('Log OuT', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
