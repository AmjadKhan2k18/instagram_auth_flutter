
import 'instagram.dart' as insta;
import 'package:social_auth/constants.dart';
import '../pages/login_page.dart';

abstract class LoginViewContract {
  void onLoginScuccess(insta.Token token);
  void onLoginError(String message);
}

class LoginPresenter {

  LoginPage loginPage = LoginPage();
  LoginViewContract _view;
  LoginPresenter(this._view);


  void performLogin() {
    assert(_view != null);
    insta.getToken(Constants.appId,
        Constants.appSecret).then((token)
    {
      if (token != null) {
        _view.onLoginScuccess(token);
      }
      else {
        _view.onLoginError('Error');
      }
    });
  }
}