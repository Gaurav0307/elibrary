import '../common/helper/dialog_helper.dart';
import '../common/services/app_exceptions.dart';

mixin BaseController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      // DialogHelper.showErrorDialog(description: message);
      DialogHelper.showErrorSnackBar(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      // DialogHelper.showErrorDialog(description: message);
      DialogHelper.showErrorSnackBar(description: message);
    } else if (error is ApiNotRespondingException) {
      // DialogHelper.showErrorDialog(
      //     description: 'Oops! It took longer to respond.');
      DialogHelper.showErrorSnackBar(
          description: 'Oops! It took longer to respond.');
    }
  }

  void showMessage({
    String title = "Info",
    String? description = "Description",
  }) {
    DialogHelper.showSnackBar(title: title, description: description);
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}
