import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

const String clientId = 'HzqaJiaRQWDGRrvQ6B9dlCbVAxaIhswf';
const String clinentSecret =
    '_V5V01pqn8v2sd4i7LrmqN05H8Z6JHyZ1KJOrM5vmAYenPMYiD0u5_uULV9GCkmt';
const String redirectUri =
    'auth.sample.app.authSampleApp://dev-sqnvrmu6wzlyxszz.us.auth0.com/ios/auth.sample.app.authSampleApp/callback';
const String authorizationEndpoint =
    'https://dev-sqnvrmu6wzlyxszz.us.auth0.com/authorize';
const String tokenEndpoint =
    'https://dev-sqnvrmu6wzlyxszz.us.auth0.com/oauth/token';
const List<String> scopes = ['openid', 'profile', 'email', 'offline_access'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accessToken = useState('');
    final refreshToken = useState('');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('auth sample app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await _login();
                if (result != null) {
                  accessToken.value = result['accessToken'];
                  refreshToken.value = result['refreshToken'];
                }
              },
              child: const Text('auth0 login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _logout();
              },
              child: const Text('auth0 logout'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Access token:',
            ),
            Text(
              accessToken.value == '' ? 'null' : accessToken.value,
            ),
            const SizedBox(height: 20),
            const Text(
              'refresh token:',
            ),
            Text(
              refreshToken.value == '' ? 'null' : refreshToken.value,
            ),
          ],
        ),
      ),
    );
  }
}

Future _login() async {
  try {
    const FlutterAppAuth appAuth = FlutterAppAuth();

    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        clientId,
        redirectUri,
        clientSecret: clinentSecret,
        // promptValues: ['login'],
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: authorizationEndpoint,
          tokenEndpoint: tokenEndpoint,
          // endSessionEndpoint:
        ),
        // discoveryUrl:
        scopes: scopes,
      ),
    );

    if (result != null) {
      print('Access token: ${result.accessToken}');
      return {
        'accessToken': result.accessToken,
        'refreshToken': result.refreshToken
      };
    }
  } catch (e) {
    print('Login error: $e');
    return;
  }
}

Future<void> _logout() async {
  final dio = Dio();
  try {
    final response = dio.get(
        'https://dev-sqnvrmu6wzlyxszz.us.auth0.com/v2/logout?cliten_id=$clientId');
    print('logout response: ${response}');
  } catch (e) {
    print('logout error: $e');
  }
}
