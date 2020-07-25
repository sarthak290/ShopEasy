import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matrix/authentication_bloc/authentication_bloc.dart';
import 'package:matrix/authentication_bloc/bloc.dart';
import 'package:matrix/bloc/locale/bloc.dart';
import 'package:matrix/bloc/theme/bloc.dart';
import 'package:matrix/bloc_delegate.dart';
import 'package:matrix/screens/auth.dart';
import 'package:matrix/screens/home.dart';
import 'package:matrix/screens/intro.dart';
import 'package:matrix/screens/splash.dart';
import 'package:matrix/services/theme_repository.dart';
import 'package:matrix/services/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:matrix/utils/config.dart';
import 'package:matrix/utils/styles.dart';
import 'package:matrix/utils/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/bloc/bloc.dart';
import 'widgets/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await allTranslations.init();

  String theme = await themeRepository.getPreferredTheme();

  theme == null ?? await themeRepository.init("light");

  BlocSupervisor.delegate = AppBlocDelegate();
  final UserRepository userRepository = UserRepository();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository, theme: theme),
    ));
  });
}

class App extends StatefulWidget {
  final UserRepository _userRepository;
  final String theme;
  const App(
      {Key key, @required UserRepository userRepository, this.theme = "light"})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  bool isFirstSeen = false;

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  _onLocaleChanged() async {
    
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    // prefs.setBool('seen', false);
    if (_seen)
      setState(() {
        isFirstSeen = true;
      });
    else {
      setState(() {
        isFirstSeen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleBloc(),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (BuildContext context, LocaleState localeState) {
          return BlocProvider(
            create: (context) =>
                ThemeBloc()..add(ThemeChanged(type: widget.theme)),
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (BuildContext context, ThemeState state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: state.type == "dark"
                      ? buildDarkTheme().copyWith(
                          primaryColor:
                              HexColor(Settings["Setting"]["MainDarkColor"]),
                          buttonColor: HexColor(
                              Settings["Setting"]["SecondaryDarkColor"]),
                          focusColor:
                              HexColor(Settings["Setting"]["MainDarkColor"]),   
                        )
                      : buildLightTheme(
                              HexColor(Settings["Setting"]["MainColor"]))
                          .copyWith(
                          primaryColor:
                              HexColor(Settings["Setting"]["MainColor"]),
                          buttonColor:
                              HexColor(Settings["Setting"]["SecondaryColor"]),
                          focusColor:
                              Colors.lightBlueAccent,    
                        ),

                  locale: localeState is LocaleChangeFailed
                      ? Locale("en")
                      : localeState.locale,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  
                  supportedLocales: allTranslations.supportedLocales(),

                  home: !isFirstSeen
                      ? IntroScreen()
                      : BlocBuilder(
                          bloc: BlocProvider.of<AuthenticationBloc>(context),
                          builder: (BuildContext context,
                              AuthenticationState state) {
                            if (state is Uninitialized) {
                              return SplashCreen();
                            }
                            if (state is Unauthenticated) {
                              return BlocProvider<LoginBloc>(
                                  create: (context) => LoginBloc(
                                      userRepository: widget._userRepository),
                                  child: AuthScreen(
                                      userRepository: widget._userRepository));
                            }

                            if (state is Authenticated) {
                              return StreamBuilder(
                                stream:
                                    UserRepository().getUser(state.user.uid),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasError) {
                                    return SplashCreen();
                                  }

                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return SplashCreen();
                                      break;
                                    default:
                                      return Home(
                                        user: snapshot.data == null &&
                                                snapshot.data.length == 0
                                            ? state.user
                                            : snapshot.data,
                                      );
                                  }
                                },
                              );
                            }

                            return SplashCreen();
                          },
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
