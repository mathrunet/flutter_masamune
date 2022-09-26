part of masamune_cli;

class SigninFacebookCliCommand extends CliCommand {
  const SigninFacebookCliCommand();
  @override
  String get description =>
      "masamune.yamlで指定した`AppID`と`AppSecret`を元にFacebookアカウントでのログイン設定を行ないます。";
  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final sns = yaml.getAsMap("sns");
    if (sns.isEmpty) {
      print("Sns data could not be found.");
      return;
    }
    final facebook = sns.getAsMap("facebook");
    if (facebook.isEmpty) {
      print("Facebook data could not be found.");
      return;
    }
    final id = (facebook["app_id"] as int?)?.toString();
    if (id.isEmpty) {
      print("Facebook settings could not be found.");
      return;
    }
    final app = yaml.getAsMap("app");
    if (app.isEmpty) {
      print("App data could not be found.");
      return;
    }
    final title = app.get("title", "");
    if (title.isEmpty) {
      print("App title could not be found.");
      return;
    }
    currentFiles.forEach((file) {
      var text = File(file.path).readAsStringSync();
      text = text.replaceAll("TODO_REPLACE_NAME_TEMPLATE", title);
      text = text.replaceAll("TODO_REPLACE_FACEBOOK_APP_ID", id!);
      text = text.replaceAll(
        "<!-- TODO_REPLACE_FACEBOOK_URL_SCHEME -->",
        r"""
<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$(FACEBOOK_URL_SCHEME)</string>
			</array>
		</dict>
        """,
      );
      text = text.replaceAll(
        "<!-- TODO_REPLACE_FACEBOOK_MANIFEST -->",
        """
<!-- Facebook Login configuration -->
        <!-- Be sure to comment out when using FirebaseAuth. -->
        <!-- Fall on Android. -->
        <!-- [Firebase] [FirebaseAuth] [FacebookSignIn] -->
        <meta-data android:name="com.facebook.sdk.ApplicationId"
            android:value="@string/facebook_app_id"/>
        <activity android:name="com.facebook.FacebookActivity"
            android:configChanges=
                "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
            android:label="@string/app_name" 
            android:exported="true"
            />
        <activity
            android:name="com.facebook.CustomTabActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="@string/fb_login_protocol_scheme" />
            </intent-filter>
        </activity>
        """,
      );
      File(file.path).writeAsStringSync(text);
    });
  }
}
